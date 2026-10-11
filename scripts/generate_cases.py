"""Generate scenario decisions by executing Prolog, with a separate audit sidecar."""
import argparse
from collections import Counter
import itertools
import json
from pathlib import Path
import random
from oracles import ROOT, PrologOracle, canonical, digest, load_provenance, normalize_inputs, query_text, read_jsonl, write_jsonl

POLLUTANT_SPLITS = {'Particulate': 'train', 'CO': 'train', 'Suspended Solid': 'train',
                    'Hydrocarbon': 'validation', 'H2S': 'validation',
                    'SO2': 'test', 'Water Temperature': 'test'}


def split_for_group(group):
    bucket = int(digest(group)[:8], 16) % 100
    return 'train' if bucket < 70 else 'validation' if bucket < 85 else 'test'


def candidate_states(oracle):
    """Cement-specific input generator using executable domain introspection only."""
    domain = oracle.domain()
    states = []
    magnitudes = [0, 1, 2.5, 5, 8, 10]
    for pollutant in domain['pollutants']:
        processes = sorted({p['process'] for p in domain['process_pollutant_pairs'] if p['pollutant'] == pollutant})
        direct = sorted({p['environment'] for p in domain['direct_pairs'] if p['pollutant'] == pollutant})
        receptor_sets = [[receptor] for receptor in direct]
        receptor_sets += [['Surface Water', 'Aquatic Plants', 'Birds'], ['Shrubs', 'Erosion'],
                          ['Gasses and Particulate', 'Health and Safety']]
        # An unsupported single receptor is a missing-data case, never a negative label.
        unsupported = next((r for r in domain['receptors'] if r not in direct), None)
        if unsupported:
            receptor_sets.append([unsupported])
        process_sets = [[process] for process in processes]
        if len(processes) >= 2:
            process_sets.append(processes[:2])
        group = 'pollutant:' + pollutant
        for sources, receptors, magnitude in itertools.product(process_sets, receptor_sets, magnitudes):
            states.append({'inputs': {'kind': 'assess', 'processes': sources, 'pollutant': pollutant,
                                     'magnitude': magnitude, 'receptors': receptors},
                           'group_id': group, 'split': POLLUTANT_SPLITS[pollutant]})
    for pollutant, concentrations in [('H2S', [0, 10.499, 10.5, 20.999, 21, 41.999, 42, 1000, 1001]),
                                      ('SO2', [0, 39.999, 40, 40.001])]:
        for value in concentrations:
            states.append({'inputs': {'kind': 'assess_concentration', 'processes': ['Mineral Processing'],
                                     'pollutant': pollutant, 'concentration': value, 'receptors': ['Shrubs']},
                           'group_id': 'pollutant:' + pollutant, 'split': POLLUTANT_SPLITS[pollutant]})
    for receptor in domain['receptors']:
        states.append({'inputs': {'kind': 'trace_back', 'receptor': receptor},
                       'group_id': 'backward_candidates', 'split': 'test'})
    for instrument in domain['instruments']:
        for value in [0, 3.999, 4, 4.001, 10]:
            states.append({'inputs': {'kind': 'instrumentation', **instrument, 'observed_value': value},
                           'group_id': 'instrumentation', 'split': 'train'})
    fields = domain['wp_fields']
    rng = random.Random(2008)
    profiles = [{field: count for field in fields} for count in [0, 1, 2]]
    while len(profiles) < 20:
        counts = {field: rng.randrange(6) for field in fields}
        counts['staged_activities'] = min(counts['staged_activities'], counts['activities'])
        counts['objective_measurements'] = min(counts['objective_measurements'], counts['measurements'])
        # Ensure no one-counter neighbors can land in different groups.
        if any(sum(counts[key] != profile[key] for key in fields) <= 1 for profile in profiles):
            continue
        profiles.append(counts)
    for counts in profiles:
        group = 'wp_session:' + digest(counts)
        for answers in itertools.product(['yes', 'no'], repeat=3):
            states.append({'inputs': {'kind': 'method_assessment', 'counts': counts,
                                     'answers': dict(zip(['impact_isolation', 'explicit_indicators', 'significance'], answers))},
                           'group_id': group, 'split': split_for_group(group)})
    # Multi-analysis sessions use only one pollutant family to preserve its holdout.
    for pollutant in domain['pollutants']:
        receptors = sorted({p['environment'] for p in domain['direct_pairs'] if p['pollutant'] == pollutant})[:2]
        if not receptors:
            continue
        for magnitude in [0, 1, 5, 10]:
            cases = [{'kind': 'assess', 'processes': ['Mineral Processing'], 'pollutant': pollutant,
                      'magnitude': magnitude, 'receptors': [receptor]} for receptor in receptors]
            for answer in ['yes', 'no']:
                states.append({'inputs': {'kind': 'assess_session', 'cases': cases,
                    'answers': {key: answer for key in ['impact_isolation', 'explicit_indicators', 'significance']},
                    'alternatives': 2, 'declared_assumptions': 2, 'objective_measurements': len(cases),
                    'staged_activities': 1, 'rare_severe_impacts': 0},
                    'group_id': 'pollutant:' + pollutant, 'split': POLLUTANT_SPLITS[pollutant]})
    return states


