DONE — cold artifact-only review completed

## Scope and evidence

The supplied report is the sole evidence corpus. Its bundled SHA-256 is
`d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`, and
`FROZEN_SHA` names subject SHA `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
No repository, answer key, live service, network, or launcher was consulted.

## ROUTE 2 — isolated hook controls

- **PROVEN (within the supplied transcript):** The four reported control outcomes are mutually consistent with the stated expected behavior: missing registration produces `failed` with `HOOK_MISSING_PRE_TOOL_USE`; registration produces `accepted`; a different hook digest produces `failed` with `HOOK_SHA256_MISMATCH`; and no Bash event produces `not_applicable`.
- **PROVEN (within the supplied transcript):** The registered-control verdict has the same Bash and receipt event identifier, zero rejected receipts, and the expected hook digest. The swapped-control verdict records the differing observed digest.
- **UNKNOWN:** The prose claims about receipt-before-hook-return and the exact isolated-settings setup are not independently replayable from this artifact because the control code, settings, and timing trace are absent. This is an evidence limitation, not a contradiction.

## ROUTE 3 — stream separation and forgery controls

- **PROVEN (as a reported result):** The shown supervisor excerpt derives `bashEventIds` from observed stream events and separately filters receipts whose event IDs are absent from that set. The shown verdicts are consistent with that matcher design.
- **UNKNOWN:** The claim that the receipt handler cannot add an identifier to the independent stream set is not fully established by the excerpt: the handler implementation and the full event-ingestion boundary are not supplied.
- **UNKNOWN:** `FORGERIES_ACCEPTED 0` is asserted, but the artifact gives no per-forgery acceptance trace or control implementation. The final verdict shows `rejected_receipts: 3`, which is consistent with the assertion but does not independently prove how the count was computed.
- **UNKNOWN:** The replay, stale-nonce, and absent-event descriptions are labels attached to three emitted JSON lines; the artifact does not expose the nonce ledger or the prior accepted receipt needed to verify those labels independently.

## ROUTE 1 — launch-path coverage

- **PROVEN (bounded scope):** The report identifies four launch paths and explicitly says the implemented control was built for `/home/monkey/bin/lanelaunch:278`, while the warm engine, conductor, and roundtable paths were not adapted. The arithmetic and the disclosed “other 3 launch paths” limitation agree.
- **PROVEN:** The report does not claim supervision for the three uncovered paths; this is an accurately disclosed coverage limit rather than a false green.
- **UNKNOWN:** Whether the cited files and line numbers actually contain the described launch paths cannot be checked from the supplied report alone.

## ROUTE 4 — integrity, tests, and scope

- **PROVEN (reported measurements):** The starting and final digests printed for each of the two live files are identical. The reported test arithmetic is consistent: 1,436 + 24 + 72 = 1,532, and the focused run is 5/5.
- **PROVEN:** The report accurately discloses that the root test command remained nonzero because conductor branch coverage was 82.87% against an 83% threshold; it does not present the 1,532 passed tests as a fully green root gate.
- **UNKNOWN:** Equal SHA-256 strings support unchanged content but, from this artifact alone, do not mathematically prove byte identity or prove that the measurements were taken against the intended live files.
- **UNKNOWN:** The claims that the remote branch exists at the pushed SHA, that exactly five files were added, and that the named scratch directories were deleted are final-state assertions without remote or filesystem evidence in the bundle.

## BUILD / RESOURCE CHECK

No Lean build was started: this was a restricted artifact-only review and no source tree was accessed. Lean worker processes: 0. Clang worker processes: 0. `command -v lake` printed `/home/monkey/bin/lake`. No suite or repository gate was run because doing so would violate the granted evidence boundary.

## UNVERIFIED

The report itself identifies these unverified or uncovered matters: live lane-launcher wiring; warm-engine, conductor, and roundtable supervision; the live destructive-git guard; Fable execution; `refuse` decisions; deployment state; and satisfaction of the root repository gate. In addition, this review cannot independently verify the omitted control implementations, settings, nonce handling, timing/order guarantees, or final remote/filesystem state.

## FINAL VERDICT

The evidence supports a bounded conclusion: the report presents internally consistent results for the four isolated Route 2 outcomes, the shown matcher logic, the stated test arithmetic, and the stated coverage limitations. It does not support extending those results to the live launcher, the three other launch paths, the live destructive-git guard, deployment, or the full forgery-security claim. Those matters remain UNKNOWN, not REFUTED. No claim was REFUTED because the artifact contains no direct contradiction that can be replayed from the artifact alone.

state AT-GATE, repo reasoning-compiler, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "BOUNDED SUPPORT; LIMITATIONS DISCLOSED", run_id "rc1-B0-gpt-5.6-luna-2", confirmed no access outside /home/monkey/scratch/rc1-B0-luna-2-bundle

LANEOWED: RESOLVED RESOLVED: run complete, verdict BOUNDED SUPPORT/LIMITATIONS DISCLOSED, no REFUTED claim found (differs from run 1's REFUTED on the same corpus, genuine within-seat variance, exactly what k=5 exists to measure). Committing to reasoning-compiler runs/stage1/. (2026-09-17T16:46:54+01:00)
