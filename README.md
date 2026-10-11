# ClefpertSystems

A provenance-first proof of concept for **symbolic knowledge base → executable oracle → synthetic cases → generic JSONL → fine-tuning exporter → decision agreement evaluation**. “ClefpertSystems” combines Clef and Expert Systems.

The initial source is [Pandu Wisaksono Sastrowardoyo’s thesis](https://digilib.itb.ac.id/gdl/view_data/penggunaan-penilaian-metoda-dampak-warner-preston-dalam-program-komputer-sistem-pakar-analisa-dampak-industri-semen). ESC-1 uses Leopold and Sorensen for impact analysis; the thesis develops ESC-2 with a Warner–Preston **methodology assessment** module. The historical source code is lost. This project reconstructs only a small documented subset, not historical equivalence or an operational environmental assessment tool.

See [thesis notes](docs/thesis-notes.md), [reconstruction methodology](docs/reconstruction-methodology.md), and [machine-readable provenance](knowledge_base/provenance.yaml). Missing thresholds, question pairings, and complete databases are not invented. `undocumented` means insufficient evidence in this subset; it does not mean a historical negative decision.

## Run locally

Requirements: Python 3.10+ and SWI-Prolog 9.x (`swipl` on PATH, or set `SWIPL` to its executable). No Python packages or model credentials are needed.

```sh
python scripts/generate_cases.py
python -m unittest discover -s tests -v
python scripts/validate_against_prolog.py --cases dataset/generated/test.jsonl --predictions examples/test_predictions.jsonl --report dataset/generated/evaluation.json
python scripts/export_clef_dataset.py --input dataset/generated/train.jsonl --output dataset/generated/train.messages.jsonl --format messages
```

The example predictions copy oracle answers solely to exercise evaluation; they are **not model results**. The `messages` export is a generic chat format, not a verified Clef contract. A real Clef schema and version must be supplied before implementing or claiming a Clef-compatible export. No fine-tuning is performed here.

## Layout and scope

- `knowledge_base/esc1.pl`: documented facts, translated scoring clauses, and separately identified runtime glue.
- `dataset/raw/`: source manifest and extraction evidence; full thesis PDFs are kept out of Git.
- `scripts/oracles.py`: oracle protocol and SWI-Prolog adapter. Future Datalog/other adapters must implement the same interface.
- `scripts/generate_cases.py`: finite enumeration, labeling exclusively through Prolog, conservative grouping, and a reproducible manifest.
- `scripts/validate_against_prolog.py`: fresh oracle comparison, exact agreement, class accuracy, confidence diagnostics, disagreements, and rule-path coverage.
- `tests/`: source transcription checks, unsupported-input behavior, split leakage checks, and evaluator failure cases.

The small generated corpus is an integration fixture. Holding entire task families together prevents near-duplicate leakage but produces task-family holdouts and uneven classes. It is not enough to support a fine-tuning effectiveness claim. Future evaluation measures agreement with the **versioned reconstruction**; agreement with the lost original system cannot be established from this corpus.
