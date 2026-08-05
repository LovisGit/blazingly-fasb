import re

from lab.parser import Parser


def get_command_times(content, props):
    matches = re.findall(r"(?:ent|tak)?\s*time\s+elapsed:\s*(\d+(?:\.\d+)?)(ms|ns|µs)", content)
    
    times_ms = []
    for time_str, unit in matches:
        time_val = float(time_str)
        
        if unit == "ms":
            times_ms.append(time_val)
        elif unit == "µs":
            times_ms.append(time_val / 1000)
        elif unit == "ns":
            times_ms.append(time_val / 1_000_000)
    
    props["individual_times_ms"] = times_ms
    props["total_time_ms"] = sum(times_ms)

class FasbParser(Parser):
    def __init__(self):
        super().__init__()
        self.add_pattern(
            "node", r"node: (.+)$", type=str, file="driver.log", required=True, flags="M"
        )
        self.add_function(get_command_times)
