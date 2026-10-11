# Phase 1: small executable prototype

`knowledge_base/prototype.pl` and `prototype_facts.pl` form a frozen starting point: four cement processes, seven pollutants, documented direct-impact importance values, three indirect links, a social pathway and process mitigations. There is no text-summary query API.

```sh
swipl -q -s knowledge_base/prototype.pl -g prototype:demo -t halt
swipl -q -s tests/test_prototype.pl -g run_tests -t halt
```

Input selects source processes, one pollutant, a supplied magnitude [0,10] and present receptors. Prolog joins the source and impact facts, calculates direct scores, follows up to two indirect hops, and recommends process mitigation. Zero exposure, unknown relations and high-priority effects lead to different decisions.

The magnitude-to-importance product, priority cutoffs (10 and 40), action categories, maximum-score aggregation, two-hop propagation and missing-data decision are explicitly approximate POC choices. No original source recovery or regulatory decision is claimed. The broader `esc1.pl` reconstruction expands this starting point before dataset translation.
