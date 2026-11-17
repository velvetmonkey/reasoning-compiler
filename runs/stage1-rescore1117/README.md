# Stage 1 blind re-score (rescore1117, 2026-11-17)

Non-author blind re-score of the 30 stage-1 manifest reports (A1, tier 0), made after the provisional unblinded score of 2026-10-18.

- Scorer: one fresh Claude Opus 5.5 session (not the A1 author, ran no stage-1 cell). It received only `scorer-prompt.md`, the rubric, the answer key, the frozen artifact (sha256 d3e7d4fb...), FROZEN_SHA, the 30 blinded reports from `runs/stage1-blind/` at bfbe87d, and a checkout of the frozen subject at f23d8af (used only to run the key's own replays and to adjudicate REFUTED targets as rubric item 3 requires; never for recall credit). It did not receive the blind map, the synthesis, the plan, or arm and seat names.
- `scorer-out/`: everything the scorer wrote (scores keyed by blind id, per-report detail, replays, adjudications, log).
- `unblind.py`: joins the blind scores to `keys/stage1-blind-map.tsv` after scoring was locked, and compares with `provisional.tsv`.
- `provisional.tsv`: per-run provisional numbers transcribed from the 2026-10-18 synthesis (sections 2.1 and 3.4). Per-run REFUTED counts are reconstructed from that report's list of REFUTED verdicts.
- `unblinded-table.md`, `unblinded-runs.tsv`: results.

Known limits: the blinded bundle still carries some pointer wording and two coordinator footers (the scorer was told to ignore them); no second double-scorer was run (rubric item 5 not satisfied); the scorer used node v22.23.3 instead of v22.22.3.
