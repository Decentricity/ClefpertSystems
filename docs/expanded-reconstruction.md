# Phase 2: expanded executable reconstruction

The frozen prototype establishes the reasoning chain. `knowledge_base/esc1.pl` expands it to 223 documented facts, 13 cement processes, seven pollutants and twenty environmental components. It supports five executable query workflows:

- `assess`: source process → pollutant → direct and indirect impacts → numerical priority and process mitigation, plus contextual social effects.
- `assess_concentration`: documented concentration ranges resolve magnitude before executing the same forward chain. H2S's four bands come from IV-7 Figure 4.3; SO2's example band comes from IV-8. Physical units remain unspecified.
- `trace_back`: environmental component → candidate pollutants → possible source processes and directed indirect pathways. Candidates do not prove causation.
- `instrumentation`: compare an observation to the documented method's detection limit, retaining units and variability.
- `method_assessment`: twenty Warner–Preston criteria and four aspect grades using fixed documented answers, explicit user answers and observed-session counts.

Additional emissions use Table 5.1 V-6–V-7; additional direct importance values use V-2–V-3; directed environmental links use Table 5.2 V-8–V-10; aligned social-effect rows use Table 5.1 V-4–V-6; Migration consequences use Table 5.3 V-10–V-11; mitigation recommendations use Table 5.4 V-16–V-17. Selected pages were visually checked. Misaligned or ambiguous rows are excluded. Printed spelling is preserved, including `MicroFlora` versus `Microflora`.

The expanded model follows the documented workflow families. It does **not** recover the entire original program, menus, historical datasets, user sessions or every datum in the thesis. In particular, only one complete observation-method example is available in this reconstruction, many social factors lack translated consequence text, and unselected table rows remain outside its scope. Unknown relations remain unresolved rather than becoming false.

The user authorized a coherent inferred reconstruction. Its domain assumptions are consequently enabled in the named POC profile and explicitly recorded under `A_*` in provenance.yaml. Product scores, action thresholds, maximum-score aggregation, interpretation of zero, bounded indirect propagation, concentration boundary conventions, detection-limit decisions, count-to-grade mappings and Warner–Preston aspect aggregation are inferred. The Warner–Preston implementation uses a complete synthetic assessment recipe; it is not the thesis's recovered code. No unsupported claim of historical exactness or permit/safe/unsafe classification is made.

The 223 facts are executable clauses in `documented_facts.pl`. The provenance registry attaches page/section evidence to each fact and assumption IDs to each inference rule. Neither registry prose nor chapter structure is a model input. Runtime introspection, not evidence-file parsing, supplies the state generator with valid processes, pollutants, components and query kinds.
