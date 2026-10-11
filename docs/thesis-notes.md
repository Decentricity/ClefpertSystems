# Thesis extraction notes

These are source-review notes, not training data. The current executable reconstruction is described in [expanded-reconstruction.md](expanded-reconstruction.md); the initial 44-clause inventory below is retained as the first extraction stage.

Inspected 2026-10-11: public cover, Chapters I–VIII, and bibliography, via the ITB record linked in README. Source identity: **Pandu Wisaksono Sastrowardoyo**, NIM 15303001; title “Penggunaan Penilaian Metoda Dampak Warner-Preston dalam Program Komputer Sistem Pakar Analisa Dampak Industri Semen.” The cover (PDF page 1) explicitly dates the thesis 2008 and its approval sheet (PDF page 2) is dated 25 June 2008; the record's publication-year field is blank. Do not treat the 2017 catalog input date as publication date. Chapter PDFs/hashes are inventoried in `docs/evidence/source-manifest.json`. Selected transcriptions and stable evidence IDs are in `docs/evidence/excerpts.json` and `knowledge_base/provenance.yaml`.

References below give printed chapter page and section; PDF page is the numeric suffix within that chapter file (e.g. VI.4 = BAB6 PDF page 4). The first pages have no printed number; their label is supplied by this convention. Figure captions/table alignment in BAB5 pages 2–3 and BAB6 pages 11–14 were visually checked.

## Architecture and decision flow

- I.1–I.2, pp. I-1–I-2: goal is a Warner–Preston module for ESC-1, attributed to Priana Sudjono (1993). This is support for preparing an AMDAL report, not generation of a whole report.
- IV.1–IV.3, pp. IV-1–IV-5: ESC-1 combines Leopold and Sorensen, uses a shared fact database, semantic networks and topical knowledge trees. DOS text menus allow forward inspection from production processes or backward inspection from impacts. Facts include environment/public health, cement processes, pollutants/standards, mitigation, and assessment methodology; relations connect processes/pollutants, pollutant/environment impacts with importance, process/mitigation, and indirect impacts.
- IV.3, p. IV-5 (`ARCH`): methodology questions are added after analysis branches. IV.7, p. IV-20: mitigation is displayed at the end of a session, even though the process is known earlier.
- VII.1, p. VII.1: ESC-2 consolidates the KB with new search/UI in VisualProlog. Lists and display procedures bridge dialect/UI behavior; these descriptions do not recover complete executable source.
- VII.2, p. VII.5: user chooses observation technique and enters concentration, temperature or pH; program determines magnitude, instrument detection/accuracy, affected components/importance, processes and mitigation. A running message report ends with Warner–Preston values.
- VIII, pp. VIII-1–VIII-3 (`ESC2`): the resulting program is ESC-2. Strategies are explicit questions, observed interaction, added knowledge bases, and fixed answers. The historical ESC-1 source is not supplied by these passages.

## Warner–Preston inventory

II.3, p. II-16 describes comparison of 17 methodologies using four aspects. VI.1, pp. VI.1–VI.3, Tables 6.1–6.4 provides twenty criterion questions. Every row below has its own `CR_<NAME>` and `CR_<NAME>_IMPL` evidence IDs.

| Aspect | Criterion (dataset identifier) | Question meaning | Implementation evidence |
|---|---|---|---|
| Identification | comprehensiveness | All impacts considered? | VI.4: accumulate analyzed impacts; conversion thresholds absent |
| Identification | specificity | Parameters sufficiently specific? | VI.4: component/impact count comparison; exact formula/thresholds absent |
| Identification | impact_isolation | Project impact identification techniques suggested? | VI.5: explicit question |
| Identification | time_consideration | Construction and operation distinguished? | VI.5: activity stage database, count stage-defined activities; database/thresholds absent |
| Identification | data_sources | Sources identified? | VI.5: always yes, explicitly L |
| Measurement | explicit_indicators | Specific measurable indicators suggested? | VI.6: explicit question |
| Measurement | magnitude | Impact numbers required? | VI.6: prose says always yes/L; Table 6.6 instead names instrumentation database |
| Measurement | objectivity | Objective measurements emphasized? | VI.6: added observation/instrument accuracy database; score mapping absent |
| Interpretation | significance | Local/regional/national importance assessed? | VI.7: explicit question |
| Interpretation | explicit_criteria | Criteria/assumptions stated? | VI.7: added activity-linked criteria/assumptions counts |
| Interpretation | uncertainty | Projection uncertainty considered? | VI.7: always yes |
| Interpretation | risk | Low-probability/high-damage impacts considered? | VI.7: accumulated impact magnitude; thresholds absent |
| Interpretation | alternatives | Alternatives compared? | VI.8 Table 6.7: number offered |
| Interpretation | aggregation | Measurement/interpretation information aggregated? | VI.7–VI.8: always yes, ESC-2 summary |
| Interpretation | public_involvement | Public interpretation input possible? | VI.8: always no in ESC-1/ESC-2 |
| Communication | affected_groups | Most affected human groups identified? | VI.9: always no |
| Communication | environmental_setting | Clear environmental setting description? | VI.9–VI.10: analyzed component count |
| Communication | summary_format | Recommended summary format? | VI.9: always yes, ESC-2 summary |
| Communication | key_issues | Main impacts highlighted? | VI.9–VI.10: most frequently reported impacts; thresholds absent |
| Communication | nepa_conformity | NEPA standards followed? | VI.9: always yes according to author; not independent certification |

