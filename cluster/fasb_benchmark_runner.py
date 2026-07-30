import sys

from fasb import start_fasb_interpreter


def main():
    cli_args = sys.argv[1:]

    if len(cli_args) > 3:
        raise Exception("You need to specify a logic program path, script path and the horizon.")

    lp_file_path = cli_args[0]
    script_file_path = cli_args[1]
    horizon = int(cli_args[2])
    args = []
    facets_at_startup = True
    print_atoms = False

    start_fasb_interpreter(args, lp_file_path, script_file_path, facets_at_startup, print_atoms)

if __name__ == '__main__':
    main()
