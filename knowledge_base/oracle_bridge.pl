% GLUE_API: JSON transport only; all domain answers come from esc1.pl.
:- module(oracle_bridge, [main/0]).
:- use_module(esc1).
:- use_module(library(apply)).
:- use_module(library(http/json)).

main :-
    catch(run, Error, (print_message(error, Error), halt(1))), halt.
run :-
    json_read_dict(current_input, Request),
    ( Request.action == "evaluate" ->
        maplist(answer, Request.inputs, Result)
    ; Request.action == "domain" ->
        findall(Input, domain_case(Input), Raw), sort(Raw, Result)
    ; throw(error(domain_error(action, Request.action), _))
    ),
    json_write_dict(current_output, Result, [width(0)]), nl.
answer(Input, _{target:Target, rule_ids:RuleIds}) :- evaluate(Input, Target, RuleIds).
