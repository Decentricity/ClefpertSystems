# Prolog-generated scenario decisions

3,136 unique cases labeled by the running expanded Prolog program: 2,063 train, 359 validation, 714 test. The corpus covers 244 of 251 fact/inference IDs (97.21%). All seven uncovered IDs are listed in the manifest; six start from the physical Water Temperature node and one from the preserved `MicroFlora` spelling. The chosen forward path starts from scored environmental receptors, so those edges are not exercised by this corpus.

Workflows: forward impact assessment, concentration-to-magnitude assessment, backward source candidates, instrumentation, Warner–Preston methodology assessment repeated-analysis sessions and current ambient-reference screening. Session counts derive from actual Prolog outputs. Cases produce varying inferred effects, priorities, recommendations and methodology grades; there are no chapter-summary or fact-lookup training tasks.

`cases.jsonl` and the three split files contain `id`, `inputs`, `query`, `target`, `group_id` and `split`. `audit.jsonl` separately records the executable fingerprint, actual rule paths, source IDs and reconstruction assumptions. The exporter includes only prompt and target. `train.prompt_completion.jsonl` is the generic clean pair export; `train.messages.jsonl` can be regenerated and is ignored by Git.

The manifest records generator/executable fingerprints, corpus/audit hashes, split counts, per-class counts, query kinds, grouping and coverage. Forward, concentration and repeated-session variants for a pollutant stay in a single split. Instrumentation stays train-only; backward queries stay test-only. Warner–Preston count profiles keep all explicit-answer variants together and exclude one-counter-neighbor profiles. These are intentionally conservative generalization splits, not IID rows or a claim of representative historical performance.

Scores and method grades reflect the explicitly reconstructed POC assumptions. `insufficient_data` preserves unsupported evidence rather than interpreting missing facts as no impact. No original historical execution traces or trained-model predictions are supplied.

The corpus includes 254 synthetic `screen_ambient` queries against twelve frozen current EPA reference rows. These require supplied summaries, preserve statistical forms, and explicitly abstain on incompatible scopes/units or incomplete data. See [current-reference scope](../../docs/current-standards.md). Current and historical pollutant counterparts, including PM fractions and equivalent-unit variants, stay within the same split.
