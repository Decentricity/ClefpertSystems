% Unrelated executable KB to demonstrate that translation is not thesis-specific.
:- module(tiny_kb, [evaluate/3,domain/1,rule_id/1]).
domain(_{temperature_range:[0,40]}).
rule_id("HEAT").
rule_id("HOLD").
rule_id("COOL").
evaluate(Input, _{decision:Decision}, [Rule]) :-
    (Input.kind=="thermostat",number(Input.temperature),Input.temperature>=0,Input.temperature=<40 -> true
    ; throw(error(domain_error(thermostat_input,Input),_))),
    action(Input.temperature,Decision,Rule).
action(T,"heat","HEAT") :- T<18, !.
action(T,"hold","HOLD") :- T<24, !.
action(_,"cool","COOL").
