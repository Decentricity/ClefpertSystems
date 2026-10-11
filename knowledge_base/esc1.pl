% Reconstructed documented subset, NOT lost ESC-1 source.
% See provenance.yaml for translation status and exact chapter/page references.
:- module(esc1, [evaluate/3, domain_case/1, rule_id/1]).
:- use_module(library(http/json)).
:- use_module(library(apply)).
:- use_module(library(lists)).

% DOCUMENTED FACTS AND FAITHFUL TRANSLATIONS
% datum(Kind, Inputs, Value, RuleId). Strings remain case-sensitive.
% IMPACT_01: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 3; T5_01
datum("impact", _{pollutant:"Water Temperature", environment:"Surface Water"}, 8.0, "IMPACT_01").
% IMPACT_02: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 3; T5_02
datum("impact", _{pollutant:"Suspended Solid", environment:"Surface Water"}, 8.0, "IMPACT_02").
% IMPACT_03: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 4; T5_03
datum("impact", _{pollutant:"SO2", environment:"Shrubs"}, 4.0, "IMPACT_03").
% IMPACT_04: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 4; T5_04
datum("impact", _{pollutant:"Particulate", environment:"Shrubs"}, 2.0, "IMPACT_04").
% IMPACT_05: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 4; T5_05
datum("impact", _{pollutant:"H2S", environment:"Shrubs"}, 1.0, "IMPACT_05").
% IMPACT_06: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 5; T5_06
datum("impact", _{pollutant:"SO2", environment:"Microflora"}, 6.0, "IMPACT_06").
% IMPACT_07: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 5; T5_07
datum("impact", _{pollutant:"Particulate", environment:"Microflora"}, 2.0, "IMPACT_07").
% IMPACT_08: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 5; T5_08
datum("impact", _{pollutant:"H2S", environment:"Microflora"}, 4.0, "IMPACT_08").
% IMPACT_09: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 5; T5_09
datum("impact", _{pollutant:"Water Temperature", environment:"Microflora"}, 4.0, "IMPACT_09").
% IMPACT_10: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 5; T5_10
datum("impact", _{pollutant:"Suspended Solid", environment:"Microflora"}, 2.0, "IMPACT_10").
% IMPACT_11: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 6; T5_11
datum("impact", _{pollutant:"SO2", environment:"Endangered Species of Flora"}, 8.0, "IMPACT_11").
% IMPACT_12: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 6; T5_12
datum("impact", _{pollutant:"CO", environment:"Endangered Species of Flora"}, 6.0, "IMPACT_12").
% IMPACT_13: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 6; T5_13
datum("impact", _{pollutant:"Particulate", environment:"Endangered Species of Flora"}, 4.0, "IMPACT_13").
% IMPACT_14: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 6; T5_14
datum("impact", _{pollutant:"H2S", environment:"Endangered Species of Flora"}, 1.0, "IMPACT_14").
% IMPACT_15: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 6; T5_15
datum("impact", _{pollutant:"Water Temperature", environment:"Endangered Species of Flora"}, 8.0, "IMPACT_15").
% IMPACT_16: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / row 6; T5_16
datum("impact", _{pollutant:"Suspended Solid", environment:"Endangered Species of Flora"}, 2.0, "IMPACT_16").
% IMPACT_17: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / unnumbered Birds row; T5_17
datum("impact", _{pollutant:"SO2", environment:"Birds"}, 4.0, "IMPACT_17").
% IMPACT_18: bab5 PDF p.2 (V-2), 5.2 / Table 5.1 / unnumbered Birds row; T5_18
datum("impact", _{pollutant:"CO", environment:"Birds"}, 2.0, "IMPACT_18").
% IMPACT_19: bab5 PDF p.3 (V-3), 5.2 / Table 5.1 / continuation of Birds row; T5_19
datum("impact", _{pollutant:"Particulate", environment:"Birds"}, 2.0, "IMPACT_19").
% IMPACT_20: bab5 PDF p.3 (V-3), 5.2 / Table 5.1 / continuation of Birds row; T5_20
datum("impact", _{pollutant:"H2S", environment:"Birds"}, 1.0, "IMPACT_20").
% IMPACT_21: bab5 PDF p.3 (V-3), 5.2 / Table 5.1 / row 7; T5_21
datum("impact", _{pollutant:"SO2", environment:"Land Animals Reptiles"}, 1.0, "IMPACT_21").
% IMPACT_22: bab5 PDF p.3 (V-3), 5.2 / Table 5.1 / row 7; T5_22
datum("impact", _{pollutant:"Particulate", environment:"Land Animals Reptiles"}, 2.0, "IMPACT_22").
% IMPACT_23: bab5 PDF p.3 (V-3), 5.2 / Table 5.1 / row 7; T5_23
datum("impact", _{pollutant:"H2S", environment:"Land Animals Reptiles"}, 1.0, "IMPACT_23").
% IMPACT_24: bab5 PDF p.3 (V-3), 5.2 / Table 5.1 / row 7; T5_24
datum("impact", _{pollutant:"Water Temperature", environment:"Land Animals Reptiles"}, 1.0, "IMPACT_24").
% STANDARD_SO2: bab4 PDF p.8 (IV-8), 4.4.1; EX_STANDARD_SO2
datum("standard", _{pollutant:"SO2"}, _{lower:0, upper:40.0, magnitude:2.0}, "STANDARD_SO2").
% SOCIAL_BLASTING: bab4 PDF p.13 (IV-13), 4.4.2.2; EX_SOCIAL_BLASTING
datum("impact_se", _{activity:"Blasting and Drilling", factor:"Migration"}, 1.0, "SOCIAL_BLASTING").
% INDIRECT_WATER: bab4 PDF p.15 (IV-15), 4.5; EX_INDIRECT_WATER
datum("indirect_impact", _{from:"Water Temperature", to:"Microflora"}, true, "INDIRECT_WATER").
% INDIRECT_GASSES: bab4 PDF p.15 (IV-15), 4.5; EX_INDIRECT_GASSES
datum("indirect_impact", _{from:"Gasses and Particulate", to:"Health and Safety"}, true, "INDIRECT_GASSES").
% SOC_MIGRATION: bab4 PDF p.18 (IV-18), 4.6; EX_SOC_MIGRATION
datum("soc_ec", _{activity:"Migration"}, "changes in demand on health and social services", "SOC_MIGRATION").
% MITIGATION_STORAGE: bab4 PDF p.20 (IV-20), 4.7; EX_MITIGATION_STORAGE
datum("mitigation", _{activity:"Product Storage"}, "Mimimise rainfall allowed to percolate through piles of lime stone area and runoff in uncontrolled fashion", "MITIGATION_STORAGE").
% METHOD_SOLID: bab6 PDF p.17 (VI-17), 6.2; EX_METHOD_SOLID
datum("method", _{pollutant:"Suspended solid", technique:"Non-filterable residue by drying oven"}, _{minimum_detectable:4.0, variability:5.8}, "METHOD_SOLID").
% UNIT_SOLID: bab6 PDF p.17 (VI-17), 6.2; EX_UNIT_SOLID
datum("unit", _{pollutant:"Suspended solid"}, " mg per liter", "UNIT_SOLID").
% FIXED_DATA_SOURCES: bab6 PDF p.5 (VI-5), 6.1.1; CR_DATA_SOURCES_IMPL
datum("criterion", _{criterion:"data_sources"}, _{answer:"yes", grade:"L"}, "FIXED_DATA_SOURCES").
% FIXED_MAGNITUDE: bab6 PDF p.6 (VI-6), 6.1.2; CR_MAGNITUDE_IMPL
datum("criterion", _{criterion:"magnitude"}, _{answer:"yes", grade:"L"}, "FIXED_MAGNITUDE").
% FIXED_UNCERTAINTY: bab6 PDF p.7 (VI-7), 6.1.3; CR_UNCERTAINTY_IMPL
datum("criterion", _{criterion:"uncertainty"}, _{answer:"yes"}, "FIXED_UNCERTAINTY").
% FIXED_AGGREGATION: bab6 PDF p.8 (VI-8), 6.1.3 / Table 6.7; CR_AGGREGATION_IMPL
datum("criterion", _{criterion:"aggregation"}, _{answer:"yes"}, "FIXED_AGGREGATION").
% FIXED_PUBLIC_INVOLVEMENT: bab6 PDF p.8 (VI-8), 6.1.3 / Table 6.7; CR_PUBLIC_INVOLVEMENT_IMPL
datum("criterion", _{criterion:"public_involvement"}, _{answer:"no"}, "FIXED_PUBLIC_INVOLVEMENT").
% FIXED_AFFECTED_GROUPS: bab6 PDF p.9 (VI-9), 6.1.4; CR_AFFECTED_GROUPS_IMPL
datum("criterion", _{criterion:"affected_groups"}, _{answer:"no"}, "FIXED_AFFECTED_GROUPS").
% FIXED_SUMMARY_FORMAT: bab6 PDF p.9 (VI-9), 6.1.4; CR_SUMMARY_FORMAT_IMPL
datum("criterion", _{criterion:"summary_format"}, _{answer:"yes"}, "FIXED_SUMMARY_FORMAT").
% FIXED_NEPA_CONFORMITY: bab6 PDF p.9 (VI-9), 6.1.4; CR_NEPA_CONFORMITY_IMPL
datum("criterion", _{criterion:"nepa_conformity"}, _{answer:"yes"}, "FIXED_NEPA_CONFORMITY").
% PAIR_YES_YES: bab6 PDF p.4 (VI-4), 6.1; WP_PAIR
datum("score_pair", _{answer_1:"yes", answer_2:"yes"}, "L", "PAIR_YES_YES").
% PAIR_YES_NO: bab6 PDF p.4 (VI-4), 6.1; WP_PAIR
datum("score_pair", _{answer_1:"yes", answer_2:"no"}, "S", "PAIR_YES_NO").
% PAIR_NO_YES: bab6 PDF p.4 (VI-4), 6.1; WP_PAIR
datum("score_pair", _{answer_1:"no", answer_2:"yes"}, "S", "PAIR_NO_YES").
% PAIR_NO_NO: bab6 PDF p.4 (VI-4), 6.1; WP_PAIR
datum("score_pair", _{answer_1:"no", answer_2:"no"}, "N", "PAIR_NO_NO").

