DONE — cold read-only review completed from the supplied artifact.

## Route 2 controls

PROVEN: The artifact supports the four reported Route 2 outcomes at the level of the captured outputs: the unregistered control reports `HOOK_MISSING_PRE_TOOL_USE`; the registered control reports `accepted` with matching Bash and receipt event IDs and the expected hook digest; the swapped control reports `HOOK_SHA256_MISMATCH`; and the no-Bash control reports `not_applicable`. The reported count is four controls run and four passing.

The evidence proves those captured supervisor outcomes, not that the live settings or live destructive-git hook used the same registration. The artifact explicitly discloses that the controls used isolated settings and a new branch receipt hook.

## Nonce and forgery claim

UNKNOWN: The artifact does not establish where the nonce comes from, who can read it, how it is bound to a particular hook invocation, or whether the supervisor validates it. Nonce strings appear in receipt records, and Route 4d says the supervisor owns a nonce, but ownership and logging are not evidence of generation or authentication. Therefore possession of a nonce is not shown to establish that the intended hook fired.

UNKNOWN: Route 3b reports three external forgeries, `FORGERIES_ACCEPTED 0`, `rejected_receipts:3`, and a final terminal status of `accepted` whose Bash and receipt event sets contain `bash-from-independent-stream`. The artifact does not identify the per-forgery rejection reason or show the pre-existing legitimate stream event that would explain the accepted terminal status. It therefore supports a claimed rejection count, but does not independently prove stale-nonce rejection or replay resistance.

The statement “The receipt handler cannot add a Bash identifier to that stream set” is not demonstrated by the excerpt shown: the excerpt only shows how `observeStreamLine` observes stream lines and how the matcher reads sets. The receipt-handler implementation and nonce checks are not included. This is an evidence gap, not a proven false sentence.

## Route 1 coverage

PROVEN: The artifact names four launch paths and explicitly limits the implemented control runner to the one-process, one-terminal-turn shape. It expressly marks the warm engine, conductor, and roundtable paths as uncovered. The later UNVERIFIED section consistently discloses that those live paths, and the live lane launcher, remain unsupervised.

## Route 4 and test claims

PROVEN: The artifact reports identical starting and final SHA-256 values for the two live files it measured, and it discloses that it did not restart the engine or use the listed ports. It reports the focused controls, TypeScript check, and test counts, including the nonzero root test result caused by conductor branch coverage of 82.87% against an 83% threshold.

UNKNOWN: These test totals are assertions in the supplied report. No raw test logs, command transcripts, nonce broker implementation, hook implementation, or independent receipt provenance are present in the evidence corpus, so the totals cannot validate the nonce security conclusion.

## UNVERIFIED

- Whether the nonce is unpredictable, secret, turn-scoped, single-use, or checked against the receipt’s event and turn fields.
- Whether the receipt in the registered control was emitted by the intended hook rather than another process with access to the private socket.
- Whether the three external forgery attempts were rejected because of nonce validation, event-set filtering, replay handling, or another mechanism.
- Whether any of the uncovered launch paths or the live destructive-git guard is supervised.
- No Lean build was started; Lean worker processes: 0; clang worker processes: 0. `command -v lake` printed `/home/monkey/bin/lake`.

## Final verdict

TESTED: The artifact supports the reported Route 2 supervisor outcomes and the stated coverage disclosures. UNKNOWN: It does not support the stronger security conclusion that a nonce-bearing receipt proves the intended hook fired, because nonce provenance, reader access, binding, and validation are not evidenced. The review verdict is therefore limited support for the controls, with the nonce-authentication conclusion unresolved.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "LIMITED SUPPORT; NONCE AUTHENTICATION UNKNOWN"
