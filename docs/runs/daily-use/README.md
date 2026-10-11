# Executed Prolog daily-use run

Synthetic workdays: 5–9 October 2026. Actual execution and capture: 11 October 2026 (UTC timestamps are recorded per artifact).

- `manifest.json`: runtime version, executable oracle fingerprint, plan/runner hashes and counts.
- `consultations.json`: all 55 executed consultations, inputs and actual oracle answers.
- `inputs/`, `outputs/`, `consultations/`: individual replayable inputs, outputs and rendered views.
- `report-day-01` through `report-day-05`: full HTML/JSON assessment-support reports.
- `verification.json`: 149 passed expected-decision, replay, rejection and report/session checks.
- `runtime-verification.json` and five command `.log` files: actual direct Prolog/runtime/test execution.
- `execution.log`: actual consultation-run progress, including each returned decision.
- `screenshots.json`: 71 complete captures with source/image hashes and pixel dimensions.
- `screenshots/`: every consultation, report, rejection, direct command, test log and run overview.

See the [testing plan](../../daily-use-testing.md) for reproduction and the root [README](../../../README.md) for every embedded screenshot. These are scripted workflows with synthetic inputs; reports require human review. The historical reconstruction and US ambient reference profiles preserve their documented limitations.