% Documented criterion inventory; not additional decision rules.
% CR_COMPREHENSIVENESS, CR_COMPREHENSIVENESS_IMPL
criterion("comprehensiveness").
% CR_SPECIFICITY, CR_SPECIFICITY_IMPL
criterion("specificity").
% CR_IMPACT_ISOLATION, CR_IMPACT_ISOLATION_IMPL
criterion("impact_isolation").
% CR_TIME_CONSIDERATION, CR_TIME_CONSIDERATION_IMPL
criterion("time_consideration").
% CR_DATA_SOURCES, CR_DATA_SOURCES_IMPL
criterion("data_sources").
% CR_EXPLICIT_INDICATORS, CR_EXPLICIT_INDICATORS_IMPL
criterion("explicit_indicators").
% CR_MAGNITUDE, CR_MAGNITUDE_IMPL
criterion("magnitude").
% CR_OBJECTIVITY, CR_OBJECTIVITY_IMPL
criterion("objectivity").
% CR_SIGNIFICANCE, CR_SIGNIFICANCE_IMPL
criterion("significance").
% CR_EXPLICIT_CRITERIA, CR_EXPLICIT_CRITERIA_IMPL
criterion("explicit_criteria").
% CR_UNCERTAINTY, CR_UNCERTAINTY_IMPL
criterion("uncertainty").
% CR_RISK, CR_RISK_IMPL
criterion("risk").
% CR_ALTERNATIVES, CR_ALTERNATIVES_IMPL
criterion("alternatives").
% CR_AGGREGATION, CR_AGGREGATION_IMPL
criterion("aggregation").
% CR_PUBLIC_INVOLVEMENT, CR_PUBLIC_INVOLVEMENT_IMPL
criterion("public_involvement").
% CR_AFFECTED_GROUPS, CR_AFFECTED_GROUPS_IMPL
criterion("affected_groups").
% CR_ENVIRONMENTAL_SETTING, CR_ENVIRONMENTAL_SETTING_IMPL
criterion("environmental_setting").
% CR_SUMMARY_FORMAT, CR_SUMMARY_FORMAT_IMPL
criterion("summary_format").
% CR_KEY_ISSUES, CR_KEY_ISSUES_IMPL
criterion("key_issues").
% CR_NEPA_CONFORMITY, CR_NEPA_CONFORMITY_IMPL
criterion("nepa_conformity").