def audit_for(inputs, answer, oracle, metadata):
    facts = {row['id']: row for row in metadata.get('facts', [])}
    inference = {row['id']: row for row in metadata.get('inference_rules', [])}
    sources = {sid for rid in answer['rule_ids'] for sid in facts.get(rid, {}).get('source_ids', [])}
    assumptions = {aid for rid in answer['rule_ids'] for aid in inference.get(rid, {}).get('assumption_ids', [])}
    if inputs['kind'] in ('method_assessment', 'assess_session'):
        sources.update(sid for c in metadata.get('criteria', []) for sid in c['source_ids'])
    return {'id': digest(inputs), 'oracle': str(oracle.kb.relative_to(ROOT)) if oracle.kb.is_relative_to(ROOT) else oracle.kb.name,
            'oracle_fingerprint': oracle.fingerprint(), 'rule_ids': answer['rule_ids'],
            'source_ids': sorted(sources), 'assumption_ids': sorted(assumptions), 'glue_ids': ['GLUE_API', 'GLUE_SPLIT']}


def generate(output, oracle=None, states=None):
    oracle = oracle or PrologOracle()
    metadata = load_provenance() if oracle.kb == ROOT / 'knowledge_base/esc1.pl' else {}
    states = candidate_states(oracle) if states is None else states
    unique, group_splits = {}, {}
    for state in states:
        inputs = normalize_inputs(state['inputs'])
        group = state['group_id']
        if not isinstance(group, str) or not group:
            raise ValueError('Every state needs a nonempty group_id')
        split = state.get('split', split_for_group(group))
        if split not in ('train', 'validation', 'test'):
            raise ValueError('Invalid split')
        if group in group_splits and group_splits[group] != split:
            raise ValueError('A group cannot span splits')
        group_splits[group] = split
        key = canonical(inputs)
        record = {'id': digest(inputs), 'inputs': inputs, 'query': query_text(inputs), 'group_id': group, 'split': split}
        if key in unique and unique[key] != record:
            raise ValueError('Duplicate input with conflicting group/split')
        unique[key] = record
    records = [unique[key] for key in sorted(unique)]
    if not records:
        raise ValueError('No candidate states')
    answers = oracle.evaluate_many([r['inputs'] for r in records])
    audits = []
    for row, answer in zip(records, answers, strict=True):
        row['target'] = answer['target']
        audits.append(audit_for(row['inputs'], answer, oracle, metadata))
    output = Path(output)
    output.mkdir(parents=True, exist_ok=True)
    write_jsonl(output / 'cases.jsonl', records)
    write_jsonl(output / 'audit.jsonl', audits)
    for split in ('train', 'validation', 'test'):
        write_jsonl(output / (split + '.jsonl'), [r for r in records if r['split'] == split])
    covered = sorted({rid for audit in audits for rid in audit['rule_ids']})
    inventory = set(oracle.rule_ids())
    manifest = {
        'schema_version': 2, 'generator_sha256': digest(Path(__file__).read_text()),
        'oracle_fingerprint': oracle.fingerprint(), 'case_count': len(records),
        'cases_sha256': digest(records), 'audit_sha256': digest(audits),
        'split_counts': dict(Counter(r['split'] for r in records)),
        'query_kind_counts': dict(Counter(r['inputs']['kind'] for r in records)),
        'class_counts_by_split': {s: dict(Counter(class_label(r['target']) for r in records if r['split'] == s))
                                  for s in ('train', 'validation', 'test')},
        'split_policy': 'pollutant-family holdouts; entire backward/instrument families; grouped WP session profiles',
        'groups': group_splits, 'covered_rule_ids': covered,
        'uncovered_rule_ids': sorted(inventory - set(covered)), 'oracle_rule_count': len(inventory),
        'coverage_fraction': len(covered) / len(inventory),
        'limitations': ['Approximate POC semantics, not lost-source equivalence',
                       'Pollutant generalization holdout, not IID random rows',
                       'One documented instrument example; instrumentation is train-only',
                       'Backward tracing is test-only; prospective forward-to-backward generalization',
                       'Not all environmental edges are reachable in the selected domain'],
    }
    (output / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    return records, manifest


def class_label(target):
    return target['decision']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'dataset/generated')
    parser.add_argument('--kb', type=Path)
    parser.add_argument('--dependency', type=Path, action='append', default=[])
    parser.add_argument('--states', type=Path, help='Generic input/group_id/optional split JSONL; required for custom KBs')
    args = parser.parse_args()
    if args.kb and not args.states:
        parser.error('Custom KBs require --states; generic translation does not invent input domains')
    _, manifest = generate(args.output, PrologOracle(args.kb, args.dependency),
                           read_jsonl(args.states) if args.states else None)
    print(json.dumps({k: manifest[k] for k in ('case_count', 'split_counts', 'coverage_fraction')}))


if __name__ == '__main__':
    main()
