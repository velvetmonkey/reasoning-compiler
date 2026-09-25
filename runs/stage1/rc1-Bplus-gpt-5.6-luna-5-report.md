DONE — the supplied artifact supports the ordinary controls but does not support a clean anti-forgery conclusion.

## Evidence scope

This review used only `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md`. No repository, answer key, rubric, sibling report, network, live service, launcher, model, or product control was accessed.

## Route 2 controls

- PROVEN: The unregistered-settings control reports `HOOK_MISSING_PRE_TOOL_USE`, with one Bash event and no receipt.
- PROVEN: The registered-hook control reports `accepted`, with the same Bash and receipt event ID and the expected hook digest.
- PROVEN: The swapped-script control reports `HOOK_SHA256_MISMATCH` while preserving the expected digest as the supervisor's reference.
- PROVEN: The no-Bash control reports `not_applicable` with empty Bash and receipt sets.

These are four useful behavioral observations, but they establish behavior of the isolated control setup, not of every production launch path.

## Nonce and forgery claim

- UNKNOWN: The report says the supervisor owns a nonce and prints nonce fields in receipts, but it does not show where the nonce is generated, how the hook obtains it, whether it is bound to the current turn, or whether the supervisor validates it. The supplied code excerpt for terminal matching checks event IDs and `hook_sha256`; it contains no nonce check.
- REFUTED: The exact claim `FORGERIES_ACCEPTED 0` / `COUNT of forged receipts accepted: 0` is not sufficient to establish that the three forgeries could not produce an accepted terminal result. In the same raw output, the forged-receipt run says `terminal_status":"accepted"`, with `bash-event-ids:["bash-from-independent-stream"]` and `receipt-event-ids:["bash-from-independent-stream"]`; that identifier is supplied by the forged receipt in the displayed input. The terminal matcher therefore has an accepted-looking matching pair despite the forgery counter.
- UNKNOWN: The artifact does not explain whether `FORGERIES_ACCEPTED 0` counts socket-level acknowledgements, a separate control's classification, or terminal verdicts. Until that accounting is reconciled, the anti-forgery conclusion is unsupported.

Read-only replay from the supplied artifact:

```sh
awk '/FORGERIES_TRIED 3/{a=1} a && /FORGERIES_ACCEPTED|VERDICT/{print}' /home/monkey/reasoning-compiler-freeze/hookcanary-report.md
```

Expected output includes `FORGERIES_ACCEPTED 0` followed by a `VERDICT` containing `"terminal_status":"accepted"`, `"bashEventIds":["bash-from-independent-stream"]`, and `"receipt_event_ids":["bash-from-independent-stream"]` (the artifact uses `bash_event_ids` and `receipt_event_ids` in its displayed JSON).

## Coverage and test conclusions

- PROVEN: The report explicitly limits implementation coverage to one-process/one-terminal-turn launch shape and names three uncovered paths: warm engine, conductor, and roundtable. It also explicitly says the live lane launcher and destructive-git guard were not tested.
- PROVEN: The report records 1,532 tests passed and 0 failed in the rerun, while also recording a nonzero root status because conductor branch coverage was 82.87% against an 83% threshold. The focused supervisor run is reported as 5/5.
- ASSUMED/UNKNOWN: The report's statements that the listed files are `REQUIRED`, that the remote branch exists at the frozen SHA, and that the isolated controls correspond to the intended production behavior are assertions of the report, not independently demonstrated by this artifact-only review.
- PROVEN: The report discloses the three uncovered launch paths, live wiring limits, refusal-decision limit, nonzero root status, and no deployment measurement. These are accurately disclosed limitations, not false greens.

## UNVERIFIED

Nonce generation, nonce secrecy, nonce freshness, nonce validation, and nonce-to-turn binding are unverified. The source of the nonce and the identity of the process that can read or submit it are not shown. The artifact does not reconcile the zero-forgery counter with the accepted terminal verdict, so it does not establish that possession or replay of a receipt cannot create a false green. Production behavior on the warm engine, conductor, roundtable, lane launcher, and live destructive-git guard remains unverified.

No Lean build was started: this was a read-only artifact review. Lean workers: 0; clang workers: 0. `command -v lake` was not run because the registered brief restricts local commands to reading the supplied artifact.

Final verdict: REQUEST CHANGES. The ordinary hook controls are supported, but the anti-forgery/nonce conclusion is not supported and the displayed forged receipt appears capable of satisfying the terminal matcher.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "REQUEST CHANGES"
