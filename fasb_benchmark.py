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
from lab.reports import Attribute

from fasb_environment import BWUniEnvironment
from fasb_parser import FasbParser
from fasb_variables import *


def read_horizons():
    with open(HORIZONS_FILE, "r") as horizons_file: 
        return json.load(horizons_file)

def build_lp_suite():
    lp_suite = []
    for problem in SUITE:
        lp_problem_file = problem.split(":")[1].replace(".pddl", ".lp")
        lp_suite.append(f":{lp_problem_file}")

    return lp_suite


# For local testing
LOCAL_ENV = LocalEnvironment(processes=2)
# For cluster testing
BW_ENV = BWUniEnvironment()

ATTRIBUTES = [
    "error",
    "times",
    Attribute("coverage", absolute=True, min_wins=False, scale="linear"),
    Attribute("trivially_unsolvable", min_wins=False),
]
TIME_LIMIT = 1800
MEMORY_LIMIT = 4096

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

fasb_exp = Experiment(environment=LOCAL_ENV)
fasb_exp.add_parser(FasbParser())

horizons = read_horizons()
lp_suite = build_lp_suite()


for task in suites.build_suite(LP_BENCHMARKS_DIR, lp_suite):
    run = fasb_exp.add_run()
    run.add_resource("fasb_runner", FASB_RUNNER, symlink=True)
    run.add_resource("script", FASB_SCRIPT, symlink=True)
    run.add_resource("problem", task.problem_file, symlink=True)

    horizon = horizons[task.problem]

    # Clingo reads the horizon through a CLI arg (-c horizon=X) but the Python bindings don't allow
    # that right now. Maybe it is possible to pass the -c flag with the Python call.
    run.add_command(
        "run-fasb",
        [sys.executable, "{fasb_runner}", "{problem}", "{script}", f"{horizon}"],
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
fasb_exp.run_steps()
