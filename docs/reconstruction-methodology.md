# Reconstruction methodology

The thesis informs a runnable expert system. The expert system, rather than the structure or prose of the thesis, supplies the training labels. The user authorized inferred logic to make a coherent approximate reconstruction, then requested a small prototype, expanded reconstruction, and finally a reusable translator in that order.

## Evidence and executable semantics

Maintain three separate layers:

1. **Documented facts:** explicit snippets, visually checked table cells and statements. Each executable fact cites a stable source ID, chapter file ID, one-based chapter PDF page, printed page and section/table.
2. **Faithful translations:** Prolog representations preserve relations, directions, spelling and numeric values. Table 5.2's second column influences the first. Do not transpose it. Do not silently normalize `MicroFlora` to `Microflora` or claim missing scientific units.
3. **Reconstructed domain logic:** `A_*` assumptions explain the POC's score products, priority bands, bounded path propagation, concentration-boundary choices, detection-limit classification, full Warner–Preston grade recipe and session aggregation. Enabled assumptions are part of the named reconstruction profile; they are not described as recovered code.

Engineering glue covers JSON transport, validation, canonicalization, generation, grouping and export. It does not determine oracle targets. `provenance.yaml` and `docs/evidence/` are audit documentation, not training examples. The initial extraction inventory is retained under `docs/evidence/initial-provenance.yaml` for historical comparison.

## Reconstruction scope

Freeze the small prototype separately, then expand the executable inference system. The expanded model implements the documented workflow families, including repeated analysis sessions whose executed reports supply Warner–Preston impact/component counts. Keep absent social-consequence text and unsupported environmental relationships explicit. Remaining source gaps prevent recovery of the complete original program and all historical data, even though a coherent broader program can be reconstructed.

Do not infer an overall permit/deny or safe/unsafe outcome. The POC's `monitor`, `mitigate`, `urgent_review`, `no_detected_impact` and `insufficient_data` action labels are named reconstruction choices. H2S/SO2 concentration bands retain unspecified historical units; input concentration is on the source scale, not a certified physical-unit interpretation.

## Runtime translation

A Prolog adapter exposes `domain/1`, `evaluate/3` and `rule_id/1`. The translator executes it in SWI-Prolog. Domain introspection provides legal state vocabulary and workflow metadata; a separate generator enumerates cases. Custom KBs supply an explicit grouped state JSONL rather than relying on guessed input domains. Imported program dependencies must be declared for fingerprints.

The generic case JSONL stores only case IDs, structured inputs, query text, structured oracle targets, group IDs and splits. A separate audit sidecar stores executable fingerprint, used rule IDs, source IDs and assumption IDs. Fine-tuning exports contain only query text and serialized targets. Neither source chapters nor evidence prose is sent to the model.

## Splits and coverage

The built-in generator enumerates legal process/pollutant cases, receptor contexts and magnitudes, adds concentration-boundary cases, instrument observations, reverse queries, complete methodology sessions and repeated-analysis sessions. Labels come exclusively from Prolog.

All forward, concentration and repeated-session cases for a pollutant share one split. Therefore numeric perturbations, process variants and receptor variants of that pollutant cannot leak across splits. Instrument observations stay in one group, backward queries in one group, and methodology answer variants stay with their count profile. Count profiles differing by a single counter are rejected during sampling. Deduplicate normalized inputs and reject conflicting assignments.

Publish actual split sizes, per-class counts and uncovered executable IDs. Pollutant holdouts test generalization to unseen source/importance combinations. The sole instrument example is train-only; reverse tracing is test-only. These limitations mean the current corpus is a distillation POC, not a representative historical benchmark.

## Regression evaluation

Re-execute the same KB for every frozen case. Reject altered IDs, prompts, target values, executable fingerprints and rule traces. Join predictions by case ID; reject duplicate/extra predictions, malformed JSON outputs and non-finite confidence values. Missing predictions count as disagreements.

Primary exact decision agreement compares the whole structured result, preserving array order and scalar types and ignoring object-key order. Also report action-label agreement, supported-only agreement, per-class exact-output accuracy, Warner–Preston criterion/aspect accuracy, disagreement examples and rule coverage. Optional confidence is confidence that the entire result is correct; Brier/reliability metrics use only predictions supplying confidence and state that denominator.

An oracle-copy fixture only verifies plumbing. No model has been tuned or evaluated. Freeze program/dependencies, generation code, state profiles, prompts, split manifest, exporter contract and model configuration for future experiments. A Clef-specific export must use an identified versioned Clef schema; generic messages and prompt/completion formats are not described as verified Clef compatibility.
