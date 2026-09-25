DONE — cold review completed from the supplied artifact only.

## ROUTE 2 controls

PROVEN: The artifact records four controls, with the registered control accepted, the missing-hook control failed for `HOOK_MISSING_PRE_TOOL_USE`, the swapped-digest control failed for `HOOK_SHA256_MISMATCH`, and the no-Bash control marked `not_applicable`. The stated count of four controls and four passing control outcomes is supported if “passing” means each control produced its intended control outcome, not that each terminal status was accepted.

## ROUTE 3a stream separation

PROVEN: The quoted `observeStreamLine` and terminal-matcher excerpts show Bash identifiers are collected from the independent stream, unmatched receipt identifiers are deleted and counted, and terminal acceptance requires a receipt for every observed Bash event plus the expected hook digest.

## ROUTE 3b forgery control

REFUTED: “FORGERIES_ACCEPTED 0” and “The first forged receipt replayed an already accepted receipt” are not supported by the displayed verdict as a whole. The verdict is `terminal_status":"accepted"`, its `bash_event_ids` contains `bash-from-independent-stream`, and its `receipt_event_ids` contains that same identifier—the identifier presented in the first `FORGED` record. The artifact does not explain how that matching forged record was excluded while the terminal was accepted. The claimed zero therefore conflicts with the observable terminal verdict, or at minimum uses an undefined acceptance metric.

Read-only replay from the supplied artifact:

```bash
awk '/^FORGED / || /^FORGERIES_/ || /^VERDICT / { print }' /home/monkey/reasoning-compiler-freeze/hookcanary-report.md
```

Expected output includes `FORGERIES_ACCEPTED 0` followed by a verdict containing `terminal_status":"accepted"` and matching `bash-from-independent-stream` entries in both event-id arrays.

UNKNOWN: Whether the replay, stale nonce, and absent-stream forgeries were individually rejected is not demonstrated by separate outcomes; only aggregate counters and the final verdict are shown.

## ROUTE 1 coverage

PROVEN: The report identifies four launch paths and explicitly says the supervisor was built only for the one-process/one-terminal-turn shape, leaving warm engine, conductor, and roundtable paths uncovered. The report does not claim those paths are supervised.

UNKNOWN: The artifact alone cannot independently verify that the four listed paths are exhaustive or that the cited source locations contain the described code.

## ROUTE 4 integrity and tests

PROVEN: The artifact reports equal starting and final SHA-256 values for both named live files, 1,532 passing tests and zero failed tests, a nonzero root command caused by the 83% conductor branch threshold versus 82.87%, and a focused supervisor run of 5/5.

ASSUMED: The statements that five files are “REQUIRED” and that the listed five files are exactly the files added are assertions in the artifact, not independently verifiable from this tier-0 evidence.

UNKNOWN: The artifact does not independently establish the repository state, pushed branch state, deployment state, cleanup completeness, test command provenance, or whether the reported source excerpts match the frozen repository.

## FINAL VERDICT

The report supports the registered/missing/digest/no-Bash control outcomes, the stated explicit coverage limitations, the live-file digest comparison, and the disclosed test/coverage result. It does not support an unqualified claim that all three forgery attempts were rejected: the displayed forgery verdict materially conflicts with that claim. The final conclusions are therefore only partially supported, with the forgery-control conclusion REFUTED and the external-state/repository assertions UNKNOWN or ASSUMED as labeled.

## UNVERIFIED

The frozen repository, source files, test executions, socket behavior, launch-path exhaustiveness, live wiring, cleanup, branch/remote state, and deployment state were not accessed or independently verified, per the cold-review restriction.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "PARTIAL — forgery conclusion REFUTED; remaining conclusions labeled"
