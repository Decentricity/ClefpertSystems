"""Execute a JSON case through the Prolog expert system."""
import argparse
import json
from pathlib import Path
from oracles import PrologOracle


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True)
    parser.add_argument('--kb', type=Path)
    args = parser.parse_args()
    answer = PrologOracle(args.kb).evaluate(json.loads(args.input.read_text()))
    print(json.dumps(answer, ensure_ascii=False, indent=2, allow_nan=False))


if __name__ == '__main__':
    main()
