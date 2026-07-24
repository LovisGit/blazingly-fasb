import glob
import json
import os
import shutil
import sys

from downward import suites
from downward.parsers.exitcode_parser import ExitcodeParser
from downward.parsers.single_search_parser import SingleSearchParser
from downward.reports.absolute import AbsoluteReport
from lab.environments import LocalEnvironment
from lab.experiment import Experiment
from lab.reports import Attribute, geometric_mean

from fasb_environment import BWUniEnvironment
from fasb_parser import FasbParser
from fasb_variables import *


def collect_lp_files():
    files = glob.glob(f"{LP_BENCHMARKS_DIR}/[!.]*")
    for f in files:
        os.remove(f)

    for run_dir in glob.glob("data/fasb_experiment/runs-*/*/"):
        for lp in glob.glob(f"{run_dir}/*.pddl.lp"):
            out_name = lp.replace(".pddl.lp", ".lp")
            shutil.copy(lp, f"benchmarks/lp/{os.path.basename(out_name)}")

def extract_horizons():
    properties_path = f"data/fasb_experiment-eval/properties"
    with open(properties_path, "r") as properties_file:
        json_data = json.load(properties_file)

        for run in json_data:
            horizon = json_data[run]["plan_length"]
            lp_run_name = run.replace(".pddl", ".lp")
            horizons[lp_run_name] = horizon

    with open(HORIZONS_FILE, "w") as horizons_file:
        json.dump(horizons, horizons_file)


# For local testing
LOCAL_ENV = LocalEnvironment(processes=2)
# For cluster testing
BW_ENV = BWUniEnvironment()

ATTRIBUTES = [
    "error",
    "plan",
    "times",
    Attribute("coverage", absolute=True, min_wins=False, scale="linear"),
    Attribute("evaluations", function=geometric_mean),
    Attribute("trivially_unsolvable", min_wins=False),
]
TIME_LIMIT = 1800
MEMORY_LIMIT = 4096

class PreprocessReport(AbsoluteReport):
    INFO_ATTRIBUTES = ["time_limit", "memory_limit"]
    ERROR_ATTRIBUTES = [
        "domain",
        "problem",
        "algorithm",
        "unexplained_errors",
        "error",
        "node",
    ]

horizons = {}


preprocess_exp = Experiment(environment=LOCAL_ENV)
preprocess_exp.add_parser(ExitcodeParser())
preprocess_exp.add_parser(SingleSearchParser())

for task in suites.build_suite(PDDL_BENCHMARKS_DIR, SUITE):
    run = preprocess_exp.add_run()
    run.add_resource("plasp_binary", PLASP_BINARY, symlink=True)
    run.add_resource("downward_runner", DOWNWARD_RUNNER, symlink=True)
    run.add_resource("problem", task.problem_file, symlink=True)
    run.add_resource("domain", task.domain_file, "domain.pddl")

    run.add_command(
        "plasb_convert",
        ["/bin/bash", "-c",
         "./{plasp_binary} translate {domain} {problem} > {problem}.lp"],
        time_limit=TIME_LIMIT,
        memory_limit=MEMORY_LIMIT
    )

    run.add_command(
        "compute_horizon",
        [sys.executable, "{downward_runner}",
         "--search-time-limit", "1800s",
         "--search-memory-limit", "4096M",
         "{domain}", "{problem}",
         "--search", "astar(lmcut())"],
        time_limit=TIME_LIMIT,
        memory_limit=MEMORY_LIMIT
    )

    run.set_property("domain", task.domain)
    run.set_property("problem", task.problem)
    run.set_property("algorithm", "astar-lmcut")
    run.set_property("id", [task.problem])

# Add step that writes experiment files to disk.
preprocess_exp.add_step("build", preprocess_exp.build)

# Add step that executes all runs.
preprocess_exp.add_step("start", preprocess_exp.start_runs)

# Add step that parses log output into "properties" files.
preprocess_exp.add_step("parse", preprocess_exp.parse)

# Add step that collects properties from run directories and
# writes them to *-eval/properties.
preprocess_exp.add_fetcher(name="fetch")

# Collect lp files
preprocess_exp.add_step("collect", collect_lp_files)

# Extract horizons
preprocess_exp.add_step("horizons", extract_horizons)

# Parse the commandline and run the specified steps.
preprocess_exp.run_steps()
