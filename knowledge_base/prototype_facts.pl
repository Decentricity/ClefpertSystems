% Documented relations only. See provenance.yaml for chapter/page audit.
% This file is executed by esc1.pl, never converted directly into training records.
:- module(prototype_facts, [fact/4]).

% IMPACT_01: bab5 PDF p.2, 5.2 / Table 5.1 / row 3
fact("impact", _{pollutant:"Water Temperature", environment:"Surface Water"}, 8.0, "IMPACT_01").
% IMPACT_02: bab5 PDF p.2, 5.2 / Table 5.1 / row 3
fact("impact", _{pollutant:"Suspended Solid", environment:"Surface Water"}, 8.0, "IMPACT_02").
% IMPACT_03: bab5 PDF p.2, 5.2 / Table 5.1 / row 4
fact("impact", _{pollutant:"SO2", environment:"Shrubs"}, 4.0, "IMPACT_03").
% IMPACT_04: bab5 PDF p.2, 5.2 / Table 5.1 / row 4
fact("impact", _{pollutant:"Particulate", environment:"Shrubs"}, 2.0, "IMPACT_04").
% IMPACT_05: bab5 PDF p.2, 5.2 / Table 5.1 / row 4
fact("impact", _{pollutant:"H2S", environment:"Shrubs"}, 1.0, "IMPACT_05").
% IMPACT_06: bab5 PDF p.2, 5.2 / Table 5.1 / row 5
fact("impact", _{pollutant:"SO2", environment:"Microflora"}, 6.0, "IMPACT_06").
% IMPACT_07: bab5 PDF p.2, 5.2 / Table 5.1 / row 5
fact("impact", _{pollutant:"Particulate", environment:"Microflora"}, 2.0, "IMPACT_07").
% IMPACT_08: bab5 PDF p.2, 5.2 / Table 5.1 / row 5
fact("impact", _{pollutant:"H2S", environment:"Microflora"}, 4.0, "IMPACT_08").
% IMPACT_09: bab5 PDF p.2, 5.2 / Table 5.1 / row 5
fact("impact", _{pollutant:"Water Temperature", environment:"Microflora"}, 4.0, "IMPACT_09").
% IMPACT_10: bab5 PDF p.2, 5.2 / Table 5.1 / row 5
fact("impact", _{pollutant:"Suspended Solid", environment:"Microflora"}, 2.0, "IMPACT_10").
% IMPACT_11: bab5 PDF p.2, 5.2 / Table 5.1 / row 6
fact("impact", _{pollutant:"SO2", environment:"Endangered Species of Flora"}, 8.0, "IMPACT_11").
% IMPACT_12: bab5 PDF p.2, 5.2 / Table 5.1 / row 6
fact("impact", _{pollutant:"CO", environment:"Endangered Species of Flora"}, 6.0, "IMPACT_12").
% IMPACT_13: bab5 PDF p.2, 5.2 / Table 5.1 / row 6
fact("impact", _{pollutant:"Particulate", environment:"Endangered Species of Flora"}, 4.0, "IMPACT_13").
% IMPACT_14: bab5 PDF p.2, 5.2 / Table 5.1 / row 6
fact("impact", _{pollutant:"H2S", environment:"Endangered Species of Flora"}, 1.0, "IMPACT_14").
% IMPACT_15: bab5 PDF p.2, 5.2 / Table 5.1 / row 6
fact("impact", _{pollutant:"Water Temperature", environment:"Endangered Species of Flora"}, 8.0, "IMPACT_15").
% IMPACT_16: bab5 PDF p.2, 5.2 / Table 5.1 / row 6
fact("impact", _{pollutant:"Suspended Solid", environment:"Endangered Species of Flora"}, 2.0, "IMPACT_16").
% IMPACT_17: bab5 PDF p.2, 5.2 / Table 5.1 / unnumbered Birds row
fact("impact", _{pollutant:"SO2", environment:"Birds"}, 4.0, "IMPACT_17").
% IMPACT_18: bab5 PDF p.2, 5.2 / Table 5.1 / unnumbered Birds row
fact("impact", _{pollutant:"CO", environment:"Birds"}, 2.0, "IMPACT_18").
% IMPACT_19: bab5 PDF p.3, 5.2 / Table 5.1 / continuation of Birds row
fact("impact", _{pollutant:"Particulate", environment:"Birds"}, 2.0, "IMPACT_19").
% IMPACT_20: bab5 PDF p.3, 5.2 / Table 5.1 / continuation of Birds row
fact("impact", _{pollutant:"H2S", environment:"Birds"}, 1.0, "IMPACT_20").
% IMPACT_21: bab5 PDF p.3, 5.2 / Table 5.1 / row 7
fact("impact", _{pollutant:"SO2", environment:"Land Animals Reptiles"}, 1.0, "IMPACT_21").
% IMPACT_22: bab5 PDF p.3, 5.2 / Table 5.1 / row 7
fact("impact", _{pollutant:"Particulate", environment:"Land Animals Reptiles"}, 2.0, "IMPACT_22").
% IMPACT_23: bab5 PDF p.3, 5.2 / Table 5.1 / row 7
fact("impact", _{pollutant:"H2S", environment:"Land Animals Reptiles"}, 1.0, "IMPACT_23").
% IMPACT_24: bab5 PDF p.3, 5.2 / Table 5.1 / row 7
fact("impact", _{pollutant:"Water Temperature", environment:"Land Animals Reptiles"}, 1.0, "IMPACT_24").
% SOCIAL_BLASTING: bab4 PDF p.13, 4.4.2.2
fact("impact_se", _{activity:"Blasting and Drilling", factor:"Migration"}, 1.0, "SOCIAL_BLASTING").
% SOC_MIGRATION: bab4 PDF p.18, 4.6
fact("soc_ec", _{activity:"Migration"}, "changes in demand on health and social services", "SOC_MIGRATION").
% MITIGATION_STORAGE: bab4 PDF p.20, 4.7
fact("mitigation", _{activity:"Product Storage"}, "Mimimise rainfall allowed to percolate through piles of lime stone area and runoff in uncontrolled fashion", "MITIGATION_STORAGE").
% FACT_EMISSION_01: bab5 PDF p.6, 5.2 / Table 5.1 / SO2
fact("emission", _{process:"Mineral Processing", pollutant:"SO2"}, true, "FACT_EMISSION_01").
% FACT_EMISSION_02: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Mineral Processing", pollutant:"CO"}, true, "FACT_EMISSION_02").
% FACT_EMISSION_03: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Mineral Processing", pollutant:"Particulate"}, true, "FACT_EMISSION_03").
% FACT_EMISSION_04: bab5 PDF p.6, 5.2 / Table 5.1 / H2S
fact("emission", _{process:"Mineral Processing", pollutant:"H2S"}, true, "FACT_EMISSION_04").
% FACT_EMISSION_05: bab5 PDF p.7, 5.2 / Table 5.1 / Hydrocarbon
fact("emission", _{process:"Mineral Processing", pollutant:"Hydrocarbon"}, true, "FACT_EMISSION_05").
% FACT_EMISSION_06: bab5 PDF p.7, 5.2 / Table 5.1 / Water Temperature
fact("emission", _{process:"Mineral Processing", pollutant:"Water Temperature"}, true, "FACT_EMISSION_06").
% FACT_EMISSION_07: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Mineral Processing", pollutant:"Suspended Solid"}, true, "FACT_EMISSION_07").
% FACT_EMISSION_08: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Product Storage", pollutant:"Particulate"}, true, "FACT_EMISSION_08").
% FACT_EMISSION_09: bab5 PDF p.7, 5.2 / Table 5.1 / Hydrocarbon
fact("emission", _{process:"Product Storage", pollutant:"Hydrocarbon"}, true, "FACT_EMISSION_09").
% FACT_EMISSION_10: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Product Storage", pollutant:"Suspended Solid"}, true, "FACT_EMISSION_10").
% FACT_EMISSION_11: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Blasting and Drilling", pollutant:"Particulate"}, true, "FACT_EMISSION_11").
% FACT_EMISSION_12: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Blasting and Drilling", pollutant:"Suspended Solid"}, true, "FACT_EMISSION_12").
% FACT_EMISSION_13: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Cooling Water Discharge", pollutant:"Suspended Solid"}, true, "FACT_EMISSION_13").
% FACT_INDIRECT_14: bab5 PDF p.8, 5.3 / Table 5.2 / row 1
fact("indirect", _{from:"Surface Water", to:"Aquatic Plants"}, true, "FACT_INDIRECT_14").
% FACT_INDIRECT_15: bab5 PDF p.8, 5.3 / Table 5.2 / row 3
fact("indirect", _{from:"Aquatic Plants", to:"Birds"}, true, "FACT_INDIRECT_15").
% FACT_INDIRECT_16: bab5 PDF p.9, 5.3 / Table 5.2 / row 6
fact("indirect", _{from:"Shrubs", to:"Erosion"}, true, "FACT_INDIRECT_16").
% FACT_MITIGATION_17: bab5 PDF p.17, 5.5 / Table 5.4 / Mineral Processing
fact("mitigation", _{activity:"Mineral Processing"}, "Control particulate by fabric filter collectors, control kiln particulate emissions by electric precipitator dust collectors.", "FACT_MITIGATION_17").
% FACT_MITIGATION_18: bab5 PDF p.17, 5.5 / Table 5.4 / Blasting and Drilling
fact("mitigation", _{activity:"Blasting and Drilling"}, "Special transportation sector studies should be prepared during project feasibility to select best routes to reduced impacts .", "FACT_MITIGATION_18").
% FACT_MITIGATION_19: bab5 PDF p.17, 5.5 / Table 5.4 / Cooling Water Discharge
fact("mitigation", _{activity:"Cooling Water Discharge"}, "If recycling is not feasible, discharge cooling water provided receiving water temperature does not rise 3 degree Celcious.", "FACT_MITIGATION_19").
