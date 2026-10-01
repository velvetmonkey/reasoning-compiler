DONE — artifact-only adversarial review completed

## A1 — evidence review

PROVEN: The supplied raw outputs support the four Route 2 outcomes. The unregistered control has one Bash event and no receipt, with `terminal_status":"failed"` and `HOOK_MISSING_PRE_TOOL_USE` (artifact lines 3–21). The registered control has matching Bash and receipt identifiers, the expected digest, and `terminal_status":"accepted"` (25–40). The swapped control fails with `HOOK_SHA256_MISMATCH` and the altered digest, while the no-Bash control is `not_applicable` (42–77). Thus “4 controls passing” is supported, provided “passing” means the controls produced their intended outcomes, not that all four were accepted.

PROVEN: Route 3a’s quoted matcher code shows that receipt identifiers absent from the observed Bash set are deleted and counted as rejected, and that acceptance requires every observed Bash identifier to have a receipt whose digest matches the expected digest (artifact lines 79–138). Route 3b reports three forgeries tried, zero accepted, and three rejected (140–163). The terminal verdict being `accepted` in that output is not a false green: it is accompanied by the legitimate `bash-from-independent-stream` event and `rejected_receipts:3`; the report separately and correctly states zero forged receipts accepted.

PROVEN: The report accurately bounds coverage. It identifies four launch paths, says the implementation covers only the one-process lane shape, and explicitly marks the warm engine, conductor, and roundtable paths uncovered (165–201). The UNVERIFIED section repeats that the live launcher and those paths remain unsupervised, that the live destructive-git guard was not tested, that Fable and `refuse` were not tested, and that no deployment state was measured (285–307). These are disclosed limitations, not refuted claims.

TESTED: The focused supervisor run is reported as 5/5, and the component totals sum correctly: 1,436 + 24 + 72 = 1,532 (artifact lines 235–255). The report also discloses that the root `npm test` command returned nonzero because conductor branch coverage was 82.87% against an 83% threshold (247–251, 305, 335–339). “Tests failed: 0” is therefore supportable only as test-case failures, not as a claim that the root test command succeeded; the report makes that distinction.

TESTED: The identical before/after SHA-256 values for the two live files support the narrower claim that those files were unchanged during the measured interval (203–233). The required-file list and counts support five added and zero changed files within the report’s stated scope (257–283).

ASSUMED: The assertion that the receipt handler “cannot add” a Bash identifier to the independent stream set is a design inference from the displayed stream-observation and matcher excerpts, not a complete proof of every mutation path in the omitted implementation. The artifact gives no handler implementation or complete call graph. This does not invalidate the separately reported forgery result, but the architectural impossibility wording should be read as bounded by the shown code.

UNKNOWN: The artifact alone cannot independently establish the claimed remote-branch existence, pushed SHA, exact launch-path inventory, live-file measurements, or that the listed five files are the complete diff. It also cannot establish behavior outside the exercised controls or deployment behavior. The report appropriately presents most of these as measurements or limitations rather than as proof of production coverage.

No claim is REFUTED by the supplied evidence. The evidence supports a successful isolated prototype/control result with digest, missing-hook, no-Bash, and forgery-negative behavior. It does not support a conclusion that the live system is supervised across all launch paths, that the live destructive-git guard is integrated, or that the repository gate passed: the report itself records those limits and the nonzero coverage-gate status.

## UNVERIFIED

No repository, frozen subject, source outside the supplied artifact, answer key, rubric, network, live service, model, product control, or sibling report was accessed. No independent reproduction was possible under the tier-0 artifact-only constraint. The premise check returned 0 and the supplied artifact was nonempty.

No Lean build was started; Lean workers: 0; clang workers: 0. `command -v lake` printed `/home/monkey/.elan/bin/lake`. This was a read-only artifact review and did not require a build.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "BOUNDED SUPPORT; NO REFUTED CLAIMS"
