# Current reference data

The executable expert system now includes **twelve current US EPA ambient-air reference rows**, alongside the approximate thesis reconstruction. The source is the [EPA NAAQS Table](https://www.epa.gov/criteria-air-pollutants/naaqs-table), last updated **4 November 2025**, retrieved **11 October 2026**. This is the current table available at retrieval, frozen under profile `us_epa_naaqs_2025`; it is not a claim that every underlying rule was issued in 2025 or that every historical dataset value has been updated.

The [source snapshot](evidence/current-standards-source.json) records the URL, response hash, table text and selected footnotes. The [transcription](evidence/current-standards-transcription.json) preserves each statistical form and its executable tag. [current_standards.pl](../knowledge_base/current_standards.pl) implements the reference rows and screening logic. Rule/source/assumption links are in [provenance.yaml](../knowledge_base/provenance.yaml).

| Standard | Reference level | Required supplied statistic |
| --- | --- | --- |
| CO primary, 8-hour | 9 ppm | Annual count of concentrations above the reference level: at most 1 |
| CO primary, 1-hour | 35 ppm | Annual count of concentrations above the reference level: at most 1 |
| Pb primary/secondary, rolling 3-month | 0.15 µg/m³ | Maximum arithmetic mean of 3 consecutive monthly means in a 3-year period |
| NO2 primary, 1-hour | 100 ppb | Annual 98th percentile of 1-hour daily maxima, averaged over 3 years |
| NO2 primary/secondary, annual | 53 ppb | Annual mean |
| O3 primary/secondary, 8-hour | 0.070 ppm | Annual fourth-highest daily maximum 8-hour concentration, averaged over 3 years |
| PM2.5 primary, annual | **9.0 µg/m³** | Annual mean, averaged over 3 years |
| PM2.5 secondary, annual | 15.0 µg/m³ | Annual mean, averaged over 3 years |
| PM2.5 primary/secondary, 24-hour | 35 µg/m³ | 98th percentile, averaged over 3 years |
| PM10 primary/secondary, 24-hour | 150 µg/m³ | Mean annual count of concentrations above the reference level over 3 years: at most 1 |
| SO2 primary, 1-hour | 75 ppb | Annual 99th percentile of 1-hour daily maxima, averaged over 3 years |
| SO2 secondary, annual | **10 ppb** | Annual mean, averaged over 3 years |

The annual secondary SO2 row reflects the 2024 rulemaking. EPA notes that the prior 3-hour secondary SO2 standard was not altered and that earlier standards and continuing implementation obligations can apply in some areas. Those additional obligations are outside this selected profile.

## Executable decisions

A `screen_ambient` query selects a profile and standard, declares `sampling_context: "ambient_air"`, and supplies a summary with:

- `statistic`: the exact executable tag listed in the transcription/domain;
- `value` and `unit`: the summary, not an arbitrary individual measurement;
- `reference_level` and `reference_unit`: the concentration threshold used to produce it;
- `data_status`: `complete`, `incomplete` or `unverified`.

For concentration statistics, `value` is the appropriate design-value-style summary. For the CO and PM10 frequency forms, `value` is the annual count or mean annual count, and `unit` is `count_per_year`. A concentration value alone cannot determine these frequency-based outcomes. The reference threshold guard rejects a count computed against the wrong concentration level.

If all guards pass, Prolog returns `within_reference` for a summary at or below the comparison limit and `exceeds_reference` above it. It returns `insufficient_data` for unknown profiles/standards, stack measurements, incomplete/unverified summaries, wrong statistical forms, wrong reference thresholds or incompatible units. Structurally invalid, negative, nonfinite or boolean numeric inputs are rejected.

The workflow accepts `ppm`/`ppb` conversions by volume and `ug/m3`/`mg/m3` mass conversions. It does not convert gas volume to mass without physical conditions. Annual CO counts must be integers; three-year mean PM10 counts may be fractional. Reference-level matching tolerates only conversion roundoff. Decision comparison uses the supplied numerical value without regulatory rounding.

This is a **screen of supplied summaries**, not a legal attainment determination. The POC does not compute percentiles from raw monitoring series, verify a user's completeness assertion, implement all regulatory rounding/exception rules, or establish source attribution. A complete summary must be prepared externally using the applicable monitoring procedures. These US ambient references do not establish Indonesian legal compliance and are not cement-kiln stack-emission limits.

## What is updated and what is retained

The twelve modern reference rows, their units, averaging periods and statistical forms are sourced from the current EPA table. The thesis-derived emission links, impact importance weights, indirect/social pathways, example instrument and Warner–Preston criteria remain historical evidence. POC score bands and methodology aggregation remain explicitly inferred. No modern standard is used to invent a replacement importance weight, convert the thesis's unspecified concentration units, or silently equate generic historical `Particulate` with a measured PM2.5 fraction.

Modern ambient results are a separate executable workflow in the same base Prolog system. They are not injected into historical forward/session magnitude scores. This keeps the decisions scientifically interpretable without pretending that a newly sourced concentration standard reconstructs a lost score calibration.

## Refresh and regenerate

```sh
python scripts/fetch_current_standards.py --output /tmp/current-standards-review.json
python scripts/run_oracle.py --input examples/current_ambient.json
python scripts/generate_cases.py
```

The fetcher only produces review evidence. To update a frozen profile, review the live table and footnotes, add a new versioned profile/source record, update tests, and regenerate all oracle-labeled records and exports. No network call participates in dataset labeling; the checked-in executable rules produce every target.

All concentrations, counts and missing-data variants in the corpus are synthetic. Current standards are reference data, not an invented monitoring dataset. Unit variants, protection classes and averaging/statistic variants are grouped by pollutant family with relevant historical cases; PM2.5/PM10 share the historical particulate family. This prevents near-identical values and conversions leaking across splits.
