DONE — cold read-only adversarial review completed from the supplied artifact.

## Scope and evidence

PROVEN: The supplied report is the only evidence used. It records subject SHA `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`, and its final state repeats that SHA. No repository, sibling report, answer key, rubric, network, live service, launcher, model, or product control was accessed.

PROVEN: No Lean build was started; therefore it created 0 `lean` workers and 0 `clang` workers. With the required PATH export, `command -v lake` printed `/home/monkey/bin/lake`. No suite was run because this was a read-only artifact review.

PROVEN: The report records four Route 2 controls with four expected outcomes: unregistered Bash failed with `HOOK_MISSING_PRE_TOOL_USE`; registered Bash was accepted; a byte-different hook failed with `HOOK_SHA256_MISMATCH`; and no-Bash was `not_applicable`. The recorded expected digest is `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`, while the swapped-hook observed digest is `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6`.

PROVEN: The digest path demonstrated in the artifact rejects the swapped digest when the expected digest remains the original value. The before/after SHA-256 values for the live settings and live hook are identical, so the artifact records no live-file mutation.

## Bash receipt coverage

UNKNOWN: The conclusion that every Bash identifier requires a receipt is not demonstrated by the supplied evidence. Route 3a shows the matcher’s missing-receipt loop, but supplies no run containing two independent Bash identifiers and only one receipt. Its displayed Route 3b verdict contains one `bash_event_ids` entry and one matching `receipt_event_ids` entry; it therefore cannot serve as the requested two-versus-one test.

UNKNOWN: The statement “The receipt handler cannot add a Bash identifier to that stream set” is not independently established by the excerpt. The excerpt shows how `observeStreamLine` populates the set and how terminal matching consumes it, but does not show the receipt-handler implementation or a replayable two-Bash/one-receipt trace.

## Forgery and digest conclusions

PROVEN: The artifact records three forged receipts tried and zero counted as accepted, and records that the final terminal status was `accepted` with one stream Bash identifier, one receipt identifier, and `rejected_receipts: 3`.

UNKNOWN: “FORGERIES_ACCEPTED 0” does not by itself prove that no forged receipt influenced an accepted turn. The artifact does not identify which receipt was the legitimate receipt, show the complete stream for the turn, or give per-forgery accept/reject outcomes. In particular, the accepted verdict and the first forged event identifier (`bash-from-independent-stream`) cannot be reconciled from the displayed evidence alone.

UNKNOWN: The artifact does not establish that `expected_hook_sha256` was independently derived from the intended hook rather than supplied as configuration. It demonstrates rejection of one altered digest under the stated expected value, but does not prove that an attacker could not arrange for a different script digest to become the expected value.

## Coverage and test reporting

PROVEN: The report explicitly discloses that the warm engine, conductor, roundtable, and live lane-launcher paths were not covered, that the live destructive-git guard was not tested, that `refuse` was not tested, and that no deployment state was measured.

PROVEN: The report records 1,532 tests passed and zero failed, while also recording a nonzero root test status because conductor branch coverage was 82.87% against an 83% threshold. Thus the test counts must not be presented as a fully passing root gate.

UNKNOWN: The report names five added files and “files changed: 0,” but provides no independent diff or repository evidence in this tier-0 corpus. Those inventory claims are accepted as reported facts, not independently verified conclusions.

## UNVERIFIED

The two-Bash-calls/one-receipt behavior remains untested in the supplied artifact.

The receipt-handler boundary, nonce enforcement details, and the provenance of the expected digest remain unverified beyond the summarized control outputs.

The three uncovered launch paths and the live launcher remain unsupervised by the report’s own disclosure.

## Final verdict

TESTED: The artifact supports the narrow claim that the isolated Route 2 controls observed missing receipts and a wrong hook digest, and that no-Bash was treated as not applicable.

ASSUMED/UNKNOWN: It does not support a general conclusion that all Bash calls are receipt-covered or that the digest expectation is independently protected against substitution. The report is appropriately candid about its major path and live-wiring limitations, but its forgery summary is insufficient to establish the stronger security conclusion.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "NARROWLY SUPPORTED; MATERIAL COVERAGE UNKNOWN"
