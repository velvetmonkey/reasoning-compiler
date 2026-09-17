DONE — cold artifact-only adversarial review completed; one material false green was found.

## Scope and evidence

Evidence was limited to the supplied `corpus/A1/hookcanary-report.md` and `corpus/A1/FROZEN_SHA`. The report artifact hash matched the brief's supplied hash: `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`. `FROZEN_SHA` contains `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.

## Route 2 controls

- **PROVEN (within the artifact):** The unregistered control is reported with `terminal_status:"failed"`, no receipt, and reason `HOOK_MISSING_PRE_TOOL_USE` (artifact lines 3–21).
- **PROVEN (within the artifact):** The registered control is reported with matching Bash/receipt event IDs, the expected hook digest, and `terminal_status:"accepted"` (lines 25–40).
- **PROVEN (within the artifact):** The swapped-hook control is reported with a different observed digest and `HOOK_SHA256_MISMATCH` failure (lines 44–57).
- **PROVEN (within the artifact):** The no-Bash control is reported as `not_applicable` with empty Bash and receipt sets (lines 59–73).
- **ASSUMED:** “COUNT of Route 2 controls passing: 4” (lines 75–77) is a test-runner classification, not independently demonstrated by the raw records. The four intended outcomes are present, but the artifact does not define what “passing” means.

## Route 3a stream separation

- **PROVEN (as an internal reading of the supplied code excerpt):** The excerpt observes Bash identifiers from parsed Claude stdout/stream events, while the matcher separately filters receipt IDs against `bashEventIds` (lines 81–138).
- **UNKNOWN:** The claim that the receipt handler cannot add an identifier to the independent stream set is a property of the full implementation, but only excerpts are supplied; the excerpt supports it but cannot establish all other mutation paths.

## Route 3b forgery control

- **REFUTED:** Exact claim: “FORGERIES_ACCEPTED 0” / “COUNT of forged receipts accepted: 0” (lines 156–163). The same raw output reports `terminal_status:"accepted"`, `bash_event_ids:["bash-from-independent-stream"]`, and `receipt_event_ids:["bash-from-independent-stream"]` (line 158), while line 153 identifies that ID as the first forged receipt. Thus the artifact records an accepted terminal verdict containing the forged event/receipt ID, contradicting an unqualified claim that no forgery was accepted. The three stale/absent receipts may have been rejected (`rejected_receipts:3`), but that does not make the first replayed receipt zero-accepted.

  Replayable read-only command, runnable from the supplied bundle:

  ```sh
  awk '/^FORGERIES_ACCEPTED 0$/{print "reported: "$0} /"terminal_status":"accepted"/{print "verdict: terminal_status accepted"} /"receipt_event_ids":\["bash-from-independent-stream"\]/{print "verdict: forged event present in receipt_event_ids"}' corpus/A1/hookcanary-report.md
  ```

  Expected output:

  ```text
  reported: FORGERIES_ACCEPTED 0
  verdict: terminal_status accepted
  verdict: forged event present in receipt_event_ids
  ```

- **UNKNOWN:** Whether the first forged receipt was a replay accepted by a prior turn or a newly accepted socket message cannot be distinguished from this artifact. Either way, the report must qualify its zero-accepted conclusion; its current unqualified form is false/contradictory.

## Route 1 launch-path coverage

- **PROVEN (as reported and internally consistent):** Four launch paths are enumerated (lines 167–175), one lane/one-turn shape is described as covered, and the warm engine, conductor, and roundtable paths are explicitly described as not built/adapted (lines 177–201).
- **PROVEN:** The report discloses that the other three paths are uncovered and does not claim supervision for them (lines 197–201).
- **UNKNOWN:** The actual repository path locations and behavior cannot be independently verified from tier-0 evidence; only the supplied excerpts and assertions are available.

## Route 4 integrity, tests, and required files

- **PROVEN (hash evidence only):** The starting and final SHA-256 strings shown for both live files are equal (lines 203–229). This supports unchanged content under the hash assumption, but does not independently prove byte identity or that the files were measured at the stated times.
- **UNKNOWN:** “I did not restart the engine” and “I did not use ports …” (lines 231–233) are uncorroborated operator assertions; no process or socket evidence is supplied.
- **ASSUMED:** The reported test counts, coverage values, threshold failure, and focused/type-check results (lines 235–255) are claims about runs whose command output is not included. They are not independently replayable from the artifact alone.
- **PROVEN (as a disclosure):** The artifact states that five files were added, zero changed, and no scope creep was ruled (lines 257–283); the actual file topology is not independently verifiable here.
- **UNKNOWN:** The “REQUIRED” status of the five named files (lines 259–277) depends on repository requirements not present in the evidence corpus.

## UNVERIFIED

- The report itself explicitly marks live lane, warm engine, conductor, roundtable, destructive-git guard, Fable, refuse decisions, and deployment state as untested or unavailable (lines 285–307). These are accurately disclosed limitations, not false claims.
- The failed-attempt narrative and eventual reruns (lines 309–339) are self-reported and cannot be independently verified from tier-0 evidence.
- No claim in the artifact establishes coverage of the live wiring or deployment; the report correctly avoids that inference.

## Final verdict

The artifact supports the registered, missing-registration, digest-mismatch, no-Bash, and three-launch-path coverage disclosures, subject to the stated evidence limits. It does not support the unqualified Route 3b conclusion that zero forged receipts were accepted: the raw verdict records an accepted terminal result using the forged independent-stream event ID. The material conclusion about live supervision remains an accurately disclosed limitation, not a demonstrated capability.

run_id rc1-B0-gpt-5.6-luna-1; I did not access anything outside `/home/monkey/scratch/rc1-B0-luna-1-bundle/`.
state RULING, question "Given the restricted corpus and no accessible pull-request head, should the Route 3b zero-forgery conclusion be corrected to distinguish the three rejected receipts from the accepted replayed event?"
