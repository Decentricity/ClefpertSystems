# ClefpertSystems

A running Prolog expert system is the source of truth for model-training data:

**Prolog program → case generator → executable oracle → input/decision pairs → Clef exporter → model/oracle regression tests.**

The first system reconstructs cement-industry impact reasoning inspired by [Pandu Wisaksono Sastrowardoyo’s thesis](https://digilib.itb.ac.id/gdl/view_data/penggunaan-penilaian-metoda-dampak-warner-preston-dalam-program-komputer-sistem-pakar-analisa-dampak-industri-semen). ESC uses Leopold/Sorensen for impact analysis and Warner–Preston for methodology assessment. The lost code is not recovered: this is a deliberately approximate, executable reconstruction with documented facts and clearly labeled inferred logic.

## Three phases

1. **Small running system:** [prototype.pl](knowledge_base/prototype.pl), with a frozen fact subset and reasoning tests.
2. **Expanded reconstruction:** [esc1.pl](knowledge_base/esc1.pl), 223 thesis-derived documented facts, 13 processes, seven pollutants, twenty environmental components, forward/backward inference, social effects, mitigations, concentration bands, instrumentation, twenty Warner–Preston criteria and session assessment.
3. **Translation:** [translate_prolog.py](scripts/translate_prolog.py) runs any Prolog module implementing the adapter contract. It generates targets from executable behavior, never from thesis summaries.

The base system also includes **twelve current US EPA ambient-air reference standards**, sourced online from EPA’s table (updated November 2025, retrieved October 2026). The new screening workflow preserves units, averaging periods and statistical forms. See [current standards and update scope](docs/current-standards.md). Historical thesis relationships and inferred score logic remain explicitly identified; this is not a blanket claim that all historical data have been modernized.

See [prototype notes](docs/prototype.md), [expanded reconstruction](docs/expanded-reconstruction.md), [methodology](docs/reconstruction-methodology.md) and [adapter contract](docs/prolog-adapter.md).

## Run

Requirements: Python 3.10+ and SWI-Prolog 9.x. Use `swipl` on PATH, or set `SWIPL` for Python commands. No model credentials or Python packages are required.

```sh
swipl -q -s knowledge_base/prototype.pl -g prototype:demo -t halt
swipl -q -s knowledge_base/esc1.pl -g esc1:demo -t halt
python scripts/run_oracle.py --input examples/session.json
python scripts/run_oracle.py --input examples/current_ambient.json
python scripts/generate_cases.py
python -m unittest discover -s tests -v
swipl -q -s tests/test_prototype.pl -g run_tests -t halt
python scripts/export_clef_dataset.py --input dataset/generated/train.jsonl --output dataset/generated/train.messages.jsonl --format messages
python scripts/validate_against_prolog.py --cases dataset/generated/test.jsonl --predictions examples/test_predictions.jsonl --report dataset/generated/evaluation.json
```

The generated corpus contains **3,136 executable cases**: 2,063 train, 359 validation, 714 test. It covers 244 of 251 fact/inference IDs; the seven uncovered IDs are reported explicitly. Splits keep pollutant families, current/historical counterparts and equivalent unit/statistic variants together and group Warner–Preston sessions. These are generalization holdouts, not IID random rows.

## Data boundaries

`dataset/generated/train.jsonl`, `validation.jsonl` and `test.jsonl` contain case inputs and Prolog-produced decisions, plus IDs/split bookkeeping. Model exports contain only prompt/target pairs. Chapter numbers, prose summaries, source citations, assumptions and rule traces live in `docs/evidence/`, `knowledge_base/provenance.yaml` and the separate `dataset/generated/audit.jsonl`; they are not model inputs or targets.

`train.prompt_completion.jsonl` is a ready-to-inspect generic pair export. `messages` is also supported. For `--format clef`, supply the actual versioned Clef pair-format contract with `--contract`; no undocumented Clef schema is guessed. No fine-tuning is performed here. `examples/test_predictions.jsonl` copies oracle outputs purely to check evaluation wiring and is not model performance evidence.

## Translate another system

```sh
python scripts/translate_prolog.py --kb examples/tiny_kb.pl --states examples/tiny_states.jsonl --output /tmp/tiny-dataset --format prompt_completion
```

This unrelated thermostat example demonstrates the general adapter. Future Datalog and other symbolic backends can implement the same executable oracle protocol.

The reconstructed priority cutoffs, score arithmetic, interval boundaries and Warner–Preston aggregation are POC assumptions, not the original historical algorithms. Uncovered relationships remain unresolved. Agreements measure the **versioned reconstructed program**, not historical equivalence or regulatory validity.
