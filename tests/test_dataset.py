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
        cls.audit = read_jsonl(ROOT / 'dataset/generated/audit.jsonl')
        cls.oracle = PrologOracle()
        cls.sample = cls.cases[:12]

    def predictions(self, cases=None):
        return [{'id': c['id'], 'output': c['target'], 'confidence': 1.0} for c in (cases or self.sample)]

    def test_no_duplicate_or_causal_family_leakage(self):
        self.assertEqual(len({canonical(c['inputs']) for c in self.cases}), len(self.cases))
        groups, pollutants, wp_sessions = {}, {}, {}
        for case in self.cases:
            self.assertEqual(groups.setdefault(case['group_id'], case['split']), case['split'])
            kind = case['inputs']['kind']
            if kind in ('assess', 'assess_concentration'):
                self.assertEqual(pollutants.setdefault(case['inputs']['pollutant'], case['split']), case['split'])
            if kind == 'method_assessment':
                key = canonical(case['inputs']['counts'])
                self.assertEqual(wp_sessions.setdefault(key, case['split']), case['split'])
        ambient_families = {'PM2.5': 'Particulate', 'PM10': 'Particulate',
                            'CO': 'CO', 'SO2': 'SO2', 'NO2': 'NO2', 'O3': 'O3', 'Pb': 'Pb'}
        ambient_domain = self.oracle.domain()['ambient_standards']
        for case in self.cases:
            if case['inputs']['kind'] == 'screen_ambient':
                pollutant = next(s['pollutant'] for s in ambient_domain
                                 if s['standard'] == case['inputs']['standard'])
                family = ambient_families[pollutant]
                self.assertEqual(case['group_id'], 'pollutant:' + family)
                self.assertEqual(pollutants.setdefault(family, case['split']), case['split'])
        profiles = {canonical(c['inputs']['counts']): c for c in self.cases
                    if c['inputs']['kind'] == 'method_assessment'}
        for a, b in itertools.combinations(profiles.values(), 2):
            distance = sum(a['inputs']['counts'][k] != b['inputs']['counts'][k] for k in a['inputs']['counts'])
            self.assertGreater(distance, 1)
        for split in ['train', 'validation', 'test']:
            self.assertEqual(read_jsonl(ROOT / f'dataset/generated/{split}.jsonl'),
                             [c for c in self.cases if c['split'] == split])

    def test_training_data_contains_no_paper_or_audit_metadata(self):
        prohibited = {'chapter', 'pdf_page', 'printed_page', 'section', 'provenance', 'rule_ids', 'source_ids', 'assumption_ids'}
        def check(value):
            if isinstance(value, dict):
                self.assertFalse(prohibited & set(value))
                for v in value.values():
                    check(v)
            elif isinstance(value, list):
                for v in value:
                    check(v)
        for row in self.cases:
            check(row)
            self.assertNotIn('thesis', row['query'].lower())
            self.assertEqual(set(row), {'id', 'inputs', 'query', 'group_id', 'split', 'target'})
        self.assertEqual({r['id'] for r in self.audit}, {r['id'] for r in self.cases})
        self.assertTrue(any(r['assumption_ids'] for r in self.audit))

    def test_fresh_oracle_and_reported_rule_coverage(self):
        report = evaluate(self.cases, self.predictions(self.cases), self.oracle, self.audit)
        self.assertEqual(report['exact_decision_agreement'], 1.0)
        self.assertEqual(report['action_label_agreement'], 1.0)
        self.assertEqual(report['confidence_in_correctness']['brier_score'], 0.0)
        manifest = json.loads((ROOT / 'dataset/generated/manifest.json').read_text())
        self.assertEqual(report['rule_path_coverage']['covered_rule_ids'], manifest['covered_rule_ids'])
        self.assertGreater(report['rule_path_coverage']['fraction_of_domain_rules'], 0.9)
        self.assertTrue(report['rule_path_coverage']['uncovered_rule_ids'])
        self.assertTrue(report['warner_preston_accuracy'])

    def test_reproducible_generation(self):
        with tempfile.TemporaryDirectory() as path:
            rows, manifest = generate(Path(path))
            self.assertEqual(rows, self.cases)
            self.assertEqual(manifest, json.loads((ROOT / 'dataset/generated/manifest.json').read_text()))
            self.assertEqual(read_jsonl(Path(path) / 'audit.jsonl'), self.audit)
            self.assertEqual(manifest['cases_sha256'], digest(rows))

    def test_wrong_missing_and_confidence_metrics(self):
        predictions = self.predictions()
        predictions[0] = {**predictions[0], 'output': {'decision': 'wrong'}, 'confidence': 1.0}
        predictions.pop()
        report = evaluate(self.sample, predictions, self.oracle, self.audit)
        self.assertAlmostEqual(report['exact_decision_agreement'], (len(self.sample) - 2) / len(self.sample))
        self.assertEqual(report['missing_count'], 1)
        self.assertEqual(len(report['disagreements']), 2)
        self.assertGreater(report['confidence_in_correctness']['brier_score'], 0)

    def test_invalid_predictions_rejected(self):
        base = self.predictions()[0]
        variants = [[base, base], [{'id': 'unknown', 'output': {}}],
                    [{**base, 'confidence': 1.1}], [{**base, 'confidence': True}],
                    [{**base, 'confidence': float('nan')}], [{**base, 'output': 'L'}]]
        for predictions in variants:
            with self.assertRaises(ValueError):
                evaluate(self.sample, predictions, self.oracle, self.audit)

    def test_stale_cases_and_audit_rejected(self):
        for field in ['target', 'fingerprint', 'rule_ids', 'id', 'query']:
            cases, audit = copy.deepcopy(self.sample), copy.deepcopy(self.audit)
            audit_row = next(row for row in audit if row['id'] == cases[0]['id'])
            if field == 'target':
                cases[0]['target'] = {'decision': 'invented'}
            elif field == 'fingerprint':
                audit_row['oracle_fingerprint'] = 'stale'
            elif field == 'rule_ids':
                audit_row['rule_ids'] = ['invented']
            else:
                cases[0][field] = 'altered'
            with self.assertRaises(ValueError):
                evaluate(cases, [], self.oracle, audit)

    def test_export_contains_only_scenario_and_oracle_target(self):
        rows = list(export(self.sample))
        for case, row in zip(self.sample, rows):
            self.assertEqual(row, {'messages': [{'role': 'user', 'content': case['query']},
                                              {'role': 'assistant', 'content': canonical(case['target'])}]})
        contract = {'schema_name': 'fixture_only', 'schema_version': 'test', 'layout': 'pair',
                    'input_field': 'input', 'target_field': 'output'}
        pair = list(export(self.sample, 'clef', contract))[0]
        self.assertEqual(set(pair), {'input', 'output'})
        self.assertEqual(json.loads(pair['output']), self.sample[0]['target'])
        with self.assertRaises(ValueError):
            list(export(self.sample, 'clef'))

    def test_generic_adapter_executes_an_unrelated_prolog_system(self):
        oracle = PrologOracle(ROOT / 'examples/tiny_kb.pl')
        with tempfile.TemporaryDirectory() as path:
            rows, manifest = generate(Path(path), oracle, read_jsonl(ROOT / 'examples/tiny_states.jsonl'))
            self.assertEqual({r['target']['decision'] for r in rows}, {'heat', 'hold', 'cool'})
            self.assertEqual(manifest['coverage_fraction'], 1.0)
            audit = read_jsonl(Path(path) / 'audit.jsonl')
            self.assertTrue(all(r['source_ids'] == [] for r in audit))
            report = evaluate(rows, self.predictions(rows), oracle, audit)
            self.assertEqual(report['exact_decision_agreement'], 1.0)

    def test_conflicting_group_assignment_rejected(self):
        oracle = PrologOracle(ROOT / 'examples/tiny_kb.pl')
        inputs = {'kind': 'thermostat', 'temperature': 10}
        states = [{'inputs': inputs, 'group_id': 'same', 'split': split} for split in ['train', 'test']]
        with tempfile.TemporaryDirectory() as path, self.assertRaises(ValueError):
            generate(Path(path), oracle, states)