VI.4 (`WP_PAIR`) explicitly states **L** = highest / “sangat baik”, **S** = moderate / “kurang sesuai”, **N** = low / “tidak sesuai standar”: two yes answers give L, one yes gives S, two no give N. It refers to “both questions” despite the inventory having 5/3/7/5 criteria. No pairing or component aggregation is recovered. Implement only an anonymous two-answer truth table, and preserve the ambiguity. Fixed yes/no answers are not automatically converted to L/N. The magnitude prose/table conflict is recorded; the fixed-L query follows the explicit prose only.

VI.10 (`WP_OUTPUT`) says the report contains scores for each aspect and its supporting criteria; the diagrams on VI.11–VI.14 show relationships but no arithmetic thresholds. The introductory text swaps the order of Figures 6.1 and 6.2 relative to their captions: captions identify 6.1 as measurement, 6.2 as identification. No overall permit/deny or safe/unsafe category is documented in this subset.

## Executable evidence selected

IV.4.4.1, IV-8: `standard("SO2",0,40.0,2.0).` stores two concentration bounds and magnitude. Units and interval boundary behavior are not established by the snippet; support a fact lookup, not concentration classification.

IV.4.4.2.1, IV-10–IV-11: importance scale 1.0–10.0 (`IMPORTANCE_SCALE`); `impact("Particulate","Land Animals Reptiles","2.0").` prints importance as a string. Table 5.1 independently gives numeric 2.0 for the same pair; the translation uses the table's numeric representation.

V.2, V-1, Table 5.1, V-2–V-3: the author says original ESC-1 supplied affected component, impacting component, data and importance; explanations were added. This POC selects **24** individual importance relations: Surface Water (2), Shrubs (3), Microflora (5), Endangered Species of Flora (6), Birds (4; split over the page break), Land Animals Reptiles (4). Each has an individual `T5_01`–`T5_24` transcription, page and row. Unselected rows remain outside the KB. Group labels and pollutant spellings are not silently aliased. These values are historical transcriptions, not current environmental standards.

IV.4.4.2.2, IV-13: `impact_se("Blasting and Drilling","Migration",1.0).`

IV.5, IV-15: `indirect_impact("Water Temperature","Microflora").` and `indirect_impact("Gasses and Particulate","Health and Safety").` Only these directed edges are translated; no inverse/transitive closure is assumed.

IV.6, IV-18: `soc_ec("Migration","changes in demand on health and social services").`

IV.7, IV-20: `mitigation("Product Storage","Mimimise rainfall allowed to percolate through piles of lime stone area and runoff in uncontrolled fashion").` Preserve the printed “Mimimise” spelling, normalizing only the line break to one space.

VI.2, VI.15–VI.17: `method/4` fields are pollutant, technique, minimum detection, and repeat-experiment variability; `unit/2` connects pollutant to measurement unit. Examples: `method("Suspended solid","Non-filterable residue by drying oven",4.0,5.8).` and `unit("Suspended solid"," mg per liter").` The lower-case `solid` and leading unit space are preserved. Do not infer a standard-deviation interpretation or an instrument score from variability.

Initial executable domain subset: **44 clauses** (24 table relations, 8 code-example facts, 8 fixed criterion answers, 4 scoring combinations), plus a twenty-criterion metadata inventory. It is deliberately incomplete.

III.1–III.3, pp. III-1–III-3 describes KB review, search algorithm review, UI design, consolidation and verification; Warner–Preston is schematized as tables/diagrams and adapted to the existing architecture. Historical dates are inconsistent: III.2 (III-2) refers to environmental data from 1994, while V.1 (V-1) refers to data current in 1992. Preserve this discrepancy rather than assign a single recovered KB version.

## Unresolved work

Complete original/updated rule databases, activity-stage mappings, observation accuracy/scoring mappings, count-to-N/S/L conversions, criterion question pairing, aspect aggregation, and concentration interval semantics remain unresolved. Full diagrams and remaining tables can expand the evidence inventory after individual visual verification. No inference about missing decisions is warranted merely from having downloaded all chapters.
