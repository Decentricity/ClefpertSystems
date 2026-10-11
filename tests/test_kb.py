import sys
from pathlib import Path
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from oracles import PrologOracle, load_provenance


class KnowledgeBaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.oracle = PrologOracle()
        cls.provenance = load_provenance()

    def test_documented_truth_table(self):
        for a, b, grade in [('yes', 'yes', 'L'), ('yes', 'no', 'S'),
                            ('no', 'yes', 'S'), ('no', 'no', 'N')]:
            answer = self.oracle.evaluate({'kind': 'score_pair', 'answer_1': a, 'answer_2': b})
            self.assertEqual(answer['target'], {'status': 'documented', 'value': grade})
            self.assertEqual(answer['rule_ids'], ['PAIR_' + a.upper() + '_' + b.upper()])

    def test_table_page_break_and_snippet(self):
        cases = [('CO', 'Birds', 2.0), ('Particulate', 'Birds', 2.0),
                 ('H2S', 'Birds', 1.0), ('Particulate', 'Land Animals Reptiles', 2.0),
                 ('Water Temperature', 'Microflora', 4.0)]
        for pollutant, environment, importance in cases:
            answer = self.oracle.evaluate({'kind': 'impact', 'pollutant': pollutant,
                                           'environment': environment})
            self.assertEqual(answer['target'], {'status': 'documented', 'value': importance})

    def test_unknown_relation_is_not_negative(self):
        answer = self.oracle.evaluate({'kind': 'impact', 'pollutant': 'CO', 'environment': 'Shrubs'})
        self.assertEqual(answer, {'target': {'status': 'undocumented'}, 'rule_ids': []})

    def test_missing_threshold_and_no_automatic_grade(self):
        unresolved = self.oracle.evaluate({'kind': 'criterion', 'criterion': 'comprehensiveness'})
        self.assertEqual(unresolved['target'], {'status': 'undocumented'})
        fixed = self.oracle.evaluate({'kind': 'criterion', 'criterion': 'uncertainty'})
        self.assertEqual(fixed['target']['value'], {'answer': 'yes'})
        self.assertEqual(self.oracle.evaluate({'kind': 'criterion', 'criterion': 'magnitude'})
                         ['target']['value'], {'answer': 'yes', 'grade': 'L'})

    def test_case_sensitive_snippet_and_unit_space(self):
        self.assertEqual(self.oracle.evaluate({'kind': 'unit', 'pollutant': 'Suspended solid'})
                         ['target']['value'], ' mg per liter')
        self.assertEqual(self.oracle.evaluate({'kind': 'unit', 'pollutant': 'Suspended Solid'})
                         ['target']['status'], 'undocumented')

    def test_no_interval_classification_or_inferred_edges(self):
        self.assertEqual(self.oracle.evaluate({'kind': 'standard', 'pollutant': 'SO2'})['target']['value'],
                         {'lower': 0, 'upper': 40.0, 'magnitude': 2.0})
        self.assertEqual(self.oracle.evaluate({'kind': 'indirect_impact', 'from': 'Microflora',
                                              'to': 'Water Temperature'})['target']['status'], 'undocumented')

    def test_invalid_queries_rejected(self):
        for inputs in [{}, {'kind': 'made_up'}, {'kind': 'criterion', 'criterion': 'made_up'},
                       {'kind': 'score_pair', 'answer_1': 'maybe', 'answer_2': 'yes'},
                       {'kind': 'score_pair', 'answer_1': True, 'answer_2': 'yes'},
                       {'kind': 'standard', 'pollutant': 'SO2', 'concentration': 40}]:
            with self.assertRaises(ValueError):
                self.oracle.evaluate(inputs)

    def test_provenance_and_executable_inventory_align(self):
        rules = self.provenance['rules']
        self.assertEqual(len(rules), 44)
        self.assertEqual(len({rule['id'] for rule in rules}), 44)
        for rule in rules:
            for sid in rule['source_ids']:
                source = self.provenance['sources'][sid]
                self.assertGreater(source['pdf_page'], 0)
                self.assertTrue(source['section'])
        domain = self.oracle.domain()
        answers = self.oracle.evaluate_many(domain)
        self.assertEqual({rid for answer in answers for rid in answer['rule_ids']},
                         {rule['id'] for rule in rules})

    def test_direct_prolog_api_rejects_invalid_queries(self):
        with self.assertRaises(RuntimeError):
            self.oracle._request({'action': 'evaluate', 'inputs': [{'kind': 'made_up'}]})
