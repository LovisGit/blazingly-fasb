# Benchmarker for fasb

A lightweight CLI for benchmarking fasb on different ASP problems.

## Quickstart

To generate a run
```bash
python benchmark.py run --benchmarks benchmarks --script enum --out runs/baseline.json
```

To display a run
```bash
python benchmark.py show runs/baseline.json
```

For comparison
```bash
python benchmark.py compare runs/baseline.json runs/current.json
```


## Preliminaries

### Benchmarks

Benchmarks can be added through a well-structured folder; the folder can be passed through `--benchmarks <dir>`. The benchmarks folder structure is expected as

```
|- <dir>
|-- <subcategories>
|--- <problem folder>
|---- <problem file(s)>
|---- meta.json
|--- <other problem folder>
|---- ...
|-- ...
```

The meta.json provides insight into the scripts that can be used, as well as the problems and their horizons. The format is expected as

```json
{
  "description": "<problem description>",
  "scripts": [
    {"name": "<script name>", "path": "<script path relative to pwd>"},
    ...
  ],
  "instances": [
    {"size": <horizon>, "program": "<problem file>"},
    ...
  ]
}
```

The problems are expected in the `.lp` ASP format. Other problem types, like `.pddl`, need to be translated using tools such as plasp or planpilot.

### Scripts

!!! WARNING Only the explicitly passed script using `--script <script name>` is used; otherwise the benchmarker falls back to the first script listed in `meta.json`.

The scripts folder contains `.fsb` scripts, compiled sequences of fasb commands.

The CLI defaults to a folder named `scripts`; other directories can be passed using `--scripts-dir <dir>`.

```
|- <dir>
|-- <.fsb script>
|-- ..
```

It is also important to note that if a script is not listed in a problem's `meta.json`, it cannot be used.

### Drivers

!!! NOTE In order for the CLI to work you need a built binary of the fasb version you are trying to benchmark.

Depending on the build, a different driver needs to be used. If the fasb build was done with the interpreter feature (`--features interpreter` in cargo build), the standard driver `--driver arg` (the one the CLI defaults to) can be used. Otherwise `--driver stdin` can be used, where the commands are passed one by one using standard input into REPL mode of fasb.

## CLI Usage

The CLI exposes three subcommands: `run`, `show`, and `compare`.

### `run` — execute benchmarks

```bash
python benchmark.py run [options]
```

| Flag | Default | Description |
|---|---|---|
| `--benchmarks <dir>` | `benchmarks` | Benchmarks root directory |
| `-k <n>` | `5` | Measured runs per instance |
| `--warmup <n>` | `1` | Discarded warmup runs before measuring |
| `--timeout <s>` | `60` | Per-run timeout in seconds; `0` disables the timeout |
| `--out <path>` | `results.json` | Output JSON path |
| `--fasb <path>` | searched on `PATH` | Path to the fasb binary |
| `--fasb-args <str>` | none | Extra flags passed to fasb, split like a shell line, e.g. `--fasb-args='--fast -v'` (use `=` since the value starts with `-`, otherwise argparse mistakes it for another option) |
| `--filter <regex>` | none | Only run problems whose `<domain>/<problem>` name matches |
| `--script <name>` | first listed | Script variant from the `scripts` entry in `meta.json`, e.g. `all`, `enum`, `reason` |
| `--scripts-dir <dir>` | path in `meta.json` | Override the script directory, keeping the chosen filename |
| `--driver {arg,stdin}` | `arg` | How the script reaches fasb: `arg` for a positional file (interpreter builds), `stdin` for piping into the REPL (repl builds) |
| `--min-output-bytes <n>` | `64` | Minimum stdout bytes required for a run to count as successful; guards against banner-only no-op runs |
| `--clingo-models <n>` | `0` | Clingo model count passed to fasb (`0` = all) |
| `--sample-hz <n>` | `200` | RSS memory sampling rate in Hz |

Example, running only the ASP problems with the `enum` script and a 30s timeout:
```bash
python benchmark.py run --benchmarks benchmarks --filter 'asp/.*' --script enum -k 10 --timeout 30 --out runs/enum.json
```

### `show` — display a saved results file

```bash
python benchmark.py show <results.json> [--verbose]
```

- `results` — path to the results JSON (positional, required)
- `--verbose`, `-v` — additionally print every individual run (wall time, peak RSS, exit status) instead of just the per-instance summary

### `compare` — diff two results files

```bash
python benchmark.py compare <baseline.json> <current.json> [--threshold <f>]
```

- `baseline` — path to the baseline results JSON (positional, required)
- `current` — path to the current results JSON (positional, required)
- `--threshold <f>` — default `0.05`; relative band (±) treated as noise rather than a real regression/improvement

Reports, per matching `<benchmark, size>` pair, the change in mean wall time and peak memory between the two runs, followed by a geometric-mean summary across all instances.
