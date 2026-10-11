% Current ambient reference profile; source: EPA NAAQS Table, updated 2025-11-04.
% Retrieved 2026-10-11. Evidence and exact forms: docs/evidence/current-standards-*.json.
% Numeric levels/forms are documented. Supplied-summary screening is A_AMBIENT_SCREEN.
:- module(current_standards, [standard/2, screen/3, valid_screen/1]).
:- use_module(library(lists)).
:- use_module(library(pairs)).

% CURRENT_NAAQS_01: CO primary; Not to be exceeded more than once per year.
standard(_{standard:"co_8h_primary",pollutant:"CO",protection:"primary",averaging_time:"8h",level:9.0,level_unit:"ppm",statistic:"annual_exceedances",comparison_limit:1.0,comparison_unit:"count_per_year",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_01").
% CURRENT_NAAQS_02: CO primary; Not to be exceeded more than once per year.
standard(_{standard:"co_1h_primary",pollutant:"CO",protection:"primary",averaging_time:"1h",level:35.0,level_unit:"ppm",statistic:"annual_exceedances",comparison_limit:1.0,comparison_unit:"count_per_year",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_02").
% CURRENT_NAAQS_03: Pb primary_secondary; maximum arithmetic mean of 3 consecutive monthly means in a 3-year period.
standard(_{standard:"pb_3month",pollutant:"Pb",protection:"primary_secondary",averaging_time:"rolling_3month",level:0.15,level_unit:"ug/m3",statistic:"max_rolling_3month_mean_3y",comparison_limit:0.15,comparison_unit:"ug/m3",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_03").
% CURRENT_NAAQS_04: NO2 primary; Annual 98th percentile of 1-hour daily maximum concentrations, averaged over 3 years.
standard(_{standard:"no2_1h_primary",pollutant:"NO2",protection:"primary",averaging_time:"1h",level:100.0,level_unit:"ppb",statistic:"daily_max_1h_p98_3y",comparison_limit:100.0,comparison_unit:"ppb",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_04").
% CURRENT_NAAQS_05: NO2 primary_secondary; Annual Mean.
standard(_{standard:"no2_annual",pollutant:"NO2",protection:"primary_secondary",averaging_time:"1y",level:53.0,level_unit:"ppb",statistic:"annual_mean",comparison_limit:53.0,comparison_unit:"ppb",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_05").
% CURRENT_NAAQS_06: O3 primary_secondary; Annual fourth-highest daily maximum 8-hour concentration, averaged over 3 years.
standard(_{standard:"o3_8h",pollutant:"O3",protection:"primary_secondary",averaging_time:"8h",level:0.07,level_unit:"ppm",statistic:"daily_max_8h_fourth_highest_3y",comparison_limit:0.07,comparison_unit:"ppm",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_06").
% CURRENT_NAAQS_07: PM2.5 primary; annual mean, averaged over 3 years.
standard(_{standard:"pm25_annual_primary",pollutant:"PM2.5",protection:"primary",averaging_time:"1y",level:9.0,level_unit:"ug/m3",statistic:"annual_mean_3y",comparison_limit:9.0,comparison_unit:"ug/m3",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_07").
% CURRENT_NAAQS_08: PM2.5 secondary; annual mean, averaged over 3 years.
standard(_{standard:"pm25_annual_secondary",pollutant:"PM2.5",protection:"secondary",averaging_time:"1y",level:15.0,level_unit:"ug/m3",statistic:"annual_mean_3y",comparison_limit:15.0,comparison_unit:"ug/m3",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_08").
% CURRENT_NAAQS_09: PM2.5 primary_secondary; 98th percentile, averaged over 3 years.
standard(_{standard:"pm25_24h",pollutant:"PM2.5",protection:"primary_secondary",averaging_time:"24h",level:35.0,level_unit:"ug/m3",statistic:"daily_mean_24h_p98_3y",comparison_limit:35.0,comparison_unit:"ug/m3",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_09").
% CURRENT_NAAQS_10: PM10 primary_secondary; Not to be exceeded more than once per year on average over 3 years.
standard(_{standard:"pm10_24h",pollutant:"PM10",protection:"primary_secondary",averaging_time:"24h",level:150.0,level_unit:"ug/m3",statistic:"mean_annual_exceedances_3y",comparison_limit:1.0,comparison_unit:"count_per_year",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_10").
% CURRENT_NAAQS_11: SO2 primary; Annual 99th percentile of 1-hour daily maximum concentrations, averaged over 3 years.
standard(_{standard:"so2_1h_primary",pollutant:"SO2",protection:"primary",averaging_time:"1h",level:75.0,level_unit:"ppb",statistic:"daily_max_1h_p99_3y",comparison_limit:75.0,comparison_unit:"ppb",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_11").
% CURRENT_NAAQS_12: SO2 secondary; annual mean, averaged over 3 years.
standard(_{standard:"so2_annual_secondary",pollutant:"SO2",protection:"secondary",averaging_time:"1y",level:10.0,level_unit:"ppb",statistic:"annual_mean_3y",comparison_limit:10.0,comparison_unit:"ppb",profile:"us_epa_naaqs_2025"}, "CURRENT_NAAQS_12").

% A_AMBIENT_SCREEN: enforce a uniform supplied-summary contract, not raw samples.
valid_screen(Input) :-
    is_dict(Input), dict_pairs(Input,_,Pairs),
    pairs_keys(Pairs,[kind,profile,sampling_context,standard,summary]),
    Input.kind == "screen_ambient",
    forall(member(Key,[profile,sampling_context,standard]),
           (get_dict(Key,Input,V),string(V),V\=="")),
    is_dict(Input.summary),dict_pairs(Input.summary,_,Summary),
    pairs_keys(Summary,[data_status,reference_level,reference_unit,statistic,unit,value]),
    forall(member(Key,[data_status,reference_unit,statistic,unit]),
           (get_dict(Key,Input.summary,V),string(V),V\=="")),
    forall(member(Key,[reference_level,value]),
           (get_dict(Key,Input.summary,V),number(V),V>=0,V<1.0e12)).

screen(Input, Target, Ids) :-
    ( standard(S, Id), S.profile == Input.profile, S.standard == Input.standard ->
        screen_known(Input,S,Result,ExtraIds),
        put_dict(_{profile:S.profile,standard:S.standard,pollutant:S.pollutant,
                   protection:S.protection,averaging_time:S.averaging_time,
                   reference_level:S.level,reference_unit:S.level_unit,
                   expected_statistic:S.statistic}, Result,Target),
        sort([Id,"R_AMBIENT_SCREEN"|ExtraIds],Ids)
    ; Target=_{decision:"insufficient_data",reason:"unknown_profile_or_standard"},
      Ids=["R_AMBIENT_SCREEN","R_AMBIENT_GAPS"] ).

screen_known(Input,S,Target,Ids) :-
    ( mismatch(Input,S,Reason) ->
        Target=_{decision:"insufficient_data",reason:Reason},Ids=["R_AMBIENT_GAPS"]
    ; convert(Input.summary.value,Input.summary.unit,S.comparison_unit,Value),
      ( Value =< S.comparison_limit -> Decision="within_reference"; Decision="exceeds_reference" ),
      Target=_{decision:Decision,scope:"supplied_summary_screen",
               normalized_value:Value,comparison_unit:S.comparison_unit,
               comparison_limit:S.comparison_limit},
      Ids=["R_AMBIENT_UNITS"] ).

% Each failed semantic guard abstains. A well-formed unknown unit is not guessed.
mismatch(Input,_,"requires_ambient_air_context") :- Input.sampling_context \== "ambient_air", !.
mismatch(Input,_,"incomplete_or_unverified_summary") :- Input.summary.data_status \== "complete", !.
mismatch(Input,S,"statistical_form_mismatch") :- Input.summary.statistic \== S.statistic, !.
mismatch(Input,S,"unsupported_reference_unit") :-
    \+ convert(Input.summary.reference_level,Input.summary.reference_unit,S.level_unit,_), !.
mismatch(Input,S,"reference_threshold_mismatch") :-
    convert(Input.summary.reference_level,Input.summary.reference_unit,S.level_unit,Reference),
    Tolerance is max(1.0e-9,abs(S.level)*1.0e-12), abs(Reference-S.level)>Tolerance, !.
mismatch(Input,S,"unsupported_summary_unit") :-
    \+ convert(Input.summary.value,Input.summary.unit,S.comparison_unit,_), !.
mismatch(Input,S,"annual_count_must_be_integer") :-
    S.statistic == "annual_exceedances", Input.summary.value =\= round(Input.summary.value), !.

% A_AMBIENT_UNITS: compatible units only. No unspecified physical assumptions.
convert(Value,Unit,Unit,Converted) :-
    memberchk(Unit,["ppm","ppb","ug/m3","mg/m3","count_per_year"]), !,
    Converted is float(Value).
convert(Value,"ppm","ppb",Converted) :- Converted is float(Value*1000).
convert(Value,"ppb","ppm",Converted) :- Converted is float(Value/1000).
convert(Value,"mg/m3","ug/m3",Converted) :- Converted is float(Value*1000).
convert(Value,"ug/m3","mg/m3",Converted) :- Converted is float(Value/1000).
