DONE — cold artifact-only adversarial review completed

## Scope and evidence boundary

PROVEN: The supplied artifact is the only evidence used. It reports a run at frozen commit `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`, but the artifact alone does not independently prove that commit identity or any live repository state.

## Route 2 controls

PROVEN: The artifact records one Bash event with no receipt and a failed verdict (`HOOK_MISSING_PRE_TOOL_USE`), one Bash event with a matching receipt and an accepted verdict, one receipt with a different observed digest and a failed verdict (`HOOK_SHA256_MISMATCH`), and a no-Bash control with `not_applicable`.

PROVEN: The reported expected digest is `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`; the swapped-script control reports observed digest `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6`, so the artifact supports rejection of that tested digest mismatch.

UNKNOWN: The report says four Route 2 controls “passed,” but only one control is an accepted terminal turn; two are expected failures and one is `not_applicable`. This may be a test-suite pass count rather than four accepted turns, but the artifact does not define the counting convention.

## Two-Bash-call requirement

UNKNOWN: The artifact contains no recorded control with two Bash identifiers and only one receipt. Route 2a records one Bash identifier and one receipt; Route 2b records one Bash identifier and no receipts. Therefore the evidence does not establish the claimed every-Bash-identifier invariant for a turn containing two Bash calls.

UNKNOWN: The code excerpt at lines 147–175 shows a matcher that iterates observed Bash identifiers and looks for a missing receipt, which is consistent with per-identifier checking. However, the artifact does not show the two-call execution, the complete receipt-ingestion path, or a replayable output demonstrating that a second Bash identifier cannot be omitted or merged.

## Forged receipts and stream independence

PROVEN: The artifact reports three forged receipts tried and zero accepted, and it shows that receipts whose identifiers were not in the stream set were counted as rejected in the displayed verdict.

UNKNOWN: The displayed forgery verdict nevertheless has `bashEventIds:["bash-from-independent-stream"]` and `receiptEventIds:["bash-from-independent-stream"]`, while the narrative says the first forged receipt named an identifier from outside the hook and the third named an absent stream identifier. The artifact does not expose the exact stream input or nonce-validation implementation, so it cannot establish from this record alone why that identifier appears in the independent Bash set or whether all three forgery classes were independently rejected before matching.

ASSUMED: The prose labels the first forged receipt a replay and the second stale-nonce, but the artifact does not provide the previously accepted receipt, nonce state transition, or a direct rejection reason for each individual forgery. Those labels are accepted as the report’s characterization, not independently verified facts.

## Launch-path coverage

PROVEN: The artifact explicitly discloses one-process/one-terminal-turn coverage and identifies three other paths as uncovered: warm engine, conductor, and roundtable. It also says the live lane launcher and destructive-git guard were not tested or wired.

SUPPORTED: The report’s conclusion that the uncovered paths must not be treated as supervised follows from its explicit coverage disclosure. This is a limitation disclosure, not a false green.

## Digest path and live-file claims

PROVEN: The artifact reports identical starting and final SHA-256 values for the settings file and destructive-git hook, and separately reports a byte-different hook digest being rejected against the expected digest in the swapped-script control.

UNKNOWN: The artifact does not prove that the digest was computed from the actual hook file at every relevant launch path, nor that an attacker cannot arrange for a different script to produce the expected digest. It only supports the tested byte-different-copy control and explicitly says the live destructive-git guard was not tested.

## Test and final-state claims

PROVEN: The artifact reports 1,532 tests passed and 0 failed across the listed runs, while also reporting a nonzero root command status because conductor branch coverage was 82.87% against an 83% threshold. The focused supervisor run is reported as 5/5 and the TypeScript check as passing.

UNKNOWN: Those test counts, commit identity, remote branch state, file counts, and cleanup claims are not independently verifiable under the supplied-artifact-only evidence rule. They are accurately disclosed as reported results, not independently established results.

## Build and resource gate

No Lean build was started: this was a read-only artifact review with no Lean-file change. Lean worker processes: 0. Clang worker processes: 0. `command -v lake` printed `/home/monkey/bin/lake`.

## UNVERIFIED

The two-Bash-call/one-receipt case is untested in the supplied evidence.

The complete receipt-ingestion, nonce, and socket validation behavior is not shown.

The three uncovered launch paths, Fable lane launcher, live destructive-git guard, and `refuse` decision are explicitly untested.

The artifact does not independently establish the frozen commit, repository contents, test execution, remote branch, or cleanup state.

FINAL VERDICT: PARTIALLY SUPPORTED / MATERIAL LIMITATION. The artifact supports the reported single-Bash missing-receipt, matching-receipt, tested digest-mismatch, no-Bash, and stated coverage-limit outcomes. It does not support a conclusion that every Bash identifier is enforced in the required two-Bash-call case, and it does not establish live-path or live-guard coverage. No sentence was REFUTED solely for lack of evidence; unresolved claims are labeled UNKNOWN.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "PARTIALLY SUPPORTED — MATERIAL LIMITATION"