% ENGINEERING GLUE (GLUE_API / GLUE_ABSTAIN): finite dispatch, abstention,
% enumeration. No thresholds, interval comparisons, inferred edges or L/N mapping.
rule_id(Id) :- datum(_, _, _, Id).
domain_case(Input) :- datum(Kind, Fields, _, _), put_dict(kind, Fields, Kind, Input).
domain_case(_{kind:"criterion", criterion:C}) :- criterion(C).

evaluate(Input, Target, RuleIds) :-
    ( valid_input(Input) -> true
    ; throw(error(domain_error(oracle_input, Input), _)) ),
    get_dict(kind, Input, Kind), del_dict(kind, Input, _, Fields),
    ( datum(Kind, Fields, Value, Id) ->
        Target = _{status:"documented", value:Value}, RuleIds = [Id]
    ; Target = _{status:"undocumented"}, RuleIds = []
    ).

% GLUE_API: reject unsupported or malformed requests even when called directly.
query_shape("impact", [environment, pollutant]).
query_shape("standard", [pollutant]).
query_shape("impact_se", [activity, factor]).
query_shape("indirect_impact", [from, to]).
query_shape("soc_ec", [activity]).
query_shape("mitigation", [activity]).
query_shape("method", [pollutant, technique]).
query_shape("unit", [pollutant]).
query_shape("criterion", [criterion]).
query_shape("score_pair", [answer_1, answer_2]).
valid_input(Input) :-
    is_dict(Input), get_dict(kind, Input, Kind), string(Kind),
    query_shape(Kind, Fields),
    dict_pairs(Input, _, Pairs), pairs_keys_local(Pairs, Keys),
    sort([kind|Fields], Keys), maplist(nonempty_field(Input), Fields),
    valid_values(Kind, Input).
pairs_keys_local([], []).
pairs_keys_local([Key-_|Tail], [Key|Keys]) :- pairs_keys_local(Tail, Keys).
nonempty_field(Input, Field) :- get_dict(Field, Input, Value), string(Value), Value \== "".
valid_values("criterion", Input) :- !, criterion(Input.criterion).
valid_values("score_pair", Input) :- !,
    memberchk(Input.answer_1, ["yes", "no"]), memberchk(Input.answer_2, ["yes", "no"]).
valid_values(_, _).
