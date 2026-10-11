# Executable Prolog adapter

A module suitable for translation exports:

```prolog
:- module(my_system, [domain/1, evaluate/3, rule_id/1]).
% domain(-JSONSerializableMetadata)
% evaluate(+InputDict, -TargetDict, -UsedRuleIds)
% rule_id(-InventoryRuleId)
```

`evaluate/3` validates input, executes domain inference and produces exactly one deterministic JSON-compatible target. Used rule IDs identify actual proof paths. `domain/1` exposes generator vocabulary; it is not a document parser. `rule_id/1` enumerates the frozen executable inventory. Use strings for values, dicts/arrays for structured results, and exceptions for invalid states. Unknown evidence may produce an explicit insufficient-data decision.

Run `scripts/translate_prolog.py` with the module and a state file. State rows contain `inputs`, a nonempty `group_id`, and an optional train/validation/test `split`. Supply `--dependency` for each imported rule/data module so its content is fingerprinted. If a custom module lacks this interface, write a small adapter module; arbitrary Prolog programs do not have a universally inferable input/output contract.

The bridge loads the selected module and executes its predicates. It does not infer labels from predicate names, source text or paper prose. The thermostat example demonstrates a different KB and schema through the same translator. A future Datalog adapter can implement Python's `Oracle` protocol without changing case/export formats.

## Export contracts

`messages` emits user/assistant records; `prompt_completion` emits two text fields. In each, prompt text contains the scenario and the assistant/completion is canonical JSON from the oracle.

For an actual Clef version using a flat input/target pair, provide a JSON mapping with `schema_name`, `schema_version`, `layout` (must be `pair`), `input_field` and `target_field`. The last two must be distinct. These values must come from that Clef implementation's documented contract; no example is presented as an official Clef schema. Pass the file using `--format clef --contract PATH`. If Clef requires a richer layout, add an exporter against that schema with a contract test.

Exports discard case IDs, audit prose and rule traces. Optional `--index` creates a separate row-to-case-ID file for evaluation joins. The generic JSONL and `audit.jsonl` remain the reviewable source artifacts.

The default cement oracle fingerprints `documented_facts.pl` and `current_standards.pl` as dependencies. Its domain exposes `ambient_standards` with versioned reference levels and statistical tags; the generator reads those executable declarations without parsing source prose. The added `screen_ambient` query uses the same evaluate/3 interface as all historical workflows.
