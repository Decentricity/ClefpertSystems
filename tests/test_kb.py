import sys
from pathlib import Path
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from oracles import PrologOracle, load_provenance


def scenario(magnitude=5, pollutant='SO2', receptors=None, processes=None):
    return {'kind': 'assess', 'magnitude': magnitude, 'pollutant': pollutant,
            'receptors': receptors or ['Shrubs'], 'processes': processes or ['Mineral Processing']}


class KnowledgeBaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.oracle = PrologOracle()

    def test_runnable_forward_inference(self):
        answer = self.oracle.evaluate(scenario())
        self.assertEqual(answer['target']['decision'], 'mitigate')
        self.assertEqual(answer['target']['direct_impacts'][0]['importance'], 4.0)
        self.assertEqual(answer['target']['maximum_score'], 20.0)
        self.assertTrue(answer['target']['mitigations'])
        self.assertTrue({'R_FORWARD', 'R_DIRECT', 'R_PRIORITY', 'R_MITIGATION'} <= set(answer['rule_ids']))

    def test_priority_boundaries(self):
        for magnitude, decision in [(0, 'no_detected_impact'), (2.499, 'monitor'),
                                     (2.5, 'mitigate'), (9.999, 'mitigate'), (10, 'urgent_review')]:
            self.assertEqual(self.oracle.evaluate(scenario(magnitude))['target']['decision'], decision)

    def test_two_hop_indirect_reasoning_and_cycle_avoidance(self):
        target = self.oracle.evaluate(scenario(5, 'Suspended Solid',
                                               ['Surface Water', 'Aquatic Plants', 'Birds']))['target']
        self.assertEqual(target['decision'], 'urgent_review')
        paths = [item['path'] for item in target['indirect_impacts']]
        self.assertIn(['Surface Water', 'Aquatic Plants', 'Birds'], paths)
        for path in paths:
            self.assertEqual(len(path), len(set(path)))
            self.assertLessEqual(len(path), 3)

    def test_zero_exposure_does_not_trigger_indirect_or_mitigation(self):
        target = self.oracle.evaluate(scenario(0, 'Suspended Solid',
                                               ['Surface Water', 'Aquatic Plants', 'Birds']))['target']
        self.assertEqual(target['decision'], 'no_detected_impact')
        self.assertEqual(target['indirect_impacts'], [])
        self.assertEqual(target['mitigations'], [])

    def test_absent_relation_abstains(self):
        target = self.oracle.evaluate(scenario(5, 'CO', ['Aquatic Plants']))['target']
        self.assertEqual(target['decision'], 'insufficient_data')
        self.assertEqual(target['unresolved_receptors'], ['Aquatic Plants'])

    def test_backward_candidates_join_emissions_and_impacts(self):
        answer = self.oracle.evaluate({'kind': 'trace_back', 'receptor': 'Birds'})
        self.assertEqual(answer['target']['decision'], 'candidate_sources')
        source = next(x for x in answer['target']['direct_sources'] if x['pollutant'] == 'SO2')
        self.assertIn('Mineral Processing', source['processes'])
        self.assertTrue(answer['target']['indirect_sources'])
        self.assertIn('R_BACKWARD', answer['rule_ids'])

    def test_standard_boundaries_and_no_extrapolation(self):
        for concentration, expected in [(0, 2), (10.499, 2), (10.5, 4), (21, 7), (42, 10), (1000, 10)]:
            inputs = scenario(pollutant='H2S')
            inputs.pop('magnitude')
            inputs.update(kind='assess_concentration', concentration=concentration)
            self.assertEqual(self.oracle.evaluate(inputs)['target']['resolved_magnitude'], expected)
        inputs['concentration'] = 1001
        self.assertEqual(self.oracle.evaluate(inputs)['target']['decision'], 'insufficient_data')

    def test_instrument_detection_boundary_preserves_variability(self):
        case = {'kind': 'instrumentation', 'pollutant': 'Suspended solid',
                'technique': 'Non-filterable residue by drying oven', 'observed_value': 3.999}
        self.assertEqual(self.oracle.evaluate(case)['target']['decision'], 'below_detection_limit')
        case['observed_value'] = 4
        result = self.oracle.evaluate(case)['target']
        self.assertEqual(result['decision'], 'measurable')
        self.assertEqual(result['variability'], 5.8)
        self.assertEqual(result['unit'], ' mg per liter')

    def test_social_effects_are_inferred_even_when_consequence_is_unresolved(self):
        target = self.oracle.evaluate(scenario(1, 'Particulate', ['Birds'], ['Blasting and Drilling']))['target']
        migration = next(x for x in target['social_impacts'] if x['factor'] == 'Migration')
        self.assertIn('changes in demand on health and social services', migration['consequences'])
        self.assertIn('Transportation Systems', target['unresolved_social_factors'])

    def test_full_twenty_criterion_wp_profile(self):
        domain = self.oracle.domain()
        inputs = {'kind': 'method_assessment', 'counts': {field: 2 for field in domain['wp_fields']},
                  'answers': {'impact_isolation': 'yes', 'explicit_indicators': 'yes', 'significance': 'yes'}}
        target = self.oracle.evaluate(inputs)['target']
        self.assertEqual(len(target['criterion_grades']), 20)
        self.assertEqual(set(target['aspect_grades']), {'identification', 'measurement', 'interpretation', 'communication'})
        self.assertEqual(target['criterion_grades']['public_involvement'], 'N')
        self.assertEqual(target['criterion_grades']['magnitude'], 'L')
        inputs['counts'] = {field: 0 for field in domain['wp_fields']}
        inputs['answers'] = {field: 'no' for field in inputs['answers']}
        other = self.oracle.evaluate(inputs)['target']
        self.assertEqual(other['criterion_grades']['comprehensiveness'], 'N')
        self.assertNotEqual(other['aspect_grades'], target['aspect_grades'])

    def test_input_order_does_not_change_answers(self):
        a = scenario(5, 'Particulate', ['Birds', 'Shrubs'], ['Mineral Processing', 'Product Storage'])
        b = {**a, 'receptors': a['receptors'][::-1], 'processes': a['processes'][::-1]}
        self.assertEqual(self.oracle.evaluate(a), self.oracle.evaluate(b))

    def test_invalid_states_rejected(self):
        for case in [{}, scenario(-1), scenario(float('nan')), scenario(True), scenario(11),
                     scenario(processes=['not a process']), scenario(receptors=['unknown']),
                     {**scenario(), 'chapter': 5}, scenario(receptors=['Shrubs', 'Shrubs']),
                     scenario(pollutant='SO2', processes=['Product Storage'])]:
            with self.assertRaises(ValueError):
                self.oracle.evaluate(case)

    def test_fact_and_rule_inventory_matches_executable(self):
        provenance = load_provenance()
        inventory = {row['id'] for row in provenance['facts'] + provenance['inference_rules']}
        self.assertEqual(inventory, set(self.oracle.rule_ids()))
        for fact in provenance['facts']:
            for sid in fact['source_ids']:
                source = provenance['sources'][sid]
                if source.get('type') == 'web':
                    self.assertTrue(source['url'].startswith('https://www.epa.gov/'))
                    self.assertTrue(source['retrieved_on'])
                else:
                    self.assertGreater(source['pdf_page'], 0)
        self.assertGreater(len(provenance['facts']), 200)

    def test_session_counts_are_derived_from_executed_analyses(self):
        inputs = {'kind': 'assess_session', 'cases': [scenario(5), scenario(0, receptors=['Birds'])],
                  'answers': {'impact_isolation': 'yes', 'explicit_indicators': 'yes', 'significance': 'yes'},
                  'alternatives': 2, 'declared_assumptions': 2, 'objective_measurements': 2,
                  'staged_activities': 1, 'rare_severe_impacts': 0}
        result = self.oracle.evaluate(inputs)
        target = result['target']
        self.assertEqual(target['decision'], 'session_assessed')
        self.assertEqual(target['observed_session_counts']['impacts'], 1)
        self.assertEqual(target['observed_session_counts']['components'], 2)
        self.assertEqual(target['observed_session_counts']['activities'], 1)
        self.assertEqual(target['method_assessment']['criterion_grades']['comprehensiveness'], 'S')
        self.assertTrue({'R_SESSION', 'R_WP', 'R_DIRECT'} <= set(result['rule_ids']))
