# Benchmarker for fasb

A small CLI for timing and profiling `fasb` runs across a set of test problems, so you can tell whether a change made things faster, slower, or hungrier for memory.

For each benchmark it drives `fasb` through a `.fsb` script a few times, throws away the first run or two as warmup, and records wall-clock time and RSS memory for the rest. Run it against two
builds and diff the results with `compare` to get a per-benchmark and overall speed/memory delta.

## Setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install psutil
```

## How it's organized

```
benchmarks/<domain>/<problem>/   problem definitions: meta.json + one or more .lp instances
scripts/                         .fsb driver scripts, shared across all problems
```

Each problem directory (e.g. `benchmarks/planning/blocks/`) has a `meta.json` with:

- a human-readable `description`
- the `instances` to benchmark — `.lp` files, each with a `size` used for labeling and sorting
- the named `scripts` it can be driven with, each just pointing at a `.fsb` file over in `scripts/`

Every `meta.json` currently exposes the same 16 script variants: `inspect`, `counts`, `enum`, `reason`, `navigate`, `loop`, `all`, `heavy`, `unfair`, `onlycounts`, and six `single_*` scripts that hammer one command repeatedly (`single_cautious`, `single_count`, `single_counts`, `single_impossibles`, `single_solvecount`, `single_solvecounts`). Pick one at run time with `--script NAME`; leave it out and the first one listed (`inspect`) is used.

If you're iterating on a script and don't want to edit every `meta.json` to try it, point `--scripts-dir DIR` at a folder containing a same-named file — it's used instead, only the filename from `meta.json` is looked up there.

## Running benchmarks

```bash
python3 benchmark.py run --fasb /path/to/fasb
```

This walks `benchmarks/` (or whatever `--benchmarks DIR` you pass), runs every instance of every problem it finds, and writes the results to `results.json` (or `--out PATH`).

Flags worth knowing about:

- `-k N` — measured runs per instance (default 5). Higher means less noise, but a longer run.
- `--warmup N` — throwaway runs before the measured ones (default 1).
- `--timeout SEC` — kill a run and its children if it takes longer than this (default 60s, `0`
  disables the timeout).
- `--filter REGEX` — only run problems whose `domain/problem` name matches. This is the only enable/disable mechanism there is right now — there's no per-benchmark flag in `meta.json` for it, just this regex. A few examples:
- 
```bash
--filter '^asp/'                      # only the asp domain
--filter '^planning/(blocks|depot)'   # just these two problems
--filter '^(?!planning/gripper)'      # everything except gripper
```

- `--script NAME` / `--scripts-dir DIR` — which driver script to use, as described above.
- `--fasb-args='--flag1 --flag2'` — extra flags forwarded to `fasb` itself (use `=` since the value starts with `-`, or argparse will mistake it for another option).
- `--driver arg|stdin` — how the script reaches `fasb`: as a file argument (`arg`, the default for interpreter builds) or piped into stdin (`stdin` — for REPL builds).
- `--clingo-models N` — model count passed through to `fasb` (default `0` = all).
- `--min-output-bytes N` — a run producing less stdout than this counts as a silent failure, not a real result (default 64 bytes — guards against a run that exits `0` but did nothing).
- `--sample-hz N` — how often, per second, to poll the process's RSS while it's running (default 200). This is how peak/mean memory get measured.

## Reading results

```bash
python3 benchmark.py show results.json -v
```

Prints mean/median/stdev wall time and peak memory per instance. `-v` also breaks out every
individual run.

## Comparing two builds

Say you want to know whether `version_b` is actually faster than `version_a`. Benchmark them
separately first:

```bash
python3 benchmark.py run -k 5 --warmup 5 --out version_a.json --fasb ../path/to/version_a/target/release/fasb
python3 benchmark.py run -k 5 --warmup 5 --out version_b.json --fasb ../path/to/version_b/target/release/fasb
```

Then diff them:

```bash
python3 benchmark.py compare version_a.json version_b.json
```

This prints a per-instance table (Δ wall time, Δ peak memory) plus an overall geometric-mean ratio across every instance — under 1.0 means the second build is faster/lighter, over 1.0 means it's slower/heavier. `--threshold 0.05` (the default) is how big a change has to be before it's flagged instead of written off as run-to-run noise.
