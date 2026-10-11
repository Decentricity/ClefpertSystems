% Generic executable Prolog adapter. KB path is supplied by CLI, not source prose.
:- module(oracle_bridge, [main/0]).
:- use_module(library(apply)).
:- use_module(library(http/json)).
main :- catch(run, Error, (print_message(error, Error), halt(1))), halt.
run :-
    current_prolog_flag(argv, [KB]),
    use_module(KB, [evaluate/3, domain/1, rule_id/1]),
    json_read_dict(current_input, Request),
    ( Request.action == "evaluate" -> maplist(answer, Request.inputs, Result)
    ; Request.action == "domain" -> domain(Result)
    ; Request.action == "rules" -> findall(Id,rule_id(Id),Ids),sort(Ids,Result)
    ; throw(error(domain_error(action, Request.action), _)) ),
    json_write_dict(current_output, Result, [width(0)]), nl.
answer(Input, _{target:Target,rule_ids:RuleIds}) :- evaluate(Input, Target, RuleIds).
