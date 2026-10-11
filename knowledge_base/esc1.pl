% Runnable reconstructed expert system, not the lost original ESC source.
% Documented facts: documented_facts.pl. POC assumptions: provenance.yaml A_*.
:- module(esc1, [evaluate/3, domain/1, rule_id/1, demo/0]).
:- use_module(documented_facts).
:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(pairs)).
:- use_module(library(http/json)).

rule_id(Id) :- fact(_, _, _, Id).
rule_id(Id) :- member(Id, ["R_FORWARD", "R_DIRECT", "R_INDIRECT", "R_SOCIAL",
                           "R_MITIGATION", "R_PRIORITY", "R_GAPS", "R_ASSESS",
                           "R_STANDARD", "R_INSTRUMENT", "R_BACKWARD", "R_WP"]).

% Domain introspection lets a generator enumerate inputs without reading the paper.
domain(_{processes:Processes, pollutants:Pollutants, receptors:Receptors,
         process_pollutant_pairs:Pairs, direct_pairs:Direct, indirect_pairs:Indirect,
         magnitude_range:[0,10], standards:Standards, instruments:Instruments,
         wp_fields:WPFields, query_kinds:["assess","assess_concentration","trace_back","instrumentation","method_assessment"],
         profile:"cement_poc_v2"}) :-
    findall(P, fact("emission", _{process:P,pollutant:_}, _, _), Ps), sort(Ps, Processes),
    findall(P, fact("emission", _{process:_,pollutant:P}, _, _), Pols), sort(Pols, Pollutants),
    findall(E, (fact("impact", _{pollutant:_,environment:E}, _, _);
                fact("indirect", _{from:_,to:E}, _, _)), Es), sort(Es, Receptors),
    findall(Fields, fact("emission", Fields, _, _), Pairs),
    findall(Fields, fact("impact", Fields, _, _), Direct),
    findall(Fields, fact("indirect", Fields, _, _), Indirect),
    findall(_{pollutant:P,lower:Lo,upper:Hi,magnitude:M}, standard_range(P,Lo,Hi,M,_), Standards),
    findall(_{pollutant:P,technique:T},
            (fact("method",F,_,_),P=F.pollutant,T=F.technique), Instruments),
    findall(Field, wp_field(Field), WPFields).

% Executable workflows. No output is generated from document prose.
evaluate(Input, Target, RuleIds) :-
    Input.kind == "assess_concentration", !,
    require_valid(Input),
    ( concentration_magnitude(Input.pollutant, Input.concentration, Magnitude, StandardId) ->
        del_dict(concentration, Input, _, Base),
        put_dict(_{kind:"assess",magnitude:Magnitude}, Base, Case),
        evaluate(Case, Decision, Ids),
        put_dict(_{concentration:Input.concentration,source_units:"unspecified",resolved_magnitude:Magnitude}, Decision, Target),
        sort([StandardId,"R_STANDARD"|Ids], RuleIds)
    ; Target=_{decision:"insufficient_data",reason:"concentration_outside_documented_ranges"},
      RuleIds=["R_STANDARD"] ).
evaluate(Input, Target, RuleIds) :-
    Input.kind == "trace_back", !, require_valid(Input), backward(Input.receptor, Target, RuleIds).
evaluate(Input, Target, RuleIds) :-
    Input.kind == "instrumentation", !, require_valid(Input), instrument(Input, Target, RuleIds).
evaluate(Input, Target, RuleIds) :-
    Input.kind == "method_assessment", !, require_valid(Input), warner_preston(Input, Target, RuleIds).

% A_CASE_SCOPE: selected process -> selected pollutant -> present receptors.
evaluate(Input, Target, RuleIds) :-
    (valid_input(Input), Input.kind == "assess" -> true; throw(error(domain_error(oracle_input, Input), _))),
    findall(_{process:P,pollutant:Input.pollutant}-Id,
            (member(P, Input.processes), fact("emission", _{process:P,pollutant:Input.pollutant}, _, Id)), Sources0),
    pairs(Sources0, Sources, SourceIds),
    findall(D-Id, direct(Input, D, Id), Direct0), pairs(Direct0, Direct, DirectIds),
    findall(I-Ids, indirect(Input, Direct, I, Ids), Indirect0),
    pairs(Indirect0, Indirect, EdgeLists), append(EdgeLists, EdgeIds),
    findall(S-Ids, social(Input, S, Ids), Social0),
    pairs(Social0, Social, SocialLists), append(SocialLists, SocialIds),
    findall(F,(member(S,Social),S.consequences==[],F=S.factor),UnknownSocial0),sort(UnknownSocial0,UnknownSocial),
    findall(M-Id, mitigation(Input, M, Id), Mitigation0), pairs(Mitigation0, Mitigations, MitigationIds),
    findall(E, (member(E, Input.receptors), \+ covered_receptor(E, Direct, Indirect)), Gaps),
    findall(Score, (member(D, Direct), Score=D.score), Scores), max_list([0.0|Scores], Max),
    priority(Max, Priority), (Gaps=[] -> Decision=Priority; Decision="insufficient_data"),
    Target=_{decision:Decision, priority:Priority, maximum_score:Max,
             sources:Sources, direct_impacts:Direct, indirect_impacts:Indirect,
             social_impacts:Social, unresolved_social_factors:UnknownSocial,
             mitigations:Mitigations, unresolved_receptors:Gaps},
    branch_ids(Direct, Indirect, Social, Mitigations, Gaps, BranchIds),
    append([SourceIds, DirectIds, EdgeIds, SocialIds, MitigationIds,
            ["R_ASSESS","R_FORWARD","R_PRIORITY"], BranchIds], AllIds), sort(AllIds, RuleIds).

