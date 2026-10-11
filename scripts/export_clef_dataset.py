"""Exporter boundary: generic messages only, pending a verified Clef schema."""
import argparse
from pathlib import Path
from oracles import canonical, read_jsonl, write_jsonl


def export(records):
    for row in records:
        yield {'messages': [
            {'role': 'user', 'content': row['query']},
            {'role': 'assistant', 'content': canonical(row['target'])}]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--format', choices=['messages', 'clef'], required=True)
    args = parser.parse_args()
    if args.format == 'clef':
        parser.error('No verified Clef schema is available. Supply a versioned contract before adding this format.')
    if args.input.resolve() == args.output.resolve():
        parser.error('Output must differ from input')
    write_jsonl(args.output, export(read_jsonl(args.input)))


if __name__ == '__main__':
    main()
