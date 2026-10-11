:- begin_tests(prototype).
:- use_module(library(lists)).
:- use_module('../knowledge_base/prototype').
case(Magnitude, Receptors, Input) :-
    Input=_{kind:"assess",processes:["Mineral Processing"],pollutant:"Suspended Solid",
            magnitude:Magnitude,receptors:Receptors}.
test(two_hop_inference) :-
    case(5.0,["Surface Water","Aquatic Plants","Birds"],Input), evaluate(Input,T,Ids),
    T.decision == "urgent_review", T.maximum_score =:= 40,
    member(I,T.indirect_impacts), I.path == ["Surface Water","Aquatic Plants","Birds"],
    memberchk("R_INDIRECT",Ids), T.mitigations\=[].
test(zero_exposure_preserves_known_paths) :-
    case(0.0,["Surface Water","Aquatic Plants","Birds"],Input), evaluate(Input,T,_),
    T.decision == "no_detected_impact", T.indirect_impacts == [], T.mitigations == [].
test(absent_relation_is_not_a_negative) :-
    case(5.0,["Land Animals Reptiles"],Input), evaluate(Input,T,Ids),
    T.decision == "insufficient_data", T.unresolved_receptors == ["Land Animals Reptiles"],
    memberchk("R_GAPS",Ids).
:- end_tests(prototype).
