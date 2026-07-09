#! /usr/bin/env python

import os
import sys

from downward import suites
from downward.reports.absolute import AbsoluteReport
from lab.environments import LocalEnvironment
from lab.experiment import Experiment
from lab.reports import Attribute, geometric_mean

from fasb_environment import BWUniEnvironment
from fasb_parser import FasbParser


class BaseReport(AbsoluteReport):
    INFO_ATTRIBUTES = ["time_limit", "memory_limit"]
    ERROR_ATTRIBUTES = [
        "domain",
        "problem",
        "algorithm",
        "unexplained_errors",
        "error",
        "node",
    ]


PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
#BENCHMARKS_DIR = os.environ["DOWNWARD_BENCHMARKS"]
LP_BENCHMARKS_DIR =  os.path.join(PROJECT_DIR, "benchmarks/")
#FASB_BINARY = os.environ["FASB_BINARY"]
FASB_RUNNER = os.path.join(PROJECT_DIR, "fasb_benchmark_runner.py")
FASB_SCRIPT = os.path.join(PROJECT_DIR, "fasb_script.fsb")
HORIZONS = os.path.join(PROJECT_DIR, "horizons.json")

LOCAL_ENV = LocalEnvironment(processes=2)
BW_ENV = BWUniEnvironment()

#SUITE = ["blocks:probBLOCKS-4-0.pddl", "blocks:probBLOCKS-4-1.pddl", "blocks:probBLOCKS-4-2.pddl"]
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
MEMORY_LIMIT = 2048


exp = Experiment(environment=LOCAL_ENV)
exp.add_parser(FasbParser())

# TODO: Before the runs, following needs to be done:
# - pddl files need to be converted to lp files using planpilot
# - using fastdownward we can calculate the horizon of a pddl problem (store in JSON)
# - that horizon needs to be written into the first line of the lp file
# - the lp file is then ready to be passed to the fasb run
# - python env is copied

for task in suites.build_suite(LP_BENCHMARKS_DIR, LP_SUITE):
    run = exp.add_run()
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
exp.add_step("build", exp.build)

# Add step that executes all runs.
exp.add_step("start", exp.start_runs)

# Add step that parses log output into "properties" files.
exp.add_step("parse", exp.parse)

# Add step that collects properties from run directories and
# writes them to *-eval/properties.
exp.add_fetcher(name="fetch")

# Make a report.
exp.add_report(BaseReport(attributes=ATTRIBUTES), outfile="report.html")

# Parse the commandline and run the specified steps.
exp.run_steps()
