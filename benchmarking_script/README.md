# Benchmarker for fasb

## Layout

```
benchmarks/<domain>/<problem>/   -- all benchmark problems (meta.json + .lp instances)
scripts/                         -- all .fsb driver scripts, referenced by name from each meta.json
```

Every `meta.json` lists the same set of script variants (`inspect`, `counts`, `enum`, `reason`,
`navigate`, `loop`, `all`, `heavy`, `unfair`, `onlycounts`, `single_cautious`, `single_count`,
`single_counts`, `single_impossibles`, `single_solvecount`, `single_solvecounts`). Pick one with
`--script NAME`, or point at an alternate scripts directory with `--scripts-dir DIR`.

## Quick start

```bash
Usage:
  benchmark.py run     [--benchmarks DIR] [-k 5] [--warmup 1] [--out results.json]
                       [--fasb PATH] [--timeout SEC] [--filter REGEX] [--clingo-models N]
  benchmark.py show    RESULTS_JSON [-v]
  benchmark.py compare BASELINE_JSON CURRENT_JSON [--threshold 0.05]
```

To get started create and activate a venv

```bash
python3 -m venv venv
source venv/bin/activate
pip install psutil
```

Lets say you want to compare to fasb versions to see if `version_b` is faster than `version_a`, you start by benchmarking them individually.

```bash
python3 benchmark.py run --benchmarks benchmarks/ -k 5 --warmup 5 --out version_a.json --fasb ../path/to/version_a/target/release/fasb
python3 benchmark.py run --benchmarks benchmarks/ -k 5 --warmup 5 --out version_b.json --fasb ../path/to/version_b/target/release/fasb
```

To compare the two versions use the compare CLI

```bash
python3 benchmark.py compare version_a.json version_b.json
```
