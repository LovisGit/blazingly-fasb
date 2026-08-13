# How to test fasb

## Benchmark files

Benchmarks can be found here:

<https://github.com/aibasel/downward-benchmarks>

1. Choose one of the following domains:

- blocks
- elevators*
- floortile*
- logisstics00
- nomystery*
- openstacks*
- rovers

2. Use older versions like 08 or 11.

3. ``opt`` instances are usually easier/faster to solve than ``sat``

4. Start with instance between p01 and p05 first.

## Convert to ASP

### Using [plasb](https://github.com/potassco/plasp)

You can use following command:

```sh
plasp translate domain.pddl problem.pddl > instance.lp
```

### Using [PlanPilot](https://github.com/abcorrea/planpilot)

You can use following command:

```sh
./planpilot.py -i benchmarks/blocks/probBLOCKS-4-0.pddl --encoding bounded --horizon 10
```

PlanPilot will generate the ``.lp`` file for you. It is stored on the top level of the repository.

A horizon of 20 should work for most domains but if you want to determine the exact horizon for at
least one solution, [FastDownward](https://github.com/aibasel/downward) should be considered (or you
just sequentially decrease/increase the horizon until get an optimal solution). Use this command:
```sh
./fast-downward.py ../benchmarks-aibasel/nomystery-opt11-strips/p01.pddl --search "astar(lmcut())"
```

The ``.lp`` file will use ``horizon=0`` by default. Adjust this to the horizon you calculated with
FastDownward in the very first line of the ``.lp`` file. Otherwise fasb will always work with a
horizon of 0 and won't find any solution.

## Current lab benchmark setup

### Repository files

There are two distinct experiment, ``fasb_preprocess.py`` and ``fasb_benchmark.py`` which uses the
outputs of the first one:

- ``fasb_variables.py``: Shared declaration for binary, script and problem paths.
- ``fasb_preprocess.py``: First experiment file that calculates the plan length and converts PDDL
problems into LP problems.
- ``fasb_benchmark.py``: Second experiment file that tests fasb agains the generated LP files.
- ``fasb_benchmark_runner.py``: Started by the second experiment. This script starts fasb against a
  single LP file by running the following fsb script. The whole process is benchmarked and parsed by
lab.
- ``fasb_parser.py``: lab parser for the second experiment to retrieve output.
- ``fasb_script.fsb``: Script that is started agains a LP file.

### Environment and dependencies

As of right now, you have to install, build and/or copy following dependencies onto the login
cluster:

- [fasb](https://github.com/MapManagement/fasb)
- [plasp](https://github.com/potassco/plasp)
- [fast-downward](https://github.com/aibasel/downward)
- [clingo](https://github.com/potassco/clingo)
- [benchmark files](https://github.com/aibasel/downward-benchmarks)
- Rust
- Python>=3.14

The concrete file structure has to look like this:

```
binaries/
    plasp                   # needed for PDDL to LP conversion
blazingly-fasb/             # includes lab experiments
    cluster/
        fasb_preprocess.py
        fasb_benchmark.py
        ...
clingo/                     # has to be built from source on login node
downward/                   # needed for calculation of plan length
    fast-downward.py
    ...
downward-benchmarks/        # benchmark files for experiments
    blocks/
    gripper/
    ...
fasb/                       # fasb Python module needs to be built in login node
libs/                       # source-compiled clingo lib should be moved in here
    libclingo.a
```

### Building the dependencies

The default environment of the BwUniCluster does not come with all binaries you need for our lab
experiments. Thus you must install most of them on the login node. We recommend creating a dedicated
workspace and set everything up there.

**Create workspace that lasts for 30 days:**

```sh
ws_allocate fasb_benchmarks 30
```

You should find the workspace here after creating it. This is going to be our root directory for
all following commands:

```sh
/pfs/work9/workspace/scratch/<UNIVERSITY>-<YOUR-ID>-fasb_benchmarks>/
```

**Adjust bashrc:**

Paste this into your ``~/.bashrc``:

```bash
PATH="/pfs/work9/workspace/scratch/<UNIVERSITY>-<YOUR_ID>-fasb_benchmarks/binaries:$PATH"
export PATH

# Append these lines at the bottom (replace the path with your actual workspace path)
export WORKSPACE_PATH="/pfs/work9/workspace/scratch/<UNIVERSITY>-<YOUR_ID>-fasb_benchmarks"

export UV_CACHE_DIR="$WORKSPACE_PATH/.uv_cache"
export UV_TOOL_DIR="$WORKSPACE_PATH/.uv_tools"
export UV_PYTHON_INSTALL_DIR="$WORKSPACE_PATH/.uv_python"
export CARGO_HOME="$WORKSPACE_PATH/.cargo"
export RUSTUP_HOME="$WORKSPACE_PATH/.rustup"
export CLINGO_LIBRARY_PATH="$WORKSPACE_PATH/libs"
export LD_LIBRARY_PATH="$WORKSPACE_PATH/libs:$LD_LIBRARY_PATH"
```

**Setup uv:**

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Install Rust:**

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Clone downward-benchmarks:**

```sh
git clone https://github.com/aibasel/downward-benchmarks
```

**Add plasp binary:**

```sh
mkdir binaries

# Copy latest plasp binary onto login node in the newly created directory.
# You can find it here: https://github.com/potassco/plasp/releases
ls binaries
# plasp
```

**Add fast-downward:**

```sh
git clone https://github.com/aibasel/downward

# Build the planner
uv run downward/build.py
```

**Compile clingo:**

Unfortunately you have to compile clingo on the login node from source.

```sh
git clone https://github.com/potassco/clingo

# Change into source directory
cd clingo

# Update submodules
git submodule update --init --recursive

# Create build directory
mkdir build
cd build

# Prepare build (those are the exact flags needed for the Rust clingo bindings)
cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCLINGO_BUILD_STATIC=ON -DCLINGO_BUILD_SHARED=OFF ..

# Start build (takes a while)
make

# Go back to top level of workspace
cd ../..

# Create libs directory
mkdir libs

# Copy clingo libs
cp clingo/build/lib/libclingo.a
```

**Compile fasb:**

```sh
git clone https://github.com/MapManagement/fasb

# Go into fasb directory
cd fasb

# Build fasb
cargo build
```

**Build experiment files:**

```sh
git clone https://github.com/LovisGit/blazingly-fasb

# Go into cluster directory
cd blazingly-fasb/cluster

# Install Python dependencies
uv pip install -r pyproject.toml

uv run fasb_preprocess.py build
uv run fasb_benchmark.py build
```

## Starting the experiments

If the environment is fully setup, you can queue the two experiments on the cluster nodes. First,
you need to start the ``fasb_preprocess.py`` Using uv, you can do it like this:

```bash
uv run fasb_preprocess.py 1 2 3 4 5 6
```

Then you will see something like this:

```
2026-08-05 15:53:47,381 INFO     Executing sbatch --export PATH /pfs/work9/workspace/scratch/hd_ct320-fasb_benchmarking/blazingly-fasb/cluster/data/fasb_preprocess-grid-steps/fasb_preprocess-01-build
2026-08-05 15:53:47,439 INFO     Output: Submitted batch job 6157966
2026-08-05 15:53:47,441 INFO     Grouping 35 runs into 35 Slurm tasks.
2026-08-05 15:53:47,447 INFO     Executing sbatch --export PATH -d afterany:6157966 --kill-on-invalid-dep=yes /pfs/work9/workspace/scratch/hd_ct320-fasb_benchmarking/blazingly-fasb/cluster/data/fasb_preprocess-grid-steps/fasb_preprocess-02-start
2026-08-05 15:53:47,475 INFO     Output: Submitted batch job 6157967
2026-08-05 15:53:47,479 INFO     Executing sbatch --export PATH -d afterany:6157967 --kill-on-invalid-dep=yes /pfs/work9/workspace/scratch/hd_ct320-fasb_benchmarking/blazingly-fasb/cluster/data/fasb_preprocess-grid-steps/fasb_preprocess-03-parse
2026-08-05 15:53:47,504 INFO     Output: Submitted batch job 6157968
2026-08-05 15:53:47,510 INFO     Executing sbatch --export PATH -d afterany:6157968 --kill-on-invalid-dep=yes /pfs/work9/workspace/scratch/hd_ct320-fasb_benchmarking/blazingly-fasb/cluster/data/fasb_preprocess-grid-steps/fasb_preprocess-04-fetch
2026-08-05 15:53:47,537 INFO     Output: Submitted batch job 6157969
2026-08-05 15:53:47,541 INFO     Executing sbatch --export PATH -d afterany:6157969 --kill-on-invalid-dep=yes /pfs/work9/workspace/scratch/hd_ct320-fasb_benchmarking/blazingly-fasb/cluster/data/fasb_preprocess-grid-steps/fasb_preprocess-05-collect
2026-08-05 15:53:47,566 INFO     Output: Submitted batch job 6157970
2026-08-05 15:53:47,569 INFO     Executing sbatch --export PATH -d afterany:6157970 --kill-on-invalid-dep=yes /pfs/work9/workspace/scratch/hd_ct320-fasb_benchmarking/blazingly-fasb/cluster/data/fasb_preprocess-grid-steps/fasb_preprocess-06-horizons
2026-08-05 15:53:47,595 INFO     Output: Submitted batch job 6157971
```

Each unique step gets a batch job ID. The last one, in this case **6157971**, is the most important
one because you can use it for follow-up jobs. Right after running the command, your jobs will stay
within the queue for a few seconds or up to one minute. If the current load of the cluster is higher,
it can also take longer. As soon as they are actually running, you may have to wait a bit depending
on the problems you selected priorly.

Either you just wait (and check for errors manually) now or you just queue the follow-up job - the
``fasb_benchmark.py`` experiment. Here you can see how to check the status of the first experiment:

```bash
squeue -u $USER
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
       6157971_[1]       cpu fasb_pre hd_ct320 PD       0:00      1 (Dependency)
       6157970_[1]       cpu fasb_pre hd_ct320 PD       0:00      1 (Dependency)
       6157969_[1]       cpu fasb_pre hd_ct320 PD       0:00      1 (Dependency)
       6157968_[1]       cpu fasb_pre hd_ct320 PD       0:00      1 (Dependency)
        6157967_10       cpu fasb_pre hd_ct320  R      16:59      1 uc3n018
        6157967_11       cpu fasb_pre hd_ct320  R      16:59      1 uc3n018
        6157967_14       cpu fasb_pre hd_ct320  R      16:59      1 uc3n031
        6157967_16       cpu fasb_pre hd_ct320  R      16:59      1 uc3n031
        6157967_19       cpu fasb_pre hd_ct320  R      16:59      1 uc3n033
        6157967_27       cpu fasb_pre hd_ct320  R      16:59      1 uc3n038
        6157967_35       cpu fasb_pre hd_ct320  R      16:59      1 uc3n043
```

The experiment is going to generate LP files and stores them in ``benchmark/lp/`` and it creates a
``horizons.json`` file which contains the calculated plan length for all problems. 

If you decide to instantly queue the second experiment, which relies on the first one, you can do it
by using the greatest job ID of the first experiment:

```bash
uv run fasb_benchmark.py 1 2 3 4 5 -- --dependency=afterok:6157971
```

Otherwise, you can simply run this once the first experiment has finished:

```bash
uv run fasb_benchmark.py 1 2 3 4 5
```

This one will only generate the typical lab outputs you can find in the ``data/`` directory. If no
errors occur, the most important files typically are ``data/fasb_benchmark-eval/report.html`` and
``data/fasb_benchmark-eval/properties``.
