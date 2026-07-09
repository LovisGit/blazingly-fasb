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

We recommend using [PlanPilot](https://github.com/abcorrea/planpilot) for the conversion. You can
use following command:

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

As of now, this repository tests all problems that are located in the ``benchmark`` directory but
only if the ``horizons.json`` file also contains a horizon for that exact problem. The ``.lp`` have
already been converted from PDDL using PlanPilot and the horizons have been calculated using
FastDownward.
