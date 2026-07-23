#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import re
import shlex
import shutil
import statistics
import subprocess
import sys
import tempfile
import time
from pathlib import Path

try:
    import psutil
except ImportError:
    sys.exit("error: psutil is required. install with: pip install psutil")


MB = 1024 * 1024
SAMPLE_HZ = 200  # RSS polling rate
MIN_OUTPUT_BYTES = 64  # a real script run emits KBs


# ---------- running ----------

def run_once(fasb, program, script, clingo_models, timeout, sample_hz, driver="arg", fasb_args=()):
    cmd = [fasb, str(program), str(clingo_models), *fasb_args]
    stdin = subprocess.DEVNULL
    script_f = None
    if script:
        if driver == "stdin":
            script_f = open(script, "rb")
            stdin = script_f
        else:
            cmd.append(str(script))

    out_f = tempfile.TemporaryFile()
    start = time.perf_counter()
    proc = subprocess.Popen(
        cmd,
        stdout=out_f,
        stderr=subprocess.DEVNULL,
        stdin=stdin,
    )
    if script_f:
        script_f.close()
    try:
        ps = psutil.Process(proc.pid)
    except psutil.NoSuchProcess:
        ps = None

    peak = total = samples = 0
    interval = 1.0 / sample_hz
    deadline = start + timeout if timeout and timeout > 0 else None
    timed_out = False

    while proc.poll() is None:
        if deadline and time.perf_counter() > deadline:
            timed_out = True
            kill_tree(proc)
            break
        if ps:
            try:
                rss = ps.memory_info().rss
                for child in ps.children(recursive=True):
                    try:
                        rss += child.memory_info().rss
                    except psutil.Error:
                        pass
                peak = max(peak, rss)
                total += rss
                samples += 1
            except psutil.Error:
                pass
        time.sleep(interval)

    proc.wait()
    out_f.seek(0, os.SEEK_END)
    out_bytes = out_f.tell()
    out_f.close()
    return {
        "wall_s": time.perf_counter() - start,
        "peak_rss_mb": peak / MB,
        "mean_rss_mb": (total / samples / MB) if samples else 0.0,
        "exit_code": proc.returncode if proc.returncode is not None else -1,
        "timed_out": timed_out,
        "out_bytes": out_bytes,
    }


def kill_tree(proc):
    try:
        parent = psutil.Process(proc.pid)
        for child in parent.children(recursive=True):
            try:
                child.kill()
            except psutil.Error:
                pass
        parent.kill()
    except psutil.Error:
        pass
    try:
        proc.wait(timeout=5)
    except Exception:
        pass


def summarize(runs, min_output=MIN_OUTPUT_BYTES):
    ok = [r for r in runs if not r["timed_out"] and r["exit_code"] == 0
          and r.get("out_bytes", min_output) >= min_output]
    if not ok:
        return {"ok_runs": 0, "failures": len(runs)}
    walls = [r["wall_s"] for r in ok]
    peaks = [r["peak_rss_mb"] for r in ok]
    return {
        "ok_runs": len(ok),
        "failures": len(runs) - len(ok),
        "mean_wall_s": statistics.fmean(walls),
        "median_wall_s": statistics.median(walls),
        "stdev_wall_s": statistics.stdev(walls) if len(walls) > 1 else 0.0,
        "min_wall_s": min(walls),
        "max_wall_s": max(walls),
        "mean_peak_mb": statistics.fmean(peaks),
        "mean_rss_mb": statistics.fmean(r["mean_rss_mb"] for r in ok),
    }


# ---------- discovery ----------

def resolve_script(problem_dir, meta, script_name, scripts_dir):
    chosen = None
    if meta.get("script"):
        chosen = meta["script"]
    elif meta.get("scripts"):
        entries = meta["scripts"]
        if script_name:
            chosen = next((e["path"] for e in entries
                           if e.get("name") == script_name), None)
            if chosen is None:
                names = ", ".join(e.get("name", "?") for e in entries)
                sys.exit(f"error: script '{script_name}' not in "
                         f"{problem_dir}/meta.json (have: {names})")
        else:
            chosen = entries[0]["path"]

    if chosen is None:
        return None
    if scripts_dir:
        return (Path(scripts_dir).resolve() / Path(chosen).name).resolve()
    return (problem_dir / chosen).resolve()


