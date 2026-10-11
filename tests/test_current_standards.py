"""Current-reference semantics, independently sourced boundary fixtures and isolation."""
import json
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from oracles import ROOT, PrologOracle


def ambient(standard='pm25_annual_primary', value=9, unit='ug/m3', statistic='annual_mean_3y',
            reference_level=9, reference_unit='ug/m3'):
    return {'kind': 'screen_ambient', 'profile': 'us_epa_naaqs_2025', 'standard': standard,
            'sampling_context': 'ambient_air', 'summary': {'data_status': 'complete',
            'statistic': statistic, 'value': value, 'unit': unit,
            'reference_level': reference_level, 'reference_unit': reference_unit}}


class CurrentStandardsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.oracle = PrologOracle()

    def result(self, case):
        return self.oracle.evaluate(case)['target']

    def test_updated_pm25_and_so2_levels_not_obsolete_values(self):
        # EPA table: PM2.5 primary annual 9.0, secondary annual 15.0;
        # new annual secondary SO2 10 ppb. These are NOT historical ESC bands.
        self.assertEqual(self.result(ambient(value=10))['decision'], 'exceeds_reference')
        self.assertEqual(self.result(ambient('pm25_annual_secondary', value=10,
                                            reference_level=15))['decision'], 'within_reference')
        so2 = ambient('so2_annual_secondary', 10.01, 'ppb', reference_level=10, reference_unit='ppb')
        self.assertEqual(self.result(so2)['decision'], 'exceeds_reference')
        so2['summary']['value'] = 10
        self.assertEqual(self.result(so2)['decision'], 'within_reference')

    def test_all_source_rows_match_frozen_transcription(self):
        rows = json.loads((ROOT / 'docs/evidence/current-standards-transcription.json').read_text())
        inventory = {r['standard']: r for r in self.oracle.domain()['ambient_standards']}
        self.assertEqual(len(rows), 12)
        for row in rows:
            self.assertEqual(inventory[row['standard']], {k: v for k, v in row.items()
                                                         if k not in ('id', 'source_form')})
        evidence = json.loads((ROOT / 'docs/evidence/current-standards-source.json').read_text())
        text = json.dumps(evidence['table_rows'], ensure_ascii=False)
        for snippet in ['9.0 μg/m3', '10 ppb', '2024']:
            self.assertIn(snippet, text if snippet != '2024' else ' '.join(evidence['footnotes']))

    def test_unit_equivalence_at_boundary_and_above(self):
        cases = [ambient(value=9), ambient(value=0.009, unit='mg/m3'),
                 ambient(value=9.01), ambient(value=0.00901, unit='mg/m3'),
                 ambient('so2_1h_primary',75,'ppb','daily_max_1h_p99_3y',75,'ppb'),
                 ambient('so2_1h_primary',0.075,'ppm','daily_max_1h_p99_3y',0.075,'ppm'),
                 ambient('so2_1h_primary',75.1,'ppb','daily_max_1h_p99_3y',75,'ppb')]
        answers = [a['target'] for a in self.oracle.evaluate_many(cases)]
        self.assertEqual(answers[0], answers[1])
        self.assertEqual(answers[2]['decision'], answers[3]['decision'])
        self.assertEqual(answers[4], answers[5])
        self.assertEqual(answers[6]['decision'], 'exceeds_reference')

    def test_frequency_limits_need_counts_not_concentration(self):
        case = ambient('co_8h_primary',1,'count_per_year','annual_exceedances',9,'ppm')
        self.assertEqual(self.result(case)['decision'], 'within_reference')
        case['summary']['value'] = 2
        self.assertEqual(self.result(case)['decision'], 'exceeds_reference')
        case['summary']['unit'] = 'ppm'
        self.assertEqual(self.result(case)['reason'], 'unsupported_summary_unit')
        case['summary'].update(unit='count_per_year', value=0.5)
        self.assertEqual(self.result(case)['reason'], 'annual_count_must_be_integer')
        pm10 = ambient('pm10_24h',1.1,'count_per_year','mean_annual_exceedances_3y',150,'ug/m3')
        self.assertEqual(self.result(pm10)['decision'], 'exceeds_reference')
        pm10['summary']['value'] = 1
        self.assertEqual(self.result(pm10)['decision'], 'within_reference')

    def test_percentile_and_rolling_forms_cannot_be_replaced_by_means(self):
        cases = [ambient('pm25_24h',35,'ug/m3','daily_mean_24h_p98_3y',35,'ug/m3'),
                 ambient('no2_1h_primary',100,'ppb','daily_max_1h_p98_3y',100,'ppb'),
                 ambient('o3_8h',0.070,'ppm','daily_max_8h_fourth_highest_3y',0.070,'ppm'),
                 ambient('pb_3month',0.15,'ug/m3','max_rolling_3month_mean_3y',0.15,'ug/m3')]
        for case in cases:
            self.assertEqual(self.result(case)['decision'], 'within_reference')
            case['summary']['statistic'] = 'annual_mean'
            self.assertEqual(self.result(case)['reason'], 'statistical_form_mismatch')

    def test_scope_completeness_and_reference_mismatch_abstain(self):
        variants = []
        for status in ['incomplete', 'unverified']:
            case = ambient(); case['summary']['data_status'] = status
            variants.append((case,'incomplete_or_unverified_summary'))
        case = ambient(); case['sampling_context'] = 'stack_emission'
        variants.append((case,'requires_ambient_air_context'))
        case = ambient(); case['profile'] = 'indonesia_unconfigured'
        variants.append((case,'unknown_profile_or_standard'))
        case = ambient(); case['standard'] = 'h2s_1h'
        variants.append((case,'unknown_profile_or_standard'))
        case = ambient(); case['summary']['reference_level'] = 12
        variants.append((case,'reference_threshold_mismatch'))
        case = ambient(); case['summary']['unit'] = 'ppm'
        variants.append((case,'unsupported_summary_unit'))
        for case, reason in variants:
            target = self.result(case)
            self.assertEqual(target['decision'], 'insufficient_data')
            self.assertEqual(target['reason'], reason)

    def test_invalid_numeric_or_shape_requests_rejected(self):
        for value in [-1, True, float('nan'), float('inf'), '9']:
            case = ambient();case['summary']['value'] = value
            with self.assertRaises(ValueError):self.oracle.evaluate(case)
        case = ambient();case['summary']['extra_field'] = 1
        with self.assertRaises(ValueError):self.oracle.evaluate(case)
        case = ambient();del case['summary']['statistic']
        with self.assertRaises(ValueError):self.oracle.evaluate(case)

    def test_current_dependency_is_fingerprinted_and_historical_profile_is_preserved(self):
        self.assertIn(ROOT / 'knowledge_base/current_standards.pl', self.oracle.dependencies)
        case = {'kind':'assess_concentration','pollutant':'H2S','concentration':21,
                'processes':['Mineral Processing'],'receptors':['Shrubs']}
        target = self.result(case)
        self.assertEqual(target['resolved_magnitude'],7)
        self.assertEqual(target['source_units'],'unspecified')
        trace = self.oracle.evaluate(ambient())['rule_ids']
        self.assertIn('CURRENT_NAAQS_07',trace)
        self.assertNotIn('R_PRIORITY',trace)
