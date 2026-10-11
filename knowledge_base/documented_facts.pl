% Documented relations only; exact evidence in provenance.yaml.
:- module(documented_facts, [fact/4]).

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
% EXP_IMPACT_001: bab5 PDF p.2, 5.2 / Table 5.1 / Gasses and Particulate
fact("impact", _{pollutant:"SO2", environment:"Gasses and Particulate"}, 8.0, "EXP_IMPACT_001").
% EXP_IMPACT_002: bab5 PDF p.2, 5.2 / Table 5.1 / Gasses and Particulate
fact("impact", _{pollutant:"CO", environment:"Gasses and Particulate"}, 6.0, "EXP_IMPACT_002").
% EXP_IMPACT_003: bab5 PDF p.2, 5.2 / Table 5.1 / Gasses and Particulate
fact("impact", _{pollutant:"Particulate", environment:"Gasses and Particulate"}, 6.0, "EXP_IMPACT_003").
% EXP_IMPACT_004: bab5 PDF p.2, 5.2 / Table 5.1 / Gasses and Particulate
fact("impact", _{pollutant:"H2S", environment:"Gasses and Particulate"}, 4.0, "EXP_IMPACT_004").
% EXP_IMPACT_005: bab5 PDF p.2, 5.2 / Table 5.1 / Gasses and Particulate
fact("impact", _{pollutant:"Hydrocarbon", environment:"Gasses and Particulate"}, 2.0, "EXP_IMPACT_005").
% EXP_IMPACT_006: bab5 PDF p.3, 5.2 / Table 5.1 / Microfauna
fact("impact", _{pollutant:"SO2", environment:"Microfauna"}, 6.0, "EXP_IMPACT_006").
% EXP_IMPACT_007: bab5 PDF p.3, 5.2 / Table 5.1 / Microfauna
fact("impact", _{pollutant:"Particulate", environment:"Microfauna"}, 2.0, "EXP_IMPACT_007").
% EXP_IMPACT_008: bab5 PDF p.3, 5.2 / Table 5.1 / Microfauna
fact("impact", _{pollutant:"H2S", environment:"Microfauna"}, 1.0, "EXP_IMPACT_008").
% EXP_IMPACT_009: bab5 PDF p.3, 5.2 / Table 5.1 / Microfauna
fact("impact", _{pollutant:"Hydrocarbon", environment:"Microfauna"}, 1.0, "EXP_IMPACT_009").
% EXP_IMPACT_010: bab5 PDF p.3, 5.2 / Table 5.1 / Microfauna
fact("impact", _{pollutant:"Water Temperature", environment:"Microfauna"}, 6.0, "EXP_IMPACT_010").
% EXP_IMPACT_011: bab5 PDF p.3, 5.2 / Table 5.1 / Microfauna
fact("impact", _{pollutant:"Suspended Solid", environment:"Microfauna"}, 4.0, "EXP_IMPACT_011").
% EXP_IMPACT_012: bab5 PDF p.3, 5.2 / Table 5.1 / Aquatic Plants
fact("impact", _{pollutant:"Water Temperature", environment:"Aquatic Plants"}, 4.0, "EXP_IMPACT_012").
% EXP_IMPACT_013: bab5 PDF p.3, 5.2 / Table 5.1 / Endangered Species of Fauna
fact("impact", _{pollutant:"SO2", environment:"Endangered Species of Fauna"}, 8.0, "EXP_IMPACT_013").
% EXP_IMPACT_014: bab5 PDF p.3, 5.2 / Table 5.1 / Endangered Species of Fauna
fact("impact", _{pollutant:"Particulate", environment:"Endangered Species of Fauna"}, 4.0, "EXP_IMPACT_014").
% EXP_IMPACT_015: bab5 PDF p.3, 5.2 / Table 5.1 / Endangered Species of Fauna
fact("impact", _{pollutant:"H2S", environment:"Endangered Species of Fauna"}, 2.0, "EXP_IMPACT_015").
% EXP_IMPACT_016: bab5 PDF p.3, 5.2 / Table 5.1 / Endangered Species of Fauna
fact("impact", _{pollutant:"Hydrocarbon", environment:"Endangered Species of Fauna"}, 1.0, "EXP_IMPACT_016").
% EXP_IMPACT_017: bab5 PDF p.3, 5.2 / Table 5.1 / Endangered Species of Fauna
fact("impact", _{pollutant:"Water Temperature", environment:"Endangered Species of Fauna"}, 8.0, "EXP_IMPACT_017").
% EXP_IMPACT_018: bab5 PDF p.3, 5.2 / Table 5.1 / Endangered Species of Fauna
fact("impact", _{pollutant:"Suspended Solid", environment:"Endangered Species of Fauna"}, 6.0, "EXP_IMPACT_018").
% EXP_EMISSION_019: bab5 PDF p.6, 5.2 / Table 5.1 / SO2
fact("emission", _{process:"Energy Generation", pollutant:"SO2"}, true, "EXP_EMISSION_019").
% EXP_EMISSION_020: bab5 PDF p.6, 5.2 / Table 5.1 / SO2
fact("emission", _{process:"Trucking", pollutant:"SO2"}, true, "EXP_EMISSION_020").
% EXP_EMISSION_021: bab5 PDF p.6, 5.2 / Table 5.1 / SO2
fact("emission", _{process:"Junk Disposal", pollutant:"SO2"}, true, "EXP_EMISSION_021").
% EXP_EMISSION_022: bab5 PDF p.6, 5.2 / Table 5.1 / SO2
fact("emission", _{process:"Explosion", pollutant:"SO2"}, true, "EXP_EMISSION_022").
% EXP_EMISSION_023: bab5 PDF p.6, 5.2 / Table 5.1 / SO2
fact("emission", _{process:"Operation Failure", pollutant:"SO2"}, true, "EXP_EMISSION_023").
% EXP_EMISSION_024: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Alteration of Ground Cover", pollutant:"CO"}, true, "EXP_EMISSION_024").
% EXP_EMISSION_025: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Energy Generation", pollutant:"CO"}, true, "EXP_EMISSION_025").
% EXP_EMISSION_026: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Trucking", pollutant:"CO"}, true, "EXP_EMISSION_026").
% EXP_EMISSION_027: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Junk Disposal", pollutant:"CO"}, true, "EXP_EMISSION_027").
% EXP_EMISSION_028: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Explosion", pollutant:"CO"}, true, "EXP_EMISSION_028").
% EXP_EMISSION_029: bab5 PDF p.6, 5.2 / Table 5.1 / CO
fact("emission", _{process:"Operation Failure", pollutant:"CO"}, true, "EXP_EMISSION_029").
% EXP_EMISSION_030: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Alteration of Ground Cover", pollutant:"Particulate"}, true, "EXP_EMISSION_030").
% EXP_EMISSION_031: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Energy Generation", pollutant:"Particulate"}, true, "EXP_EMISSION_031").
% EXP_EMISSION_032: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Erosion and Terrasing", pollutant:"Particulate"}, true, "EXP_EMISSION_032").
% EXP_EMISSION_033: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Trucking", pollutant:"Particulate"}, true, "EXP_EMISSION_033").
% EXP_EMISSION_034: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Junk Disposal", pollutant:"Particulate"}, true, "EXP_EMISSION_034").
% EXP_EMISSION_035: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Explosion", pollutant:"Particulate"}, true, "EXP_EMISSION_035").
% EXP_EMISSION_036: bab5 PDF p.6, 5.2 / Table 5.1 / Particulate
fact("emission", _{process:"Operation Failure", pollutant:"Particulate"}, true, "EXP_EMISSION_036").
% EXP_EMISSION_037: bab5 PDF p.7, 5.2 / Table 5.1 / Hydrocarbon
fact("emission", _{process:"Explosion", pollutant:"Hydrocarbon"}, true, "EXP_EMISSION_037").
% EXP_EMISSION_038: bab5 PDF p.7, 5.2 / Table 5.1 / Hydrocarbon
fact("emission", _{process:"Operation Failure", pollutant:"Hydrocarbon"}, true, "EXP_EMISSION_038").
% EXP_EMISSION_039: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Alteration of Ground Cover", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_039").
% EXP_EMISSION_040: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Energy Generation", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_040").
% EXP_EMISSION_041: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Erosion and Terrasing", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_041").
% EXP_EMISSION_042: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Waste Recycling", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_042").
% EXP_EMISSION_043: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Junk Disposal", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_043").
% EXP_EMISSION_044: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Liquid Effluent Discharge", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_044").
% EXP_EMISSION_045: bab5 PDF p.7, 5.2 / Table 5.1 / Suspended Solid
fact("emission", _{process:"Operation Failure", pollutant:"Suspended Solid"}, true, "EXP_EMISSION_045").
% EXP_INDIRECT_046: bab5 PDF p.8, 5.3 / Table 5.2 / Aquatic Plants
fact("indirect", _{from:"Water Temperature", to:"Aquatic Plants"}, true, "EXP_INDIRECT_046").
% EXP_INDIRECT_047: bab5 PDF p.8, 5.3 / Table 5.2 / Archeological Sites
fact("indirect", _{from:"Gasses and Particulate", to:"Archeological Sites"}, true, "EXP_INDIRECT_047").
% EXP_INDIRECT_048: bab5 PDF p.8, 5.3 / Table 5.2 / Birds
fact("indirect", _{from:"Surface Water", to:"Birds"}, true, "EXP_INDIRECT_048").
% EXP_INDIRECT_049: bab5 PDF p.8, 5.3 / Table 5.2 / Birds
fact("indirect", _{from:"Water Quality", to:"Birds"}, true, "EXP_INDIRECT_049").
% EXP_INDIRECT_050: bab5 PDF p.8, 5.3 / Table 5.2 / Birds
fact("indirect", _{from:"Gasses and Particulate", to:"Birds"}, true, "EXP_INDIRECT_050").
% EXP_INDIRECT_051: bab5 PDF p.8, 5.3 / Table 5.2 / Birds
fact("indirect", _{from:"Microfauna", to:"Birds"}, true, "EXP_INDIRECT_051").
% EXP_INDIRECT_052: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Land Animals Reptiles", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_052").
% EXP_INDIRECT_053: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Surface Water", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_053").
% EXP_INDIRECT_054: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Water Quality", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_054").
% EXP_INDIRECT_055: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Water Temperature", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_055").
% EXP_INDIRECT_056: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Gasses and Particulate", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_056").
% EXP_INDIRECT_057: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Shrubs", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_057").
% EXP_INDIRECT_058: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Aquatic Plants", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_058").
% EXP_INDIRECT_059: bab5 PDF p.8, 5.3 / Table 5.2 / Endangered Species of Fauna
fact("indirect", _{from:"Microfauna", to:"Endangered Species of Fauna"}, true, "EXP_INDIRECT_059").
% EXP_INDIRECT_060: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Land Animals Reptiles", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_060").
% EXP_INDIRECT_061: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Surface Water", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_061").
% EXP_INDIRECT_062: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Water Quality", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_062").
% EXP_INDIRECT_063: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Water Temperature", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_063").
% EXP_INDIRECT_064: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Gasses and Particulate", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_064").
% EXP_INDIRECT_065: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Shrubs", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_065").
% EXP_INDIRECT_066: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Aquatic Plants", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_066").
% EXP_INDIRECT_067: bab5 PDF p.9, 5.3 / Table 5.2 / Endangered Species of Flora
fact("indirect", _{from:"Birds", to:"Endangered Species of Flora"}, true, "EXP_INDIRECT_067").
% EXP_INDIRECT_068: bab5 PDF p.9, 5.3 / Table 5.2 / Flora Barriers
fact("indirect", _{from:"MicroFlora", to:"Flora Barriers"}, true, "EXP_INDIRECT_068").
% EXP_INDIRECT_069: bab5 PDF p.9, 5.3 / Table 5.2 / Flora Barriers
fact("indirect", _{from:"Endangered Species of Fauna", to:"Flora Barriers"}, true, "EXP_INDIRECT_069").
% EXP_INDIRECT_070: bab5 PDF p.9, 5.3 / Table 5.2 / Health and Safety
fact("indirect", _{from:"Water Quality", to:"Health and Safety"}, true, "EXP_INDIRECT_070").
% EXP_INDIRECT_071: bab5 PDF p.9, 5.3 / Table 5.2 / Health and Safety
fact("indirect", _{from:"Gasses and Particulate", to:"Health and Safety"}, true, "EXP_INDIRECT_071").
% EXP_INDIRECT_072: bab5 PDF p.9, 5.3 / Table 5.2 / Land Animals Reptiles
fact("indirect", _{from:"Water Quality", to:"Land Animals Reptiles"}, true, "EXP_INDIRECT_072").
% EXP_INDIRECT_073: bab5 PDF p.9, 5.3 / Table 5.2 / Land Animals Reptiles
fact("indirect", _{from:"Gasses and Particulate", to:"Land Animals Reptiles"}, true, "EXP_INDIRECT_073").
% EXP_INDIRECT_074: bab5 PDF p.9, 5.3 / Table 5.2 / Land Animals Reptiles
fact("indirect", _{from:"Shrubs", to:"Land Animals Reptiles"}, true, "EXP_INDIRECT_074").
% EXP_INDIRECT_075: bab5 PDF p.9, 5.3 / Table 5.2 / Land Animals Reptiles
fact("indirect", _{from:"Endangered Species of Fauna", to:"Land Animals Reptiles"}, true, "EXP_INDIRECT_075").
% EXP_INDIRECT_076: bab5 PDF p.9, 5.3 / Table 5.2 / Land Stability
fact("indirect", _{from:"Shrubs", to:"Land Stability"}, true, "EXP_INDIRECT_076").
% EXP_INDIRECT_077: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Surface Water", to:"Microfauna"}, true, "EXP_INDIRECT_077").
% EXP_INDIRECT_078: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Water Quality", to:"Microfauna"}, true, "EXP_INDIRECT_078").
% EXP_INDIRECT_079: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Water Temperature", to:"Microfauna"}, true, "EXP_INDIRECT_079").
% EXP_INDIRECT_080: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Gasses and Particulate", to:"Microfauna"}, true, "EXP_INDIRECT_080").
% EXP_INDIRECT_081: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Shrubs", to:"Microfauna"}, true, "EXP_INDIRECT_081").
% EXP_INDIRECT_082: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Aquatic Plants", to:"Microfauna"}, true, "EXP_INDIRECT_082").
% EXP_INDIRECT_083: bab5 PDF p.9, 5.3 / Table 5.2 / Microfauna
fact("indirect", _{from:"Birds", to:"Microfauna"}, true, "EXP_INDIRECT_083").
% EXP_INDIRECT_084: bab5 PDF p.9, 5.3 / Table 5.2 / Microflora
fact("indirect", _{from:"Endangered Species of Flora", to:"Microflora"}, true, "EXP_INDIRECT_084").
% EXP_INDIRECT_085: bab5 PDF p.9, 5.3 / Table 5.2 / Microflora
fact("indirect", _{from:"Water Quality", to:"Microflora"}, true, "EXP_INDIRECT_085").
% EXP_INDIRECT_086: bab5 PDF p.9, 5.3 / Table 5.2 / Microflora
fact("indirect", _{from:"Water Temperature", to:"Microflora"}, true, "EXP_INDIRECT_086").
% EXP_INDIRECT_087: bab5 PDF p.9, 5.3 / Table 5.2 / Microflora
fact("indirect", _{from:"Gasses and Particulate", to:"Microflora"}, true, "EXP_INDIRECT_087").
% EXP_INDIRECT_088: bab5 PDF p.9, 5.3 / Table 5.2 / Microflora
fact("indirect", _{from:"Aquatic Plants", to:"Microflora"}, true, "EXP_INDIRECT_088").
% EXP_INDIRECT_089: bab5 PDF p.9, 5.3 / Table 5.2 / Picnicking
fact("indirect", _{from:"Surface Water", to:"Picnicking"}, true, "EXP_INDIRECT_089").
% EXP_INDIRECT_090: bab5 PDF p.9, 5.3 / Table 5.2 / Picnicking
fact("indirect", _{from:"Water Quality", to:"Picnicking"}, true, "EXP_INDIRECT_090").
% EXP_INDIRECT_091: bab5 PDF p.9, 5.3 / Table 5.2 / Picnicking
fact("indirect", _{from:"Gasses and Particulate", to:"Picnicking"}, true, "EXP_INDIRECT_091").
% EXP_INDIRECT_092: bab5 PDF p.9, 5.3 / Table 5.2 / Picnicking
fact("indirect", _{from:"Shrubs", to:"Picnicking"}, true, "EXP_INDIRECT_092").
% EXP_INDIRECT_093: bab5 PDF p.9, 5.3 / Table 5.2 / Rare Unique Species
fact("indirect", _{from:"Surface Water", to:"Rare Unique Species"}, true, "EXP_INDIRECT_093").
% EXP_INDIRECT_094: bab5 PDF p.9, 5.3 / Table 5.2 / Rare Unique Species
fact("indirect", _{from:"Water Quality", to:"Rare Unique Species"}, true, "EXP_INDIRECT_094").
% EXP_INDIRECT_095: bab5 PDF p.9, 5.3 / Table 5.2 / Rare Unique Species
fact("indirect", _{from:"Water Temperature", to:"Rare Unique Species"}, true, "EXP_INDIRECT_095").
% EXP_INDIRECT_096: bab5 PDF p.9, 5.3 / Table 5.2 / Rare Unique Species
fact("indirect", _{from:"Gasses and Particulate", to:"Rare Unique Species"}, true, "EXP_INDIRECT_096").
% EXP_INDIRECT_097: bab5 PDF p.9, 5.3 / Table 5.2 / Rare Unique Species
fact("indirect", _{from:"Shrubs", to:"Rare Unique Species"}, true, "EXP_INDIRECT_097").
% EXP_INDIRECT_098: bab5 PDF p.10, 5.3 / Table 5.2 / Residential
fact("indirect", _{from:"Surface Water", to:"Residential"}, true, "EXP_INDIRECT_098").
% EXP_INDIRECT_099: bab5 PDF p.10, 5.3 / Table 5.2 / Residential
fact("indirect", _{from:"Water Quality", to:"Residential"}, true, "EXP_INDIRECT_099").
% EXP_INDIRECT_100: bab5 PDF p.10, 5.3 / Table 5.2 / Residential
fact("indirect", _{from:"Gasses and Particulate", to:"Residential"}, true, "EXP_INDIRECT_100").
% EXP_INDIRECT_101: bab5 PDF p.10, 5.3 / Table 5.2 / Scenic Views and Vistas
fact("indirect", _{from:"Gasses and Particulate", to:"Scenic Views and Vistas"}, true, "EXP_INDIRECT_101").
% EXP_INDIRECT_102: bab5 PDF p.10, 5.3 / Table 5.2 / Shrubs
fact("indirect", _{from:"Surface Water", to:"Shrubs"}, true, "EXP_INDIRECT_102").
% EXP_INDIRECT_103: bab5 PDF p.10, 5.3 / Table 5.2 / Shrubs
fact("indirect", _{from:"Water Quality", to:"Shrubs"}, true, "EXP_INDIRECT_103").
% EXP_INDIRECT_104: bab5 PDF p.10, 5.3 / Table 5.2 / Shrubs
fact("indirect", _{from:"Gasses and Particulate", to:"Shrubs"}, true, "EXP_INDIRECT_104").
% EXP_INDIRECT_105: bab5 PDF p.10, 5.3 / Table 5.2 / Surface Water
fact("indirect", _{from:"Water Quality", to:"Surface Water"}, true, "EXP_INDIRECT_105").
% EXP_INDIRECT_106: bab5 PDF p.10, 5.3 / Table 5.2 / Surface Water
fact("indirect", _{from:"Gasses and Particulate", to:"Surface Water"}, true, "EXP_INDIRECT_106").
% EXP_INDIRECT_107: bab5 PDF p.10, 5.3 / Table 5.2 / Water Quality
fact("indirect", _{from:"Surface Water", to:"Water Quality"}, true, "EXP_INDIRECT_107").
% EXP_INDIRECT_108: bab5 PDF p.10, 5.3 / Table 5.2 / Water Quality
fact("indirect", _{from:"Gasses and Particulate", to:"Water Quality"}, true, "EXP_INDIRECT_108").
% EXP_INDIRECT_109: bab5 PDF p.10, 5.3 / Table 5.2 / Water Quality
fact("indirect", _{from:"Aquatic Plants", to:"Water Quality"}, true, "EXP_INDIRECT_109").
% EXP_IMPACT_SE_110: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Alteration of Ground Cover", factor:"Land Values"}, 3.0, "EXP_IMPACT_SE_110").
% EXP_IMPACT_SE_111: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Blasting and Drilling", factor:"Land Values"}, 4.0, "EXP_IMPACT_SE_111").
% EXP_IMPACT_SE_112: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Product Storage", factor:"Land Values"}, 4.0, "EXP_IMPACT_SE_112").
% EXP_IMPACT_SE_113: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Erosion and Terrasing", factor:"Land Values"}, 4.0, "EXP_IMPACT_SE_113").
% EXP_IMPACT_SE_114: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Trucking", factor:"Land Values"}, 3.0, "EXP_IMPACT_SE_114").
% EXP_IMPACT_SE_115: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Junk Disposal", factor:"Land Values"}, 4.0, "EXP_IMPACT_SE_115").
% EXP_IMPACT_SE_116: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Cooling Water Discharge", factor:"Land Values"}, 0.5, "EXP_IMPACT_SE_116").
% EXP_IMPACT_SE_117: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Liquid Effluent Discharge", factor:"Land Values"}, 4.0, "EXP_IMPACT_SE_117").
% EXP_IMPACT_SE_118: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Explosion", factor:"Land Values"}, 1.0, "EXP_IMPACT_SE_118").
% EXP_IMPACT_SE_119: bab5 PDF p.4, 5.2 / Table 5.1 / Land Values
fact("impact_se", _{activity:"Operation Failure", factor:"Land Values"}, 2.0, "EXP_IMPACT_SE_119").
% EXP_IMPACT_SE_120: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Alteration of Ground Cover", factor:"Transportation Systems"}, 4.0, "EXP_IMPACT_SE_120").
% EXP_IMPACT_SE_121: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Blasting and Drilling", factor:"Transportation Systems"}, 1.0, "EXP_IMPACT_SE_121").
% EXP_IMPACT_SE_122: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Mineral Processing", factor:"Transportation Systems"}, 6.0, "EXP_IMPACT_SE_122").
% EXP_IMPACT_SE_123: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Product Storage", factor:"Transportation Systems"}, 5.0, "EXP_IMPACT_SE_123").
% EXP_IMPACT_SE_124: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Erosion and Terrasing", factor:"Transportation Systems"}, 1.0, "EXP_IMPACT_SE_124").
% EXP_IMPACT_SE_125: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Waste Recycling", factor:"Transportation Systems"}, 2.0, "EXP_IMPACT_SE_125").
% EXP_IMPACT_SE_126: bab5 PDF p.4, 5.2 / Table 5.1 / Transportation Systems
fact("impact_se", _{activity:"Trucking", factor:"Transportation Systems"}, 4.0, "EXP_IMPACT_SE_126").
% EXP_IMPACT_SE_127: bab5 PDF p.5, 5.2 / Table 5.1 / Migration
fact("impact_se", _{activity:"Mineral Processing", factor:"Migration"}, 6.0, "EXP_IMPACT_SE_127").
% EXP_IMPACT_SE_128: bab5 PDF p.5, 5.2 / Table 5.1 / Migration
fact("impact_se", _{activity:"Trucking", factor:"Migration"}, 4.0, "EXP_IMPACT_SE_128").
% EXP_IMPACT_SE_129: bab5 PDF p.5, 5.2 / Table 5.1 / Migration
fact("impact_se", _{activity:"Liquid Effluent Discharge", factor:"Migration"}, 2.0, "EXP_IMPACT_SE_129").
% EXP_IMPACT_SE_130: bab5 PDF p.5, 5.2 / Table 5.1 / Migration
fact("impact_se", _{activity:"Operation Failure", factor:"Migration"}, 1.0, "EXP_IMPACT_SE_130").
% EXP_IMPACT_SE_131: bab5 PDF p.5, 5.2 / Table 5.1 / Economic History
fact("impact_se", _{activity:"Erosion and Terrasing", factor:"Economic History"}, 5.0, "EXP_IMPACT_SE_131").
% EXP_IMPACT_SE_132: bab5 PDF p.5, 5.2 / Table 5.1 / Economic History
fact("impact_se", _{activity:"Liquid Effluent Discharge", factor:"Economic History"}, 6.0, "EXP_IMPACT_SE_132").
% EXP_IMPACT_SE_133: bab5 PDF p.5, 5.2 / Table 5.1 / Health and Social Services
fact("impact_se", _{activity:"Blasting and Drilling", factor:"Health and Social Services"}, 2.0, "EXP_IMPACT_SE_133").
% EXP_IMPACT_SE_134: bab5 PDF p.5, 5.2 / Table 5.1 / Health and Social Services
fact("impact_se", _{activity:"Mineral Processing", factor:"Health and Social Services"}, 6.0, "EXP_IMPACT_SE_134").
% EXP_IMPACT_SE_135: bab5 PDF p.5, 5.2 / Table 5.1 / Health and Social Services
fact("impact_se", _{activity:"Product Storage", factor:"Health and Social Services"}, 0.5, "EXP_IMPACT_SE_135").
% EXP_IMPACT_SE_136: bab5 PDF p.5, 5.2 / Table 5.1 / Health and Social Services
fact("impact_se", _{activity:"Waste Recycling", factor:"Health and Social Services"}, 2.0, "EXP_IMPACT_SE_136").
% EXP_IMPACT_SE_137: bab5 PDF p.5, 5.2 / Table 5.1 / Housing Characteristics
fact("impact_se", _{activity:"Junk Disposal", factor:"Housing Characteristics"}, 1.0, "EXP_IMPACT_SE_137").
% EXP_IMPACT_SE_138: bab5 PDF p.5, 5.2 / Table 5.1 / Distinct Settlements
fact("impact_se", _{activity:"Energy Generation", factor:"Distinct Settlements"}, 2.0, "EXP_IMPACT_SE_138").
% EXP_IMPACT_SE_139: bab5 PDF p.5, 5.2 / Table 5.1 / Distinct Settlements
fact("impact_se", _{activity:"Mineral Processing", factor:"Distinct Settlements"}, 4.0, "EXP_IMPACT_SE_139").
% EXP_IMPACT_SE_140: bab5 PDF p.5, 5.2 / Table 5.1 / Distinct Settlements
fact("impact_se", _{activity:"Junk Disposal", factor:"Distinct Settlements"}, 1.0, "EXP_IMPACT_SE_140").
% EXP_IMPACT_SE_141: bab5 PDF p.6, 5.2 / Table 5.1 / Income Level
fact("impact_se", _{activity:"Energy Generation", factor:"Income Level"}, 3.0, "EXP_IMPACT_SE_141").
% EXP_IMPACT_SE_142: bab5 PDF p.6, 5.2 / Table 5.1 / Income Level
fact("impact_se", _{activity:"Mineral Processing", factor:"Income Level"}, 6.0, "EXP_IMPACT_SE_142").
% EXP_IMPACT_SE_143: bab5 PDF p.6, 5.2 / Table 5.1 / Income Level
fact("impact_se", _{activity:"Product Storage", factor:"Income Level"}, 1.0, "EXP_IMPACT_SE_143").
% EXP_IMPACT_SE_144: bab5 PDF p.6, 5.2 / Table 5.1 / Income Level
fact("impact_se", _{activity:"Erosion and Terrasing", factor:"Income Level"}, 5.0, "EXP_IMPACT_SE_144").
% EXP_IMPACT_SE_145: bab5 PDF p.6, 5.2 / Table 5.1 / Income Level
fact("impact_se", _{activity:"Junk Disposal", factor:"Income Level"}, 1.0, "EXP_IMPACT_SE_145").
% EXP_IMPACT_SE_146: bab5 PDF p.6, 5.2 / Table 5.1 / Income Level
fact("impact_se", _{activity:"Liquid Effluent Discharge", factor:"Income Level"}, 4.0, "EXP_IMPACT_SE_146").
% EXP_SOC_EC_147: bab5 PDF p.10, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "changes in demand on educational resources", "EXP_SOC_EC_147").
% EXP_SOC_EC_148: bab5 PDF p.10, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "changes in demand on transportation systems", "EXP_SOC_EC_148").
% EXP_SOC_EC_149: bab5 PDF p.10, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "disruption of cohesion in community groups", "EXP_SOC_EC_149").
% EXP_SOC_EC_150: bab5 PDF p.10, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "disruption of religious petterns and characteristics", "EXP_SOC_EC_150").
% EXP_SOC_EC_151: bab5 PDF p.10, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "increase or decrease employment patterns", "EXP_SOC_EC_151").
% EXP_SOC_EC_152: bab5 PDF p.11, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "increase or decrease income level", "EXP_SOC_EC_152").
% EXP_SOC_EC_153: bab5 PDF p.11, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "increase or decrease population growth", "EXP_SOC_EC_153").
% EXP_SOC_EC_154: bab5 PDF p.11, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "increase or decrease workforce", "EXP_SOC_EC_154").
% EXP_SOC_EC_155: bab5 PDF p.11, 5.4 / Table 5.3 / Migration
fact("soc_ec", _{activity:"Migration"}, "varies in population characteristics", "EXP_SOC_EC_155").
% EXP_MITIGATION_156: bab5 PDF p.16, 5.5 / Table 5.4 / Alteration of Ground Cover
fact("mitigation", _{activity:"Alteration of Ground Cover"}, "Provide plan for limestone mine restoration. Plan for limestone resources usage to fit availability and imposed restrictions on manner of quarrying.", "EXP_MITIGATION_156").
% EXP_MITIGATION_157: bab5 PDF p.17, 5.5 / Table 5.4 / Energy Generation
fact("mitigation", _{activity:"Energy Generation"}, "Control by scubbing action of alkaline materials and enhenced by utilization of preheated kilns, and use of exhaust gases to dry raw materials in grinding.", "EXP_MITIGATION_157").
% EXP_MITIGATION_158: bab5 PDF p.17, 5.5 / Table 5.4 / Erosion and Terrasing
fact("mitigation", _{activity:"Erosion and Terrasing"}, "covering or containment to prevent percolation and runoff to ground and surface water.", "EXP_MITIGATION_158").
% EXP_MITIGATION_159: bab5 PDF p.17, 5.5 / Table 5.4 / Explosion
fact("mitigation", _{activity:"Explosion"}, "Protect surface water from additional suspended solid.", "EXP_MITIGATION_159").
% EXP_MITIGATION_160: bab5 PDF p.17, 5.5 / Table 5.4 / Junk Disposal
fact("mitigation", _{activity:"Junk Disposal"}, "Move to a proper site.", "EXP_MITIGATION_160").
% EXP_MITIGATION_161: bab5 PDF p.17, 5.5 / Table 5.4 / Liquid Effluent Discharge
fact("mitigation", _{activity:"Liquid Effluent Discharge"}, "Total Suspended Solid < 150 g/ton product during equipment cleaning operations or during periods of rainfall.", "EXP_MITIGATION_161").
% EXP_MITIGATION_162: bab5 PDF p.17, 5.5 / Table 5.4 / Operation Failure
fact("mitigation", _{activity:"Operation Failure"}, "Design precipitator with paralel chambers, enforce kiln shut down when precipitator is completely out of order.", "EXP_MITIGATION_162").
% STANDARD_SO2: bab4 PDF p.8, 4.4.1
fact("standard", _{pollutant:"SO2"}, _{lower:0, upper:40.0, magnitude:2.0}, "STANDARD_SO2").
% METHOD_SOLID: bab6 PDF p.17, 6.2
fact("method", _{pollutant:"Suspended solid", technique:"Non-filterable residue by drying oven"}, _{minimum_detectable:4.0, variability:5.8}, "METHOD_SOLID").
% UNIT_SOLID: bab6 PDF p.17, 6.2
fact("unit", _{pollutant:"Suspended solid"}, " mg per liter", "UNIT_SOLID").
% FIXED_DATA_SOURCES: bab6 PDF p.5, 6.1.1
fact("criterion", _{criterion:"data_sources"}, _{answer:"yes", grade:"L"}, "FIXED_DATA_SOURCES").
% FIXED_MAGNITUDE: bab6 PDF p.6, 6.1.2
fact("criterion", _{criterion:"magnitude"}, _{answer:"yes", grade:"L"}, "FIXED_MAGNITUDE").
% FIXED_UNCERTAINTY: bab6 PDF p.7, 6.1.3
fact("criterion", _{criterion:"uncertainty"}, _{answer:"yes"}, "FIXED_UNCERTAINTY").
% FIXED_AGGREGATION: bab6 PDF p.8, 6.1.3 / Table 6.7
fact("criterion", _{criterion:"aggregation"}, _{answer:"yes"}, "FIXED_AGGREGATION").
% FIXED_PUBLIC_INVOLVEMENT: bab6 PDF p.8, 6.1.3 / Table 6.7
fact("criterion", _{criterion:"public_involvement"}, _{answer:"no"}, "FIXED_PUBLIC_INVOLVEMENT").
% FIXED_AFFECTED_GROUPS: bab6 PDF p.9, 6.1.4
fact("criterion", _{criterion:"affected_groups"}, _{answer:"no"}, "FIXED_AFFECTED_GROUPS").
% FIXED_SUMMARY_FORMAT: bab6 PDF p.9, 6.1.4
fact("criterion", _{criterion:"summary_format"}, _{answer:"yes"}, "FIXED_SUMMARY_FORMAT").
% FIXED_NEPA_CONFORMITY: bab6 PDF p.9, 6.1.4
fact("criterion", _{criterion:"nepa_conformity"}, _{answer:"yes"}, "FIXED_NEPA_CONFORMITY").
% EXP_STANDARD_163: bab4 PDF p.7, 4.4.1 / Figure 4.3
fact("standard", _{pollutant:"H2S", lower:0.0, upper:10.5}, 2.0, "EXP_STANDARD_163").
% EXP_STANDARD_164: bab4 PDF p.7, 4.4.1 / Figure 4.3
fact("standard", _{pollutant:"H2S", lower:10.5, upper:21.0}, 4.0, "EXP_STANDARD_164").
% EXP_STANDARD_165: bab4 PDF p.7, 4.4.1 / Figure 4.3
fact("standard", _{pollutant:"H2S", lower:21.0, upper:42.0}, 7.0, "EXP_STANDARD_165").
% EXP_STANDARD_166: bab4 PDF p.7, 4.4.1 / Figure 4.3
fact("standard", _{pollutant:"H2S", lower:42.0, upper:1000.0}, 10.0, "EXP_STANDARD_166").
