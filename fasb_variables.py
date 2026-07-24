import os

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
HORIZONS_FILE = os.path.join(PROJECT_DIR, "horizons.json")

SUITE = [
    "blocks:probBLOCKS-4-0.pddl",
    "blocks:probBLOCKS-4-1.pddl",
    "blocks:probBLOCKS-4-2.pddl",
    "blocks:probBLOCKS-5-0.pddl",
    "blocks:probBLOCKS-5-1.pddl",
    "blocks:probBLOCKS-5-2.pddl"
]
