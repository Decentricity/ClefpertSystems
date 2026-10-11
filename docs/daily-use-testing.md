# Daily-use Prolog testing plan and executed run

This is a scripted simulation of five environmental-officer workdays at **Synthetic Cement Works**, using synthetic inputs. SWI-Prolog actually executes the reconstructed KB; only the people, dates and scenarios are simulated. The generated documents support assessment and human review. They are not statutory environmental impact assessments, real monitoring records, or legal attainment determinations.

## Plan

Each of the five synthetic workdays has eleven scheduled consultations:

| Time | Role | Task and executable workflow |
| --- | --- | --- |
| 08:00 | Instrument operator | Detection-limit check (`instrumentation`) |
| 08:30 | Environmental officer | Processing/storage particulate assessment (`assess`) |
| 09:00 | Environmental officer | SO2 assessment for shrubs and birds (`assess`) |
| 10:00 | Environmental officer | Water assessment and two-hop ecological paths (`assess`) |
| 10:30 | Environmental officer | An unsupported CO-to-aquatic-plants relation (`assess`) |
| 11:00 | Environmental officer | Historical H2S source-scale bands (`assess_concentration`) |
| 11:30 | Environmental officer | Candidate source inspection for birds (`trace_back`) |
| 13:00 | Monitoring analyst | Review a stored current-reference summary (`screen_ambient`) |
| 14:00 | Report reviewer | Standalone methodology profile (`method_assessment`) |
| 14:30 | Environmental officer | Lower-magnitude alternative input (`assess`) |
| 15:00 | Report reviewer | Six executed analyses drive the session/report (`assess_session`) |

Days cover baseline conditions, higher runoff/impact magnitudes, incomplete monitoring summaries, compatible unit conversions, frequency-based reference limits, detection-limit boundaries, zero supplied exposure, and an uncovered historical concentration range. The current ambient cases retain their statistical/averaging periods: a daily review of a three-year summary is not a daily air-quality measurement. Alternative magnitudes are hypothetical inputs, not measured intervention effects. Instrument fixtures do not calibrate those magnitudes.

The plan is checked in as [daily_use_plan.json](../examples/daily_use_plan.json). It includes independent expected decision labels for all 55 consultations. Four malformed requests exercise negative and boolean magnitudes, an unknown process and an unexpected field. Three are rejected by Prolog; the boolean is rejected by the Python input adapter before Prolog execution.

## Execution and acceptance checks

1. Invoke SWI-Prolog separately for each consultation through `oracle_bridge.pl`; save the exact input, target, rule trace, execution timestamp and input hash.
2. Compare each returned decision with the plan's expected decision.
3. Generate five HTML/JSON support reports from those outputs, including numerical priorities, ecological paths, documented recommendations, unresolved evidence, current ambient screening and methodology grades.
4. Replay all 55 inputs in a fresh Prolog batch invocation and compare full answers, including rule traces.
5. Compare the six nested analyses in each session with the individually executed consultations; verify six measurements and twenty methodology criteria. Verify that the zero-exposure day returns no baseline mitigation recommendations.
6. Run the Prolog demo directly, run the JSON bridge directly, run three Prolog tests, and run the full 32-test Python suite. Save actual commands, stdin, stdout, stderr and exit codes.
7. Render every saved consultation, report, rejection and transcript in Chromium. Validate displayed JSON against saved results before taking full-page screenshots; verify PNG dimensions match complete document height. Save source/image hashes in the screenshot manifest.

The executed run passed **149 scenario/replay/report checks**, plus **32 Python tests and three Prolog tests**. It recorded 55 accepted consultations, five reports, four expected input rejections and **71 full-page screenshots**. See the [run manifest](runs/daily-use/manifest.json), [checks](runs/daily-use/verification.json), [direct runtime verification](runs/daily-use/runtime-verification.json) and [screenshot manifest](runs/daily-use/screenshots.json). Every screenshot is embedded in the root [README](../README.md).

Screenshots are real Chromium captures of local HTML containing actual saved output. The browser is given local HTML with `set_content` because this environment blocks `file://` navigation. The transcript views render captured stdout/stderr; they are not screenshots of an interactive shell desktop. Each consultation screenshot includes complete inputs, results and rule IDs. No text-to-image generation, mocked decision engine or Python fallback labels are used.

## Reproduce

Core simulation and verification require Python 3.10+ and SWI-Prolog 9.x. Screenshot capture additionally requires Python Playwright and a Chromium browser. This run used SWI-Prolog 9.2.9 and the environment's installed `/usr/bin/chromium`; the exact browser version is recorded in the screenshot manifest.

```sh
# If swipl is already on PATH, omit SWIPL. This was the executable in this environment:
export SWIPL=/workspace/.local/bin/swipl
python scripts/simulate_daily_use.py
python scripts/verify_daily_use.py
python scripts/capture_daily_use.py --browser-executable /usr/bin/chromium
```

For another machine, install SWI-Prolog through its normal package manager. If needed, install screenshot dependencies with `python -m pip install playwright` and `python -m playwright install chromium`; omit `--browser-executable` to use Playwright's installed browser when no system Chromium is found.

To inspect one original consultation independently:

```sh
python scripts/run_oracle.py --input docs/runs/daily-use/inputs/day-03-ambient.json
swipl -q -f none -s knowledge_base/esc1.pl -g esc1:demo -t halt
```

To browse the static reports on a machine allowing localhost access:

```sh
python -m http.server 8000 --directory docs/runs/daily-use
# Open http://localhost:8000/index.html
```

Use `--output PATH` on all three scripts to save a new run elsewhere. The simulation is deterministic in inputs/decisions; actual execution/capture timestamps vary. After changing the KB, regenerate the entire run. The verification and screenshot scripts reject an obsolete oracle fingerprint. Report/test artifacts live under `docs/runs/`, outside the fine-tuning corpus.
