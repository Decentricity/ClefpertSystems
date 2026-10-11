"""Translate an executable Prolog module plus grouped states into training pairs."""
import argparse
import json
from pathlib import Path
from export_clef_dataset import export
from generate_cases import generate
from oracles import PrologOracle, read_jsonl, write_jsonl


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--kb', type=Path, required=True)
    parser.add_argument('--dependency', type=Path, action='append', default=[])
    parser.add_argument('--states', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--format', choices=['messages', 'prompt_completion', 'clef'], default='messages')
    parser.add_argument('--contract', type=Path)
    args = parser.parse_args()
    contract = json.loads(args.contract.read_text()) if args.contract else None
    # Validate export options before generating any files.
    list(export([], args.format, contract))
    records, manifest = generate(args.output, PrologOracle(args.kb, args.dependency), read_jsonl(args.states))
    for split in ('train', 'validation', 'test'):
        write_jsonl(args.output / (split + '.' + args.format + '.jsonl'),
                    export([r for r in records if r['split'] == split], args.format, contract))
    print(json.dumps({'cases': manifest['case_count'], 'splits': manifest['split_counts']}))


if __name__ == '__main__':
    main()
