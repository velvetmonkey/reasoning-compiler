DONE — artifact-only adversarial review completed; the narrow controls pass, but the broader claims are not fully supported.

## A1 — evidence review

### PROVEN

The negative control in ROUTE 2b has one Bash identifier, no receipts, and a failed terminal status with `HOOK_MISSING_PRE_TOOL_USE`. The registered control in ROUTE 2a has one Bash identifier, one matching receipt identifier, and an accepted terminal status. The no-Bash control is `not_applicable`, not success. These outputs support the narrow conclusion that the supervisor distinguishes the tested missing-hook, registered-hook, and no-Bash cases.

The swapped-script control in ROUTE 2c/2d reports an observed digest of `c47dff...e33a6`, an expected digest of `8354a7...f7e65`, and `HOOK_SHA256_MISMATCH`; that particular byte-different-copy test was rejected. The artifact also records unchanged SHA-256 values for the two live files before and after the work.

The shown matcher code in ROUTE 3a collects Bash identifiers from the independent stream, removes receipts whose identifiers are not in that set, and checks each retained receipt's `hook_sha256` against `expectedHookSha256`. This supports the described identifier-set and equality-check behavior for the shown code path.

### REFUTED

The broad inference that ROUTE 2 demonstrates receipt coverage for every Bash call is not supported and is contradicted by the actual evidence scope. ROUTE 2a and ROUTE 2b each show exactly one Bash identifier; ROUTE 2c and 2d likewise show one or zero. The artifact contains no control with two Bash identifiers and only one receipt. Therefore the sentence-level implication that these controls establish the two-call case is false as an inference, even though the one-call controls themselves are accurately reported.

Replayable read-only check from the supplied artifact:

```bash
awk '/^## ROUTE 2a/{on=1} /^## ROUTE 3a/{on=0} on{print}' /home/monkey/reasoning-compiler-freeze/hookcanary-report.md | grep -E 'bash_event_ids|receipt_event_ids'
```

Expected output includes one identifier in each list:

```text
..."bash_event_ids":["toolu_016KVbcw5y7XseMdvJkCmJWh"]..."receipt_event_ids":["toolu_016KVbcw5y7XseMdvJkCmJWh"]...
```

### UNKNOWN

Whether a different script that forges or emits the expected digest can pass remains UNKNOWN. ROUTE 2c proves that the tested swapped script emitted a digest different from the expected value and was rejected. ROUTE 3a only shows comparison with `expectedHookSha256`; it does not show the hook implementation, the computation of `expectedHookSha256`, or evidence that the digest is recomputed from the executed script rather than accepted from the receipt. The unchanged live-file digests do not resolve that provenance question.

Whether forged receipts are intrinsically rejected is also not established by ROUTE 3b alone. Its verdict is `accepted`, with `bash-from-independent-stream` present in both the Bash and receipt lists, while the artifact says three forgeries were tried and zero were accepted. That output can be consistent with the first receipt matching an already-present stream identifier and the other two being rejected, but the artifact does not expose enough event-order or socket-handler evidence to prove the claimed anti-replay/nonce behavior independently.

Whether the three uncovered launch paths have equivalent supervision is explicitly UNKNOWN: ROUTE 1b says only the lane one-process path was built and labels the warm engine, conductor, and roundtable paths uncovered. The final 1,436/1,436 test result is not evidence for those paths because the artifact gives no path-to-test mapping.

## FINAL VERDICT

The evidence supports the narrow one-Bash registered/missing/no-Bash controls and the tested digest-mismatch rejection. It does not support a general claim of per-Bash receipt completeness for a two-call turn, digest authenticity against an expected value supplied by the hook, forged-receipt resistance in all cases, or coverage of the three other launch paths. Those claims must remain UNKNOWN rather than being called false solely from missing evidence.

## UNVERIFIED

- No two-Bash/one-receipt control is present in the artifact.
- The source and computation path for `expectedHookSha256` are not shown.
- The hook/socket nonce validation implementation and event ordering are not shown.
- The warm engine, conductor, and roundtable paths are explicitly uncovered.
- No pull-request head metadata is supplied; the frozen subject SHA is `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.

condition: a current pull-request head and gate identity are missing for this artifact-only review
resolver: the lane coordinator
decisive source: /home/monkey/reasoning-compiler-freeze/hookcanary-report.md
recheck route: provide the current pull-request head and rerun the frisk gate against that head
state RULING, question "Should this artifact-only verdict be recorded as the gate verdict against frozen commit f23d8af4a67dc916fbd0b5606606b9c72e0ef036 without a current pull-request head?"