def discover(root, filter_re, script_name=None, scripts_dir=None):
    if not root.exists():
        sys.exit(f"error: benchmarks dir not found: {root}")

    for domain_dir in sorted(p for p in root.iterdir() if p.is_dir()):
        for problem_dir in sorted(p for p in domain_dir.iterdir() if p.is_dir()):
            name = f"{domain_dir.name}/{problem_dir.name}"
            if filter_re and not filter_re.search(name):
                continue

            meta_path = problem_dir / "meta.json"
            description = ""
            script = None
            instances = []

            if meta_path.exists():
                meta = json.loads(meta_path.read_text())
                description = meta.get("description", "")
                script = resolve_script(problem_dir, meta, script_name, scripts_dir)
                for inst in meta.get("instances", []):
                    instances.append({
                        "size": int(inst["size"]),
                        "program": problem_dir / inst["program"],
                    })
            else:
                fsb = sorted(problem_dir.glob("*.fsb"))
                if fsb:
                    script = fsb[0].resolve()
                for lp in sorted(problem_dir.glob("*.lp")):
                    m = re.search(r"\d+", lp.stem)
                    size = int(m.group()) if m else len(lp.read_bytes())
                    instances.append({"size": size, "program": lp})
                instances.sort(key=lambda x: x["size"])

            if instances:
                yield {
                    "name": name,
                    "description": description,
                    "script": script,
                    "instances": instances,
                }


# ---------- formatting ----------

def fmt_s(s):
    if s < 1e-3:
        return f"{s * 1e6:.1f} µs"
    if s < 1.0:
        return f"{s * 1e3:.2f} ms"
    return f"{s:.3f} s"


def print_instance(size, program, s):
    if not s.get("ok_runs"):
        print(f"   size={size:<6} {program}  -- no successful runs "
              f"({s.get('failures', 0)} failed)")
        return
    print(f"   size={size:<6} {program}  "
          f"mean {fmt_s(s['mean_wall_s'])}  median {fmt_s(s['median_wall_s'])}  "
          f"σ {fmt_s(s['stdev_wall_s'])}  peak {s['mean_peak_mb']:.1f} MB")


# ---------- run command ----------

def cmd_run(args):
    fasb = args.fasb or shutil.which("fasb")
    if not fasb:
        sys.exit("error: fasb not found. pass --fasb /path/to/fasb")

    root = Path(args.benchmarks).resolve()
    filter_re = re.compile(args.filter) if args.filter else None
    problems = list(discover(root, filter_re, args.script, args.scripts_dir))
    if not problems:
        sys.exit(f"error: no problems found under {root}")

    fasb_args = shlex.split(args.fasb_args) if args.fasb_args else []

    print(f"fasb benchmark  (k={args.k}, warmup={args.warmup}, timeout={args.timeout}s)")
    print(f"benchmarks: {root}")
    print(f"script:     {args.script or '(first in meta)'}"
          f"{'  dir=' + args.scripts_dir if args.scripts_dir else ''}"
          f"  driver={args.driver}")
    if fasb_args:
        print(f"fasb args:  {' '.join(fasb_args)}")
    print(f"problems:   {len(problems)}\n")

    results = []
    for prob in problems:
        print(f"== {prob['name']} ==")
        if prob["description"]:
            print(f"   {prob['description']}")
        script = prob["script"]

        instances = []
        for inst in prob["instances"]:
            program, size = inst["program"], inst["size"]
            if not program.exists():
                print(f"   missing program: {program}")
                continue

            for _ in range(args.warmup):
                run_once(fasb, program, script, args.clingo_models,
                         args.timeout, args.sample_hz, args.driver, fasb_args)
            runs = [run_once(fasb, program, script, args.clingo_models,
                             args.timeout, args.sample_hz, args.driver, fasb_args)
                    for _ in range(args.k)]

            summary = summarize(runs, args.min_output_bytes)
            instances.append({"size": size, "program": program.name,
                              "runs": runs, **summary})
            print_instance(size, program.name, summary)

        results.append({
            "name": prob["name"],
            "description": prob["description"],
            "script": str(script) if script else None,
            "instances": instances,
        })
        print()

    out = {
        "schema": "fasb-bench/simple",
        "config": {
            "k": args.k,
            "warmup": args.warmup,
            "timeout_s": args.timeout,
            "sample_hz": args.sample_hz,
            "clingo_models": args.clingo_models,
            "script": args.script,
            "scripts_dir": args.scripts_dir,
            "driver": args.driver,
            "fasb_args": args.fasb_args,
        },
        "results": results,
    }
    out_path = Path(args.out).resolve()
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(out, indent=2))
    print(f"saved: {out_path}")
    return 0


