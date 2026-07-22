#! /usr/bin/env python

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

# Directories
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
PDDL_BENCHMARKS_DIR = os.path.join(PROJECT_DIR, "benchmarks/pddl/")
LP_BENCHMARKS_DIR =  os.path.join(PROJECT_DIR, "benchmarks/lp/")

# Binaries and executables
FASB_RUNNER = os.path.join(PROJECT_DIR, "fasb_benchmark_runner.py")
DOWNWARD_RUNNER = os.path.join(PROJECT_DIR, "../downward/fast-downward.py")
FASB_SCRIPT = os.path.join(PROJECT_DIR, "fasb_script.fsb")
PLASP_BINARY = os.path.join(PROJECT_DIR, "binaries/plasp")

# Miscellaneous
HORIZONS = os.path.join(PROJECT_DIR, "horizons.json")

# For local testing
LOCAL_ENV = LocalEnvironment(processes=2)
# For cluster testing
BW_ENV = BWUniEnvironment()

PDDL_SUITE = [
    "blocks:probBLOCKS-4-0.pddl",
    "blocks:probBLOCKS-4-1.pddl",
    "blocks:probBLOCKS-4-2.pddl",
    "blocks:probBLOCKS-5-0.pddl",
    "blocks:probBLOCKS-5-1.pddl",
    "blocks:probBLOCKS-5-2.pddl"
]
LP_SUITE = [
    ":probBLOCKS-4-0.lp",
    ":probBLOCKS-4-1.lp",
    ":probBLOCKS-4-2.lp",
    ":probBLOCKS-5-0.lp",
    ":probBLOCKS-5-1.lp",
    ":probBLOCKS-5-2.lp"
]
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
            horizons[run] = horizon

    horizons_path = f"{PROJECT_DIR}/horizons.json"
    with open(horizons_path, "w") as horizons_file:
        json.dump(horizons, horizons_file)

preprocess_exp = Experiment(environment=LOCAL_ENV)
preprocess_exp.add_parser(ExitcodeParser())
preprocess_exp.add_parser(SingleSearchParser())

for task in suites.build_suite(PDDL_BENCHMARKS_DIR, PDDL_SUITE):
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


class FasbReport(AbsoluteReport):
    INFO_ATTRIBUTES = ["time_limit", "memory_limit"]
    ERROR_ATTRIBUTES = [
        "domain",
        "problem",
        "algorithm",
        "unexplained_errors",
        "error",
        "node",
    ]

"""
fasb_exp = Experiment(environment=LOCAL_ENV)
fasb_exp.add_parser(FasbParser())

# TODO: Before the runs, following needs to be done:
# - pddl files need to be converted to lp files using planpilot
# - using fastdownward we can calculate the horizon of a pddl problem (store in JSON)
# - that horizon needs to be written into the first line of the lp file / pass as cli argument
# - the lp file is then ready to be passed to the fasb run
# - python env is copied

for task in suites.build_suite(LP_BENCHMARKS_DIR, LP_SUITE):
    run = fasb_exp.add_run()
    run.add_resource("fasb_runner", FASB_RUNNER, symlink=True)
    run.add_resource("script", FASB_SCRIPT, symlink=True)
    run.add_resource("problem", task.problem_file, symlink=True)
    run.add_command(
        "run-fasb",
        [sys.executable, "{fasb_runner}", "{problem}", "{script}"],
        time_limit=TIME_LIMIT,
        memory_limit=MEMORY_LIMIT,
    )
    run.set_property("domain", task.domain)
    run.set_property("problem", task.problem)
    run.set_property("algorithm", "fasb")
    run.set_property("time_limit", TIME_LIMIT)
    run.set_property("memory_limit", MEMORY_LIMIT)
    run.set_property("id", ["fasb", task.domain, task.problem])

# Add step that writes experiment files to disk.
fasb_exp.add_step("build", fasb_exp.build)

# Add step that executes all runs.
fasb_exp.add_step("start", fasb_exp.start_runs)

# Add step that parses log output into "properties" files.
fasb_exp.add_step("parse", fasb_exp.parse)

# Add step that collects properties from run directories and
# writes them to *-eval/properties.
fasb_exp.add_fetcher(name="fetch")

# Make a report.
fasb_exp.add_report(FasbReport(attributes=ATTRIBUTES), outfile="report.html")

# Parse the commandline and run the specified steps.
fasb_exp.run_steps()"""
