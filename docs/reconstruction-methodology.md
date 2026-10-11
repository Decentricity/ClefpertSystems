# Reconstruction methodology

## Evidence boundaries

Each source item has a stable ID, chapter PDF file ID, one-based PDF page, printed page label, section/table, and an excerpt or transcription. Record source hashes and retrieval date. Page numbers refer to individual chapter PDFs, not a merged document. Verify table row alignment and diagrams visually; text extraction alone is insufficient. Retain source spellings and numerical types in evidence; document normalization in executable translations.

Three layers must remain distinguishable:

1. **Documented**: quotations, explicit clauses, table cells, and narrative statements from the thesis. These are historical statements, not independently verified contemporary scientific claims.
2. **Translation**: executable representations preserving the documented relation and values. Every domain clause cites evidence; no absent relation becomes false.
3. **Glue**: JSON API, type validation, atom/string handling, deterministic output sorting, abstention, case generation, and split policy. These are engineering choices, never historical rules.

An inferred domain rule requires a new assumption ID, rationale, alternatives, and opt-in configuration; none are enabled initially. Arithmetic thresholds, concentration units, interval inclusivity, component-score aggregation, and inferred transitive links are excluded unless explicitly supported. A snippet copied in Chapter IV is described there as updated ESC-2 code; do not relabel it as recovered original ESC-1 source.

## Initial scope

Translate a representative subset of Table 5.1, explicit Chapter IV/VI snippets, eight fixed Warner–Preston criterion answers, and the four two-answer scoring outcomes on VI.4. The generic two-answer scoring query has anonymous answers: the thesis does not establish which two questions belong to each criterion/component. Never apply that truth table automatically to the twenty criteria or infer L/N from a fixed yes/no answer, except the explicit L statements for data sources and magnitude.

Unknown lookup results return `undocumented`, not false. Unsupported query kinds, unknown criteria, malformed fields and invalid answer values fail validation. Known criteria requiring missing databases or thresholds abstain. Do not silently replace a missing SWI-Prolog runtime with Python scoring.

## Dataset and splits

Enumerate the four valid yes/no pairs and finite lookup/input domains defined from the current evidence inventory. Cartesian products of documented pollutant/environment labels include combinations absent from the subset: these are deliberately labeled abstentions, not historical negatives. Include all twenty criterion queries. Record canonical query text, structured target, executed rule IDs, source IDs, oracle hash, and separate glue IDs. Synthetic cases do not reproduce historical user sessions.

Deduplicate canonical structured inputs, then keep an entire query family in one split. This conservatively contains every one-field neighbor, paraphrase, and numeric perturbation of a family. The two-answer truth table is indivisible under a Hamming-distance-one policy; hold it out as a four-case diagnostic. This very small initial corpus is a pipeline fixture with family generalization holdouts, not an IID benchmark. Publish split sizes, class counts, abstention fraction, and covered rule IDs. Do not shuffle paraphrases into different splits to increase apparent sample size. Later enlarge evidence and use explicit scenario groups before attempting representative train/validation/test proportions.

## Evaluation

Join predictions by stable case ID; reject duplicates, extra IDs, malformed confidences, and non-object outputs. Missing predictions count as disagreements. Re-execute the oracle for each case and reject stale targets/hashes/traces. Primary metric is exact equality of the complete structured decision (ignoring JSON object key order, preserving field types). Secondary metrics: per-class agreement, supported-only agreement, disagreements, and trace coverage. Optional confidence in [0,1] represents confidence that the entire output is correct; report Brier score and reliability bins over supplied confidences, with denominator. This is confidence-in-correctness calibration, not a multiclass posterior metric. Fixtures must never be described as model evaluation.

## Future adapters and Clef

Adapters expose `evaluate(inputs)` and `fingerprint()`; generators and exporters remain independent of symbolic syntax. Add Datalog or other backends without changing intermediate records. Implement a Clef exporter only against a supplied, versioned schema, with a schema contract test. Freeze KB, source evidence, generator version, prompts, splits, exporter, model configuration, and predictions for any experiment. Fine-tuning and external publication are later stages.