% A_MAGNITUDE_INPUT / A_SCORE_PRODUCT: scored direct effects include score zero.
% Zero-valued effects preserve supported paths but never trigger indirect effects.
direct(Input, _{pollutant:Input.pollutant,receptor:E,importance:Importance,
                magnitude:Input.magnitude,score:Score}, Id) :-
    member(E, Input.receptors),
    fact("impact", _{pollutant:Input.pollutant,environment:E}, Importance, Id),
    Score is float(Importance * Input.magnitude).

% A_INDIRECT_CHAIN: retain actual paths, bounded to two hops; no inferred weights.
indirect(Input, Direct, _{receptor:End,path:Path}, Ids) :-
    member(D, Direct), D.score > 0, Root=D.receptor,
    indirect_path(Root, End, [Root], Path, Ids, 2), member(End, Input.receptors).
indirect_path(Start, End, Visited, Path, [Id], _) :-
    fact("indirect", _{from:Start,to:End}, _, Id), \+ memberchk(End, Visited),
    reverse([End|Visited], Path).
indirect_path(Start, End, Visited, Path, [Id|Ids], Remaining) :-
    Remaining > 1, fact("indirect", _{from:Start,to:Next}, _, Id),
    \+ memberchk(Next, Visited), NextRemaining is Remaining-1,
    indirect_path(Next, End, [Next|Visited], Path, Ids, NextRemaining).

% A_SOCIAL_CONTEXT: activity-driven effects are contextual, not pollutant scores.
social(Input, _{process:P,factor:Factor,importance:Importance,consequences:Consequences}, Ids) :-
    member(P, Input.processes),
    fact("impact_se", _{activity:P,factor:Factor}, Importance, ImpactId),
    findall(Text-Id, fact("soc_ec", _{activity:Factor}, Text, Id), Changes),
    pairs(Changes, Consequences, ChangeIds), Ids=[ImpactId|ChangeIds].

% A_CASE_SCOPE: return documented process recommendations for detected exposure.
mitigation(Input, _{process:P,action:Text}, Id) :-
    Input.magnitude > 0, member(P, Input.processes),
    fact("mitigation", _{activity:P}, Text, Id).

% A_PRIORITY_BANDS: these categories/cutoffs are POC choices, not thesis rules.
priority(Score, "no_detected_impact") :- Score =:= 0, !.
priority(Score, "monitor") :- Score < 10, !.
priority(Score, "mitigate") :- Score < 40, !.
priority(_, "urgent_review").

covered_receptor(E, Direct, _) :- member(D, Direct), D.receptor == E, !.
covered_receptor(E, _, Indirect) :- member(I, Indirect), I.receptor == E, !.
covered_receptor(E, Direct, _) :-
    member(D, Direct), Root=D.receptor, indirect_path(Root, E, [Root], _, _, 2).
branch_ids(Direct, Indirect, Social, Mitigations, Gaps, Ids) :-
    findall(Id, ((Direct\=[] , Id="R_DIRECT"); (Indirect\=[], Id="R_INDIRECT");
                 (Social\=[], Id="R_SOCIAL"); (Mitigations\=[], Id="R_MITIGATION");
                 (Gaps\=[], Id="R_GAPS")), Ids).
pairs(Pairs, Values, Ids) :-
    findall(Value, member(Value-_, Pairs), Raw), sort(Raw, Values),
    findall(Id, member(_-Id, Pairs), Ids).

% Engineering input contract, separate from the historical menu implementation.
require_valid(Input) :-
    (valid_input(Input) -> true; throw(error(domain_error(oracle_input,Input),_))).
valid_input(Input) :-
    is_dict(Input), get_dict(kind,Input,Kind),
    request_keys(Kind, Expected), dict_pairs(Input,_,Fields), pairs_keys(Fields,Expected),
    valid_request(Kind,Input).
