% Runnable reconstructed expert system, not the lost original ESC source.
% Documented facts: prototype_facts.pl. POC assumptions: provenance.yaml A_*.
:- module(prototype, [evaluate/3, domain/1, rule_id/1, demo/0]).
:- use_module(prototype_facts).
:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(http/json)).

rule_id(Id) :- fact(_, _, _, Id).
rule_id(Id) :- member(Id, ["R_FORWARD", "R_DIRECT", "R_INDIRECT", "R_SOCIAL",
                           "R_MITIGATION", "R_PRIORITY", "R_GAPS", "R_ASSESS"]).

% Domain introspection lets a generator enumerate inputs without reading the paper.
domain(_{processes:Processes, pollutants:Pollutants, receptors:Receptors,
         process_pollutant_pairs:Pairs, direct_pairs:Direct, indirect_pairs:Indirect,
         magnitude_range:[0,10], profile:"cement_poc_v2"}) :-
    findall(P, fact("emission", _{process:P,pollutant:_}, _, _), Ps), sort(Ps, Processes),
    findall(P, fact("emission", _{process:_,pollutant:P}, _, _), Pols), sort(Pols, Pollutants),
    findall(E, (fact("impact", _{pollutant:_,environment:E}, _, _);
                fact("indirect", _{from:_,to:E}, _, _)), Es), sort(Es, Receptors),
    findall(Fields, fact("emission", Fields, _, _), Pairs),
    findall(Fields, fact("impact", Fields, _, _), Direct),
    findall(Fields, fact("indirect", Fields, _, _), Indirect).

% A_CASE_SCOPE: selected process -> selected pollutant -> present receptors.
evaluate(Input, Target, RuleIds) :-
    (valid_input(Input) -> true; throw(error(domain_error(oracle_input, Input), _))),
    findall(_{process:P,pollutant:Input.pollutant}-Id,
            (member(P, Input.processes), fact("emission", _{process:P,pollutant:Input.pollutant}, _, Id)), Sources0),
    pairs(Sources0, Sources, SourceIds),
    findall(D-Id, direct(Input, D, Id), Direct0), pairs(Direct0, Direct, DirectIds),
    findall(I-Ids, indirect(Input, Direct, I, Ids), Indirect0),
    pairs(Indirect0, Indirect, EdgeLists), append(EdgeLists, EdgeIds),
    findall(S-Ids, social(Input, S, Ids), Social0),
    pairs(Social0, Social, SocialLists), append(SocialLists, SocialIds),
    findall(M-Id, mitigation(Input, M, Id), Mitigation0), pairs(Mitigation0, Mitigations, MitigationIds),
    findall(E, (member(E, Input.receptors), \+ covered_receptor(E, Direct, Indirect)), Gaps),
    findall(Score, (member(D, Direct), Score=D.score), Scores), max_list([0.0|Scores], Max),
    priority(Max, Priority), (Gaps=[] -> Decision=Priority; Decision="insufficient_data"),
    Target=_{decision:Decision, priority:Priority, maximum_score:Max,
             sources:Sources, direct_impacts:Direct, indirect_impacts:Indirect,
             social_impacts:Social, mitigations:Mitigations, unresolved_receptors:Gaps},
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
social(Input, _{process:P,factor:Factor,importance:Importance,consequence:Text}, [ImpactId,ChangeId]) :-
    member(P, Input.processes),
    fact("impact_se", _{activity:P,factor:Factor}, Importance, ImpactId),
    fact("soc_ec", _{activity:Factor}, Text, ChangeId).

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
valid_input(Input) :-
    is_dict(Input), dict_pairs(Input, _, Fields),
    findall(K, member(K-_, Fields), Keys), Keys=[kind,magnitude,pollutant,processes,receptors],
    Input.kind == "assess", string(Input.pollutant),
    number(Input.magnitude), Input.magnitude >= 0, Input.magnitude =< 10,
    domain(Domain), valid_names(Input.processes, Domain.processes),
    valid_names(Input.receptors, Domain.receptors),
    forall(member(P, Input.processes), fact("emission", _{process:P,pollutant:Input.pollutant}, _, _)).
valid_names(Names, Allowed) :-
    is_list(Names), Names\=[], sort(Names, Unique), same_length(Names, Unique),
    forall(member(Name, Names), (string(Name), memberchk(Name, Allowed))).

% Run directly: swipl -q -s knowledge_base/esc1.pl -g prototype:demo -t halt
% This case infers two-hop Surface Water -> Aquatic Plants -> Birds effects.
demo :-
    Input=_{kind:"assess",processes:["Mineral Processing"],pollutant:"Suspended Solid",
            magnitude:5.0,receptors:["Surface Water","Aquatic Plants","Birds"]},
    evaluate(Input, Target, RuleIds),
    json_write_dict(current_output, _{inputs:Input,target:Target,rule_ids:RuleIds}, [width(100)]), nl.
