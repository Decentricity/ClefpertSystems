"""Export clean oracle decisions; use an explicit contract for Clef field names."""
import argparse
import json
from pathlib import Path
from oracles import canonical, read_jsonl, write_jsonl


def validate_contract(contract):
    required = {'schema_name', 'schema_version', 'layout', 'input_field', 'target_field'}
    if set(contract) != required or contract['layout'] != 'pair':
        raise ValueError('Contract needs schema_name/schema_version/layout=pair/input_field/target_field')
    if any(not isinstance(contract[k], str) or not contract[k] for k in required):
        raise ValueError('Contract values must be nonempty strings')
    if contract['input_field'] == contract['target_field']:
        raise ValueError('Input and target fields must differ')


def export(records, format='messages', contract=None):
    if format == 'clef':
        if contract is None:
            raise ValueError('Supply the actual versioned Clef pair-format contract; no schema is assumed')
        validate_contract(contract)
    elif format not in ('messages', 'prompt_completion'):
        raise ValueError('Unsupported export format')
    for row in records:
        prompt, target = row['query'], canonical(row['target'])
        if format == 'messages':
            yield {'messages': [{'role': 'user', 'content': prompt},
                                {'role': 'assistant', 'content': target}]}
        elif format == 'prompt_completion':
            yield {'prompt': prompt, 'completion': target}
        else:
            yield {contract['input_field']: prompt, contract['target_field']: target}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--format', choices=['messages', 'prompt_completion', 'clef'], required=True)
    parser.add_argument('--contract', type=Path, help='Actual versioned Clef schema mapping, not a guessed default')
    parser.add_argument('--index', type=Path, help='Optional separate row-to-case-ID audit index')
    args = parser.parse_args()
    if args.input.resolve() == args.output.resolve() or args.index and args.index.resolve() in (args.input.resolve(), args.output.resolve()):
        parser.error('Input, output and index must differ')
    records = read_jsonl(args.input)
    contract = json.loads(args.contract.read_text()) if args.contract else None
    try:
        rows = list(export(records, args.format, contract))
    except ValueError as error:
        parser.error(str(error))
    write_jsonl(args.output, rows)
    if args.index:
        write_jsonl(args.index, [{'row': i, 'case_id': row['id']} for i, row in enumerate(records)])


if __name__ == '__main__':
    main()
