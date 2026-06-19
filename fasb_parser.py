import re

from lab.parser import Parser


def error(content, props):
    if props["planner_exit_code"] == 0:
        props["error"] = "plan-found"
    else:
        props["error"] = "unsolvable-or-error"


def coverage(content, props):
    props["coverage"] = int(props["planner_exit_code"] == 0)


def get_plan(content, props):
    match = re.search(r":: @\n(.+)", content)
    if match:
        atoms = match.group(1).strip().split()
        if atoms:
            props["plan"] = atoms


def get_times(content, props):
    times = []
    for m in re.finditer(r"(\d+\.?\d*)\s*(µs|ms|s)", content):
        value = float(m.group(1))
        unit = m.group(2)
        if unit == "µs":
            value /= 1_000_000
        elif unit == "ms":
            value /= 1_000
        times.append(value)
    props["times"] = times


def get_found_total(content, props):
    found = re.findall(r"^found (\d+)", content, re.M)
    if found:
        props["evaluations"] = sum(int(n) for n in found)


def trivially_unsolvable(content, props):
    props["trivially_unsolvable"] = int("no answer set" in content)


class FasbParser(Parser):
    def __init__(self):
        super().__init__()
        self.add_pattern(
            "node", r"node: (.+)\n", type=str, file="driver.log", required=True
        )
        self.add_pattern(
            "planner_exit_code",
            r"run-planner exit code: (.+)\n",
            type=int,
            file="driver.log",
        )
        self.add_function(error)
        self.add_function(coverage)
        self.add_function(get_plan)
        self.add_function(get_times)
        self.add_function(get_found_total)
        self.add_function(trivially_unsolvable)
