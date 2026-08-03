# Blazingly fasb

Welcome to the **blazingly fasb** repository. This is a university project designed to benchmark fasb in two main ways:

## Local Benchmarking

The `benchmarking_script` directory provides a simple and lightweight CLI for running local benchmarks in fasb using multiple problems and configurations. Please note that this script only works with `.lp` files, so translation from PDDL (or similar formats) is necessary beforehand. However, the directory does include some basic pre-translated benchmarks to get you started. Read more in the [Local Benchmarking README](./benchmarking_script/README.md).

## Cluster Benchmarking

The `cluster` directory uses Lab (by the creators of Fast Downward) to set up experiments and necessary prerequisites for benchmarking fasb on any computing cluster or local machine. Unlike the local script, this approach is designed specifically for PDDL files and handles the necessary translation internally. Read more in the [Cluster Setup Guide](./cluster/LAB_SETUP.md).