# ---------- show command ----------

def cmd_show(args):
    path = Path(args.results).resolve()
    if not path.exists():
        sys.exit(f"error: file not found: {path}")
    data = json.loads(path.read_text())
    cfg = data.get("config", {})

    print(f"fasb benchmark — {path.name}")
    print(f"k={cfg.get('k')}  warmup={cfg.get('warmup')}  "
          f"timeout={cfg.get('timeout_s')}s\n")

    for prob in data.get("results", []):
        print(f"== {prob['name']} ==")
        for inst in prob["instances"]:
            print_instance(inst["size"], inst["program"], inst)
            if args.verbose:
                for i, r in enumerate(inst["runs"], 1):
                    status = ("timeout" if r["timed_out"]
                              else f"exit={r['exit_code']}" if r["exit_code"]
                              else "ok")
                    print(f"      run {i}: {fmt_s(r['wall_s'])}  "
                          f"peak {r['peak_rss_mb']:.1f} MB  [{status}]")
        print()
    return 0


# ---------- compare command ----------

def flatten(data):
    out = {}
    for prob in data.get("results", []):
        for inst in prob["instances"]:
            if inst.get("ok_runs"):
                out[(prob["name"], inst["size"])] = inst
    return out


def geomean(values):
    if not values:
        return 1.0
    return statistics.geometric_mean(values)


def cmd_compare(args):
    base_path = Path(args.baseline).resolve()
    cur_path = Path(args.current).resolve()
    for p in (base_path, cur_path):
        if not p.exists():
            sys.exit(f"error: file not found: {p}")

    base = flatten(json.loads(base_path.read_text()))
    cur = flatten(json.loads(cur_path.read_text()))
    threshold = args.threshold  # ± relative band treated as noise (insignificant)

    print(f"fasb benchmark — compare (threshold ±{threshold * 100:.0f}%)")
    print(f"  baseline: {base_path.name}")
    print(f"  current:  {cur_path.name}\n")
    print(f"  {'benchmark':<28} {'size':>6}  {'baseline':>10}  {'current':>10}  "
          f"{'Δ wall':>8}  {'Δ peak':>8}  note")

    n_faster = n_slower = n_neutral = 0
    wall_ratios = []
    peak_ratios = []

    for key in sorted(set(base) | set(cur)):
        name, size = key
        b, c = base.get(key), cur.get(key)
        if b is None:
            print(f"  {name:<28} {size:>6}  {'—':>10}  "
                  f"{fmt_s(c['mean_wall_s']):>10}  {'(added)':>8}")
            continue
        if c is None:
            print(f"  {name:<28} {size:>6}  {fmt_s(b['mean_wall_s']):>10}  "
                  f"{'—':>10}  {'(removed)':>8}")
            continue

        bw, cw = b["mean_wall_s"], c["mean_wall_s"]
        bp, cp = b["mean_peak_mb"], c["mean_peak_mb"]
        rel_wall = (cw - bw) / bw if bw > 0 else 0.0
        rel_peak = (cp - bp) / bp if bp > 0 else 0.0
        wall_ratios.append(cw / bw if bw > 0 else 1.0)
        peak_ratios.append(cp / bp if bp > 0 else 1.0)

        if abs(rel_wall) < threshold:
            note = "·"
            n_neutral += 1
        elif rel_wall > 0:
            note = "slower"
            n_slower += 1
        else:
            note = "faster"
            n_faster += 1

        print(f"  {name:<28} {size:>6}  {fmt_s(bw):>10}  {fmt_s(cw):>10}  "
              f"{rel_wall * 100:+7.1f}%  {rel_peak * 100:+7.1f}%  {note}")

    geo_wall = geomean(wall_ratios)
    geo_peak = geomean(peak_ratios)
    print(f"\n  faster: {n_faster}   slower: {n_slower}   "
          f"within ±{threshold * 100:.0f}%: {n_neutral}")
    print(f"  geomean wall ratio: {geo_wall:.3f} ({(geo_wall - 1) * 100:+.1f}%)  "
          f"— <1.0 means current is faster")
    print(f"  geomean peak ratio: {geo_peak:.3f} ({(geo_peak - 1) * 100:+.1f}%)  "
          f"— <1.0 means current uses less RAM")
    return 0


