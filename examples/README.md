# Evaluation fixture

`test_predictions.jsonl` copies the 25 test oracle targets with confidence 1.0 to verify the evaluator's wiring. It is not a trained-model artifact or evidence of model performance. Replace it with future model predictions, each containing:

```json
{"id":"<case ID>","output":{"status":"documented","value":"L"},"confidence":0.8}
```

`output` must be a JSON object; parse generated model text first. Confidence is optional and means probability that the entire decision is correct. Missing predictions count as disagreements; duplicate/extra IDs are rejected. Case IDs join against the frozen test JSONL. Do not provide targets, provenance, or rule IDs to the model at evaluation time.
