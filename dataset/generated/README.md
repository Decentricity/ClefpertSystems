# Generated integration corpus

Generated solely through SWI-Prolog: 70 unique cases, 44 documented decisions and 26 abstentions. 43 train, 2 validation, 25 test. All 44 current domain clauses are covered across the corpus. Run `generate_cases.py` to regenerate deterministically; `manifest.json` freezes execution/evidence fingerprint, generator digest, cases digest, class counts and family allocation.

Targets are structured JSON objects, retaining the generic intermediate representation. Exporters serialize them as canonical JSON text. Provenance is available for audit but excluded from model prompts. Rule IDs describe actually used documented clauses; abstentions have no domain rule ID and carry `GLUE_ABSTAIN` separately.

Enumeration: documented facts, all twenty criterion names, all four yes/no pairs, and Cartesian products of the finite impact and indirect-edge labels. Unknown combinations mean absent evidence in this subset, not no impact. No concentration classification or simulated historical sessions are generated.

Splits hold out entire query families, including all one-field neighbors. Validation contains only two facts and cannot support hyperparameter selection; test contains criterion assessment, mitigation and the complete two-answer truth table. Classes and tasks are uneven and some appear only in test. This intentionally conservative fixture tests plumbing and family generalization, not useful model training or historical equivalence. Expand documented evidence and scenario groups before a model experiment.