# ---------- main ----------

def main(argv):
    p = argparse.ArgumentParser(description="Local fasb benchmark runner.")
    sub = p.add_subparsers(dest="cmd", required=True)

    pr = sub.add_parser("run", help="run benchmarks")
    pr.add_argument("--benchmarks", default="benchmarks",
                    help="benchmarks root dir (default: ./benchmarks)")
    pr.add_argument("-k", type=int, default=5,
                    help="measured runs per instance (default: 5)")
    pr.add_argument("--warmup", type=int, default=1,
                    help="discarded warmup runs (default: 1)")
    pr.add_argument("--timeout", type=float, default=60.0,
                    help="per-run timeout seconds, 0=none (default: 60)")
    pr.add_argument("--out", default="results.json",
                    help="output JSON path (default: results.json)")
    pr.add_argument("--fasb", default=None,
                    help="fasb binary path (default: search PATH)")
    pr.add_argument("--fasb-args", default=None,
                    help="extra flags passed to fasb, e.g. --fasb-args='--fast -v' "
                         "(split like a shell line; use '=' since the value starts "
                         "with '-', or argparse mistakes it for another option)")
    pr.add_argument("--filter", default=None,
                    help="regex; only run matching <domain>/<problem>")
    pr.add_argument("--script", default=None,
                    help="name of the script variant from meta.json 'scripts' "
                         "(e.g. all, enum, reason). default: first listed")
    pr.add_argument("--scripts-dir", default=None,
                    help="override script directory, keeping the chosen "
                         "filename (e.g. scripts_new). default: path in meta.json")
    pr.add_argument("--driver", choices=["arg", "stdin"], default="arg",
                    help="how the script reaches fasb: 'arg' = positional file "
                         "(interpreter builds), 'stdin' = piped to the REPL "
                         "(repl builds). default: arg")
    pr.add_argument("--min-output-bytes", type=int, default=MIN_OUTPUT_BYTES,
                    help="a run must emit at least this many stdout bytes to "
                         "count as successful; guards against banner-only "
                         f"no-op runs (default: {MIN_OUTPUT_BYTES})")
    pr.add_argument("--clingo-models", default="0",
                    help="clingo model count arg passed to fasb (default: 0 = all)")
    pr.add_argument("--sample-hz", type=int, default=SAMPLE_HZ,
                    help=f"RSS sample rate Hz (default: {SAMPLE_HZ})")
    pr.set_defaults(func=cmd_run)

    ps = sub.add_parser("show", help="display a saved results JSON")
    ps.add_argument("results", help="path to results JSON")
    ps.add_argument("--verbose", "-v", action="store_true",
                    help="print individual runs")
    ps.set_defaults(func=cmd_show)

    pc = sub.add_parser("compare", help="diff two results (baseline vs current)")
    pc.add_argument("baseline", help="path to baseline results JSON")
    pc.add_argument("current", help="path to current results JSON")
    pc.add_argument("--threshold", type=float, default=0.05,
                    help="±relative band treated as insignificant (default: 0.05 = ±5%%)")
    pc.set_defaults(func=cmd_compare)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