request_keys("assess", [kind,magnitude,pollutant,processes,receptors]).
request_keys("assess_concentration", [concentration,kind,pollutant,processes,receptors]).
request_keys("trace_back", [kind,receptor]).
request_keys("instrumentation", [kind,observed_value,pollutant,technique]).
request_keys("method_assessment", [answers,counts,kind]).
valid_request("assess",Input) :-
    number(Input.magnitude), Input.magnitude>=0, Input.magnitude=<10, valid_scope(Input).
valid_request("assess_concentration",Input) :-
    number(Input.concentration), Input.concentration>=0, Input.concentration<1.0e12, valid_scope(Input).
valid_request("trace_back",Input) :- domain(D), string(Input.receptor), memberchk(Input.receptor,D.receptors).
valid_request("instrumentation",Input) :-
    string(Input.pollutant), string(Input.technique), Input.pollutant\=="", Input.technique\=="",
    number(Input.observed_value), Input.observed_value>=0, Input.observed_value<1.0e12.
valid_request("method_assessment",Input) :-
    is_dict(Input.counts), dict_pairs(Input.counts,_,Pairs), pairs_keys(Pairs,Keys),
    findall(Field,wp_field(Field),Fields), sort(Fields,Keys),
    forall(member(_-Count,Pairs),(integer(Count),Count>=0,Count=<1000000)),
    Input.counts.staged_activities =< Input.counts.activities,
    Input.counts.objective_measurements =< Input.counts.measurements,
    is_dict(Input.answers), dict_pairs(Input.answers,_,Ans),
    pairs_keys(Ans,[explicit_indicators,impact_isolation,significance]),
    forall(member(_-A,Ans),memberchk(A,["yes","no"])).
valid_scope(Input) :-
    domain(Domain), string(Input.pollutant),
    valid_names(Input.processes,Domain.processes),valid_names(Input.receptors,Domain.receptors),
    forall(member(P, Input.processes), fact("emission", _{process:P,pollutant:Input.pollutant}, _, _)).

valid_names(Names, Allowed) :-
    is_list(Names), Names\=[], sort(Names, Unique), same_length(Names, Unique),
    forall(member(Name, Names), (string(Name), memberchk(Name, Allowed))).

% Run directly: swipl -q -s knowledge_base/esc1.pl -g esc1:demo -t halt
% This case infers two-hop Surface Water -> Aquatic Plants -> Birds effects.
demo :-
    Input=_{kind:"assess",processes:["Mineral Processing"],pollutant:"Suspended Solid",
            magnitude:5.0,receptors:["Surface Water","Aquatic Plants","Birds"]},
    evaluate(Input, Target, RuleIds),
    json_write_dict(current_output, _{inputs:Input,target:Target,rule_ids:RuleIds}, [width(100)]), nl.

% A_STANDARD_INTERVAL: ranges are documented, boundary convention is inferred.
standard_range(P, Lo, Hi, M, Id) :-
    fact("standard", _{pollutant:P}, _{lower:Lo,upper:Hi,magnitude:M}, Id).
standard_range(P, Lo, Hi, M, Id) :-
    fact("standard", _{pollutant:P,lower:Lo,upper:Hi}, M, Id).
concentration_magnitude(P,C,M,Id) :-
    standard_range(P,Lo,Hi,M,Id), C>=Lo,
    (C<Hi; C=:=Hi, \+ (standard_range(P,NextLo,_,_,_),NextLo=:=Hi)), !.

% A_BACKWARD_TRACE: candidates explain possible causes, not proven causation.
backward(Receptor, _{decision:"candidate_sources",direct_sources:Direct,indirect_sources:Indirect}, Ids) :-
    findall(_{pollutant:P,importance:I,processes:Processes}-[ImpactId|EmissionIds],
        (fact("impact",_{pollutant:P,environment:Receptor},I,ImpactId),
         source_processes(P,Processes,EmissionIds)), D0), pairs(D0,Direct,DIds0), append(DIds0,DIds),
    findall(_{pollutant:P,source_receptor:Root,path:Path,processes:Processes}-AllIds,
        (fact("impact",_{pollutant:P,environment:Root},_,ImpactId),
         indirect_path(Root,Receptor,[Root],Path,EdgeIds,2),
         source_processes(P,Processes,EmissionIds), append([[ImpactId],EdgeIds,EmissionIds],AllIds)),
        I0), pairs(I0,Indirect,IIds0),append(IIds0,IIds),
    append([DIds,IIds,["R_BACKWARD"]],All),sort(All,Ids).
source_processes(P,Processes,Ids) :-
    findall(Proc-Id,fact("emission",_{process:Proc,pollutant:P},_,Id),Pairs),pairs(Pairs,Processes,Ids).

