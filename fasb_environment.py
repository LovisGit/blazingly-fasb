from lab.environments import SlurmEnvironment


class BWUniEnvironment(SlurmEnvironment):
    """Environment for the BWUni cluster in Baden-Württemberg."""

    DEFAULT_PARTITION = "cpu"
    DEFAULT_QOS = "normal"
    DEFAULT_TIME_LIMIT_PER_TASK = "12:00:00"
    # 64 cores on cpu nodes, 236G usable memory
    DEFAULT_MEMORY_PER_CPU = "3600M"
    # See slurm.conf
    MAX_TASKS = 1000

    @classmethod
    def is_present(cls):
        node = platform.node()
        return bool(re.match(r"o05i15", node))
