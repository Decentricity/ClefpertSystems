# Running examples

`session.json` supplies repeated cement-industry analyses. Run it through the executable Prolog system:

```sh
python scripts/run_oracle.py --input examples/session.json
```

The output combines actual impact reports with derived session counts and Warner–Preston methodology grades.

`tiny_kb.pl` is an unrelated thermostat expert system. It demonstrates the reusable translator with the input states in `tiny_states.jsonl`:

```sh
python scripts/translate_prolog.py --kb examples/tiny_kb.pl --states examples/tiny_states.jsonl --output /tmp/tiny-dataset --format prompt_completion
```

`test_predictions.jsonl` copies the 714 current test oracle targets with confidence 1.0 solely to verify evaluation wiring. It is not a model artifact or performance result. Replace it with real model outputs, joined by case ID:

```json
{"id":"<case ID>","output":{"decision":"<predicted decision>"},"confidence":0.8}
```

`output` must be a parsed JSON object containing the complete predicted structured result. Confidence is optional and means probability that the entire result is correct. Missing predictions count as disagreements; duplicate/extra IDs are rejected. Do not provide target values or audit traces to the model at evaluation time.

`current_ambient.json` supplies a synthetic PM2.5 annual three-year mean of 10 µg/m³ against the current EPA primary reference of 9 µg/m³. Run `python scripts/run_oracle.py --input examples/current_ambient.json`: Prolog returns `exceeds_reference`. This screens a supplied summary and does not determine legal attainment.
