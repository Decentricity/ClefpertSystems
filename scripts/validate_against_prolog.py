"""Compare saved model outputs to a fresh, versioned Prolog oracle."""
import argparse
from collections import Counter
import json
import math
from pathlib import Path
from generate_cases import class_label
from oracles import ROOT, PrologOracle, canonical, digest, normalize_inputs, query_text, read_jsonl


def evaluate(cases, predictions, oracle=None, audit=None):
    oracle = oracle or PrologOracle()
    if not cases:
        raise ValueError('Evaluation requires cases')
    case_ids = [row['id'] for row in cases]
    if len(set(case_ids)) != len(case_ids):
        raise ValueError('Duplicate case IDs')
    by_id = {}
    for prediction in predictions:
        if set(prediction) - {'id', 'output', 'confidence'} or not {'id', 'output'} <= set(prediction):
            raise ValueError('Predictions require id/output and optional confidence')
        pid = prediction['id']
        if not isinstance(pid, str) or pid not in case_ids or pid in by_id:
            raise ValueError('Duplicate or unknown prediction ID')
        if not isinstance(prediction['output'], dict):
            raise ValueError('Prediction output must be a parsed JSON object')
        canonical(prediction['output'])  # reject non-finite JSON values
        if 'confidence' in prediction:
            confidence = prediction['confidence']
            if (type(confidence) not in (int, float) or not math.isfinite(confidence)
                    or not 0 <= confidence <= 1):
                raise ValueError('Confidence must be a finite number in [0,1]')
        by_id[pid] = prediction
    answers = oracle.evaluate_many([case['inputs'] for case in cases])
    fingerprint = oracle.fingerprint()
    audit = read_jsonl(ROOT / 'dataset/generated/audit.jsonl') if audit is None else audit
    audit_by_id = {}
    for row in audit:
        if row['id'] in audit_by_id:
            raise ValueError('Duplicate audit ID')
        audit_by_id[row['id']] = row
    class_total, class_correct = Counter(), Counter()
    covered, correct_paths = set(), set()
    correct_count = supported_count = supported_correct = action_correct = 0
    wp_total, wp_correct = Counter(), Counter()
    disagreements, calibrated = [], []
    for case, answer in zip(cases, answers, strict=True):
        if (case['id'] != digest(normalize_inputs(case['inputs'])) or case['query'] != query_text(case['inputs'])
                or canonical(case['target']) != canonical(answer['target'])
                or case['id'] not in audit_by_id
                or audit_by_id[case['id']]['oracle_fingerprint'] != fingerprint
                or audit_by_id[case['id']]['rule_ids'] != answer['rule_ids']):
            raise ValueError('Stale or altered case; regenerate with current oracle')
        prediction = by_id.get(case['id'])
        output = prediction['output'] if prediction else None
        correct = canonical(output) == canonical(answer['target'])
        label = class_label(answer['target'])
        class_total[label] += 1
        class_correct[label] += correct
        correct_count += correct
        action_correct += output is not None and output.get("decision") == answer["target"]["decision"]
        expected_assessment = answer['target'].get('method_assessment', answer['target'])
        observed_assessment = output.get('method_assessment', output) if output else {}
        if not isinstance(observed_assessment, dict):
            observed_assessment = {}
        for scope in ('criterion_grades', 'aspect_grades'):
            for name, grade in expected_assessment.get(scope, {}).items():
                key = scope + ':' + name
                wp_total[key] += 1
                guessed = observed_assessment.get(scope, {})
                wp_correct[key] += isinstance(guessed, dict) and guessed.get(name) == grade
        supported = answer['target']['decision'] != 'insufficient_data'
        supported_count += supported
        supported_correct += supported and correct
        covered.update(answer['rule_ids'])
        if correct:
            correct_paths.update(answer['rule_ids'])
        else:
            disagreements.append({'id': case['id'], 'inputs': case['inputs'],
                                  'expected': answer['target'], 'actual': output,
                                  'reason': 'missing' if prediction is None else 'disagreement',
                                  'rule_ids': answer['rule_ids']})
        if prediction and 'confidence' in prediction:
            calibrated.append((prediction['confidence'], int(correct)))
    bins = []
    for i in range(10):
        items = [(confidence, correctness) for confidence, correctness in calibrated
                 if min(int(confidence * 10), 9) == i]
        if items:
            bins.append({'lower': i / 10, 'upper': (i + 1) / 10, 'count': len(items),
                         'mean_confidence': sum(c for c, _ in items) / len(items),
                         'accuracy': sum(a for _, a in items) / len(items)})
    all_rules = set(oracle.rule_ids())
    return {
        'oracle_fingerprint': fingerprint, 'case_count': len(cases),
        'prediction_count': len(predictions), 'missing_count': len(cases) - len(predictions),
        'exact_decision_agreement': correct_count / len(cases),
        'action_label_agreement': action_correct / len(cases),
        'warner_preston_accuracy': {key: {'count': count, 'accuracy': wp_correct[key] / count}
                                  for key, count in sorted(wp_total.items())},
        'supported_case_count': supported_count,
        'supported_only_agreement': supported_correct / supported_count if supported_count else None,
        'per_class': {label: {'count': count, 'correct': class_correct[label],
                              'accuracy': class_correct[label] / count}
                      for label, count in sorted(class_total.items())},
        'confidence_in_correctness': {
            'count': len(calibrated),
            'brier_score': sum((c - a) ** 2 for c, a in calibrated) / len(calibrated) if calibrated else None,
            'expected_calibration_error': sum(b['count'] * abs(b['mean_confidence'] - b['accuracy'])
                                              for b in bins) / len(calibrated) if calibrated else None,
            'reliability_bins': bins},
        'rule_path_coverage': {'covered_rule_ids': sorted(covered),
                               'correctly_reproduced_rule_ids': sorted(correct_paths),
                               'domain_rule_count': len(all_rules),
                               'fraction_of_domain_rules': len(covered) / len(all_rules),
                               'uncovered_rule_ids': sorted(all_rules - covered)},
        'disagreements': disagreements,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--cases', type=Path, required=True)
    parser.add_argument('--predictions', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    parser.add_argument('--audit', type=Path)
    parser.add_argument('--kb', type=Path)
    parser.add_argument('--dependency', type=Path, action='append', default=[])
    args = parser.parse_args()
    audit_path = args.audit or args.cases.parent / 'audit.jsonl'
    report = evaluate(read_jsonl(args.cases), read_jsonl(args.predictions),
                      PrologOracle(args.kb, args.dependency), read_jsonl(audit_path))
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2, allow_nan=False) + '\n')
    print(json.dumps({key: report[key] for key in ('case_count', 'exact_decision_agreement', 'missing_count')}))


if __name__ == '__main__':
    main()
