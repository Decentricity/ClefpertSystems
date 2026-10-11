import copy
import itertools
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from export_clef_dataset import export
from generate_cases import generate
from oracles import ROOT, PrologOracle, canonical, digest, read_jsonl
from validate_against_prolog import evaluate


class DatasetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.cases = read_jsonl(ROOT / 'dataset/generated/cases.jsonl')
        cls.oracle = PrologOracle()

    def predictions(self):
        return [{'id': c['id'], 'output': c['target'], 'confidence': 1.0} for c in self.cases]

    def test_no_duplicate_or_near_neighbor_leakage(self):
        self.assertEqual(len({canonical(c['inputs']) for c in self.cases}), len(self.cases))
        for a, b in itertools.combinations(self.cases, 2):
            if a['inputs']['kind'] == b['inputs']['kind']:
                differences = sum(a['inputs'][key] != b['inputs'][key] for key in a['inputs'])
                if differences <= 1:
                    self.assertEqual(a['split'], b['split'])
        for split in ['train', 'validation', 'test']:
            self.assertEqual(read_jsonl(ROOT / f'dataset/generated/{split}.jsonl'),
                             [c for c in self.cases if c['split'] == split])

    def test_fresh_oracle_and_rule_coverage(self):
        report = evaluate(self.cases, self.predictions(), self.oracle)
        self.assertEqual(report['exact_decision_agreement'], 1.0)
        self.assertEqual(report['rule_path_coverage']['fraction_of_domain_rules'], 1.0)
        self.assertEqual(report['confidence_in_correctness']['brier_score'], 0.0)
        self.assertEqual(report['confidence_in_correctness']['count'], len(self.cases))

    def test_reproducible_generation(self):
        with tempfile.TemporaryDirectory() as path:
            rows, manifest = generate(Path(path))
            self.assertEqual(rows, self.cases)
            self.assertEqual(manifest, json.loads((ROOT / 'dataset/generated/manifest.json').read_text()))
            self.assertEqual(manifest['cases_sha256'], digest(rows))

    def test_wrong_missing_and_bool_numeric_confusion(self):
        predictions = self.predictions()
        predictions[0] = {**predictions[0], 'output': {'status': 'wrong'}, 'confidence': 1.0}
        predictions.pop()
        report = evaluate(self.cases, predictions, self.oracle)
        self.assertAlmostEqual(report['exact_decision_agreement'], (len(self.cases) - 2) / len(self.cases))
        self.assertEqual(report['missing_count'], 1)
        self.assertEqual(len(report['disagreements']), 2)
        self.assertGreater(report['confidence_in_correctness']['brier_score'], 0)
        self.assertNotEqual(canonical({'value': True}), canonical({'value': 1.0}))

    def test_invalid_predictions_rejected(self):
        base = self.predictions()[0]
        variants = [[base, base], [{'id': 'unknown', 'output': {}}],
                    [{**base, 'confidence': 1.1}], [{**base, 'confidence': True}],
                    [{**base, 'confidence': float('nan')}], [{**base, 'output': 'L'}]]
        for predictions in variants:
            with self.assertRaises(ValueError):
                evaluate(self.cases, predictions, self.oracle)

    def test_stale_cases_rejected(self):
        for field in ['target', 'fingerprint', 'rule_ids', 'id', 'query']:
            cases = copy.deepcopy(self.cases)
            if field == 'target':
                cases[0]['target'] = {'status': 'invented'}
            elif field == 'fingerprint':
                cases[0]['provenance']['oracle_fingerprint'] = 'stale'
            elif field == 'rule_ids':
                cases[0]['provenance']['rule_ids'] = ['invented']
            else:
                cases[0][field] = 'altered'
            with self.assertRaises(ValueError):
                evaluate(cases, [], self.oracle)

    def test_export_contains_only_prompt_and_target(self):
        rows = list(export(self.cases))
        self.assertEqual(len(rows), len(self.cases))
        for case, row in zip(self.cases, rows):
            self.assertEqual(row, {'messages': [{'role': 'user', 'content': case['query']},
                                              {'role': 'assistant', 'content': canonical(case['target'])}]})
