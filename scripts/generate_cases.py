"""Enumerate finite documented domains; obtain every label from SWI-Prolog."""
import argparse
from collections import Counter
import itertools
import json
from pathlib import Path
from oracles import ROOT, PrologOracle, canonical, digest, load_provenance, query_text, write_jsonl

# Family isolation contains all one-field neighbors. No random row splitting.
SPLITS = {
    'impact': 'train', 'indirect_impact': 'train', 'method': 'train',
    'soc_ec': 'train', 'unit': 'train',
    'standard': 'validation', 'impact_se': 'validation',
    'criterion': 'test', 'score_pair': 'test', 'mitigation': 'test',
}


def candidate_inputs(oracle):
    domain = oracle.domain()
    rows = {canonical(item): item for item in domain}
    # Exercise unknown relations without inventing negative relations or labels.
    for kind, fields in [('impact', ('pollutant', 'environment')),
                         ('indirect_impact', ('from', 'to'))]:
        values = [sorted({item[field] for item in domain if item['kind'] == kind}) for field in fields]
        for combination in itertools.product(*values):
            item = {'kind': kind, **dict(zip(fields, combination))}
            rows[canonical(item)] = item
    return [rows[key] for key in sorted(rows)]


def generate(output):
    oracle = PrologOracle()
    provenance = load_provenance()
    rules = {rule['id']: rule for rule in provenance['rules']}
    candidates = candidate_inputs(oracle)
    answers = oracle.evaluate_many(candidates)
    fingerprint = oracle.fingerprint()
    records = []
    for inputs, answer in zip(candidates, answers, strict=True):
        source_ids = sorted({sid for rid in answer['rule_ids'] for sid in rules[rid]['source_ids']})
        if inputs['kind'] == 'criterion' and not source_ids:
            source_ids = next(c['source_ids'] for c in provenance['criteria'] if c['id'] == inputs['criterion'])
        records.append({
            'id': digest(inputs), 'inputs': inputs, 'query': query_text(inputs),
            'target': answer['target'], 'split': SPLITS[inputs['kind']],
            'group_id': inputs['kind'],
            'provenance': {'oracle': 'knowledge_base/esc1.pl', 'oracle_fingerprint': fingerprint,
                           'rule_ids': answer['rule_ids'], 'source_ids': source_ids,
                           'glue_ids': ['GLUE_API'] + ([] if answer['rule_ids'] else ['GLUE_ABSTAIN'])}})
    output.mkdir(parents=True, exist_ok=True)
    write_jsonl(output / 'cases.jsonl', records)
    for split in ('train', 'validation', 'test'):
        write_jsonl(output / (split + '.jsonl'), [row for row in records if row['split'] == split])
    covered = sorted({rid for row in records for rid in row['provenance']['rule_ids']})
    manifest = {
        'schema_version': 1, 'generator_sha256': digest(Path(__file__).read_text()),
        'oracle_fingerprint': fingerprint, 'case_count': len(records),
        'cases_sha256': digest(records), 'generation': 'finite enumeration; no RNG',
        'split_policy': 'whole query families; Hamming-distance-one neighbors contained',
        'family_splits': SPLITS,
        'split_counts': dict(Counter(row['split'] for row in records)),
        'class_counts': dict(Counter(class_label(row['target']) for row in records)),
        'undocumented_count': sum(row['target']['status'] == 'undocumented' for row in records),
        'covered_rule_ids': covered, 'domain_rule_count': len(rules),
        'limitations': ['Small integration fixture, not fine-tuning-ready evidence of effectiveness',
                       'Family holdout; unseen task types and uneven class coverage',
                       'No historical execution traces or equivalence claim'],
    }
    (output / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    return records, manifest


def class_label(target):
    if target['status'] != 'documented':
        return target['status']
    value = target['value']
    if isinstance(value, dict) and 'answer' in value:
        return value['answer']
    return canonical(value)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'dataset/generated')
    args = parser.parse_args()
    _, manifest = generate(args.output)
    print(json.dumps({key: manifest[key] for key in ('case_count', 'split_counts', 'undocumented_count')}))


if __name__ == '__main__':
    main()
