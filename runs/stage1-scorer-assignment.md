# Stage 1 scorer assignment

Registered by the Monkey (orchestrator), 2026-09-17, before any stage-1 run lane launches.

Stage 1 participant seats, per `runs/stage1-manifest.tsv`: `gpt-5.6-luna` and `grok-4.6`. Neither
seat may score its own or the other participant's runs, per the standing rule that a seat which ran
no cell of the stage does the scoring.

**Scorer: `gpt-5.6-sol`.** This seat runs no stage-1 review cell in `stage1-manifest.tsv`. It is a
Codex-pool seat, a different provider pool from grok (xAI) and a different individual seat from
gpt-5.6-luna, so it did not see any run's output before scoring and carries no participant bias.

The originally proposed scorer, `gpt-5.5`, has no row in the estate's launch ledger and is not in
service, per `README.md`'s own re-registration note. This assignment replaces it.

Scoring lanes read only the rubric (`rubric/scoring-rubric.md`) and the answer key
(`keys/answer-key-A1-tier0.md`), plus the run reports they score. They never read the reviewer briefs
(`briefs/`) before scoring, so scoring is blind to which condition (B0/B+/B-) produced which report
unless the report itself discloses it.