% A_DETECTION_LIMIT: classify supplied observation against documented instrument.
instrument(Input, Target, Ids) :-
    (fact("method",_{pollutant:Input.pollutant,technique:Input.technique},Spec,MethodId),
     fact("unit",_{pollutant:Input.pollutant},Unit,UnitId) ->
        (Input.observed_value<Spec.minimum_detectable -> Decision="below_detection_limit"; Decision="measurable"),
        Target=_{decision:Decision,minimum_detectable:Spec.minimum_detectable,
                 variability:Spec.variability,unit:Unit},sort([MethodId,UnitId,"R_INSTRUMENT"],Ids)
    ; Target=_{decision:"insufficient_data",reason:"observation_method_not_in_kb"},Ids=["R_INSTRUMENT"] ).

% A_WP_RECONSTRUCTION / A_WP_AGGREGATION: complete synthetic assessment profile.
% Count/ratio thresholds and aspect aggregation are NOT recovered historical code.
wp_field(activities).
wp_field(alternatives).
wp_field(components).
wp_field(declared_assumptions).
wp_field(highlighted_impacts).
wp_field(impacts).
wp_field(measurements).
wp_field(objective_measurements).
wp_field(rare_severe_impacts).
wp_field(staged_activities).
count_grade(0,"N") :- !.
count_grade(1,"S") :- !.
count_grade(_,"L").
ratio_grade(_,0,"N") :- !.
ratio_grade(0,_,"N") :- !.
ratio_grade(A,B,"L") :- A>=B, !.
ratio_grade(_,_,"S").
answer_grade("yes","L").
answer_grade("no","N").
wp_grade(Input,"comprehensiveness",G,[]) :- count_grade(Input.counts.impacts,G).
wp_grade(Input,"specificity",G,[]) :- ratio_grade(Input.counts.components,Input.counts.impacts,G).
wp_grade(Input,"impact_isolation",G,[]) :- answer_grade(Input.answers.impact_isolation,G).
wp_grade(Input,"time_consideration",G,[]) :- ratio_grade(Input.counts.staged_activities,Input.counts.activities,G).
wp_grade(Input,"explicit_indicators",G,[]) :- answer_grade(Input.answers.explicit_indicators,G).
wp_grade(Input,"objectivity",G,[]) :- ratio_grade(Input.counts.objective_measurements,Input.counts.measurements,G).
wp_grade(Input,"significance",G,[]) :- answer_grade(Input.answers.significance,G).
wp_grade(Input,"explicit_criteria",G,[]) :- count_grade(Input.counts.declared_assumptions,G).
wp_grade(Input,"risk",G,[]) :- count_grade(Input.counts.rare_severe_impacts,G).
wp_grade(Input,"alternatives",G,[]) :- count_grade(Input.counts.alternatives,G).
wp_grade(Input,"environmental_setting",G,[]) :- count_grade(Input.counts.components,G).
wp_grade(Input,"key_issues",G,[]) :- count_grade(Input.counts.highlighted_impacts,G).
wp_grade(_,Criterion,G,[Id]) :- fact("criterion",_{criterion:Criterion},Value,Id),answer_grade(Value.answer,G).
wp_aspect("identification",["comprehensiveness","specificity","impact_isolation","time_consideration","data_sources"]).
wp_aspect("measurement",["explicit_indicators","magnitude","objectivity"]).
wp_aspect("interpretation",["significance","explicit_criteria","uncertainty","risk","alternatives","aggregation","public_involvement"]).
wp_aspect("communication",["affected_groups","environmental_setting","summary_format","key_issues","nepa_conformity"]).
grade_number("N",0).
grade_number("S",1).
grade_number("L",2).
aspect_grade(Grades,Names,Grade) :-
    findall(N,(member(Name,Names),atom_string(Key,Name),get_dict(Key,Grades,G),grade_number(G,N)),Numbers),
    sum_list(Numbers,Sum),length(Numbers,Count),Mean is Sum/Count,
    (Mean<0.5 -> Grade="N"; Mean<1.5 -> Grade="S"; Grade="L").
warner_preston(Input, _{decision:"method_assessed",criterion_grades:Grades,aspect_grades:Aspects}, Ids) :-
    findall(C-G,wp_grade(Input,C,G,_),Pairs),
    maplist(criterion_atom_pair,Pairs,AtomPairs),dict_create(Grades,_,AtomPairs),
    findall(A-G,(wp_aspect(A,Names),aspect_grade(Grades,Names,G)),AspectPairs),
    maplist(criterion_atom_pair,AspectPairs,Atoms),dict_create(Aspects,_,Atoms),
    findall(SourceIds,wp_grade(Input,_,_,SourceIds),Lists),append(Lists,SourceIds),sort(["R_WP"|SourceIds],Ids).
criterion_atom_pair(S-V,A-V) :- atom_string(A,S).
