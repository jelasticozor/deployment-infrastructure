import json
import os
from argparse import Namespace, ArgumentParser


def parse_cmd_line_args() -> Namespace:
    parser = ArgumentParser()
    parser.add_argument("--env-var", required=True, type=str, action="store")
    parser.add_argument("--state-file", required=True, type=str, action="store")
    args = parser.parse_args()
    return args


def import_state(state_file: str) -> dict:
    try:
        with open(state_file, "r") as file:
            return json.load(file)
    except IOError:
        return {}


def export_state(state: dict, state_file: str) -> None:
    with open(state_file, "w") as file:
        json.dump(state, file)


def main():
    args = parse_cmd_line_args()
    state = import_state(args.state_file)
    state[args.env_var] = os.environ[args.env_var]
    export_state(state, args.state_file)


if __name__ == "__main__":
    main()
