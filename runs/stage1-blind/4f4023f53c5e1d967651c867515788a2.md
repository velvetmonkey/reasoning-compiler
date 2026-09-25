DONE, artifact-only review of hookcanary-report.md; stated single-call outcomes hold, with material coverage limits on multi-Bash receipts and self-reported script digests.

## Job: A1 cold read-only adversarial review

Corpus: `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md` (14282 bytes, SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`, 377 lines). Premise `test -s` on that path exited 0. The freeze directory contains only this file. Registered brief forbids repository, network, answer key, rubric, sibling reports, and live services; those were not used. Subject SHA named in the wrapper and in the artifact FINAL STATE is `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.

No Lean build was started. This lane touched no `lean/` tree. `command -v lake` printed `/home/monkey/bin/lake`. Live `lean`/`clang` worker count from this lane: 0.

Labels below are PROVEN / REFUTED / TESTED / ASSUMED / UNKNOWN. None of the author's sentences met the REFUTED bar (internal contradiction plus a five-minute replay). A missing trial is a coverage limit, not a false sentence.

### What the Route 2 receipts actually show

Four Route 2 raw verdicts parse as JSON and match the surrounding prose.

| Control | bash_event_ids n | receipt_event_ids n | terminal_status | reason |
|---|---|---|---|---|
| unregistered (2b) | 1 | 0 | failed | HOOK_MISSING_PRE_TOOL_USE |
| registered (2a) | 1 | 1, same id | accepted | (none) |
| swapped (2c) | 1 | 1, same id | failed | HOOK_SHA256_MISMATCH |
| no-bash (2d) | 0 | 0 | not_applicable | (none) |

- PROVEN: 2a stream id equals receipt id `toolu_016KVbcw5y7XseMdvJkCmJWh`, and `hook_sha256` equals `expected_hook_sha256` `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`.
- PROVEN: 2b has one Bash id and an empty receipt list, with reason `HOOK_MISSING_PRE_TOOL_USE`.
- PROVEN: 2c `observed_hook_sha256` `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6` differs from the expected digest, and the verdict is `failed` / `HOOK_SHA256_MISMATCH`. `rejected_receipts` is 0; the receipt stayed in `receipt_event_ids` and failed the digest comparison, which matches the quoted matcher.
- PROVEN: 2d is `not_applicable` with empty Bash and receipt lists, so the supervisor did not report `accepted`.
- TESTED: "COUNT of Route 2 controls passing: 4" is consistent with treating 2b/2c as expected failures and 2d as expected N/A. That count is not four successful supervisions.
- ASSUMED: the quoted `hook-turn-supervisor.ts` excerpt is the code that produced those verdicts.

### Two Bash identifiers, one receipt

Pointer item. Every verdict in the artifact has 0 or 1 Bash identifier. No control, including the forgery turn, presents two Bash ids.

Quoted matcher (artifact lines 147–164):

```
const bashEventIds = [...this.bashEventIds];
...
const missing = bashEventIds.find((eventId) => !this.receipts.has(eventId));
if (missing) {
  verdict = this.verdict('failed', bashEventIds, receiptEventIds, {
    reason: HOOK_MISSING_REASON,
    event_id: missing,
  });
```

- TESTED as quoted code: `find` fails the turn on the first Bash id with no receipt, so the implementation as printed requires a receipt for every identifier in `bashEventIds`.
- UNKNOWN as an end-to-end property: nothing in the corpus runs two Bash calls with one receipt. A matcher bug that only appears when `bashEventIds.length > 1` would not have been caught by the four Route 2 controls.
- The author never claims a two-Bash trial. This is a material coverage limit, not a false green.

Replay from the supplied artifact:

```bash
python3 - <<'PY'
from pathlib import Path
import json
p = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md")
for i, line in enumerate(p.read_text().splitlines(), 1):
    s = line.strip()
    if s.startswith("VERDICT "):
        o = json.loads(s.split(" ", 1)[1])
        print(i, "bash", len(o["bash_event_ids"]), "receipt", len(o["receipt_event_ids"]),
              o["terminal_status"], o.get("reason"), o.get("observed_hook_sha256"))
PY
```

Expected output:

```
18 bash 1 receipt 0 failed HOOK_MISSING_PRE_TOOL_USE None
39 bash 1 receipt 1 accepted None None
56 bash 1 receipt 1 failed HOOK_SHA256_MISMATCH c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
72 bash 0 receipt 0 not_applicable None None
158 bash 1 receipt 1 accepted None None
```

A stranger who sees any `bash` count of 2 or more is not looking at this artifact.

### Digest path: can a different script pass as the expected hook?

Pointer item. The swapped-script control does not hash a file at match time. The matcher (artifact lines 166–168) compares `receipt.hook_sha256` to `this.expectedHookSha256`. Route 4d says the hook "computes its own SHA-256 and sends the synchronous receipt."

- PROVEN: in 2c, a receipt whose `hook_sha256` field is not the expected value fails `HOOK_SHA256_MISMATCH`. A different *reported* digest cannot pass this matcher.
- TESTED: "The supervisor detected the different script digest" is true of this trial, where the byte-different copy reported `c47dff14…` instead of `8354a7b3…`.
- UNKNOWN: whether a different on-disk script that *reports* the expected digest `8354a7b3…` would fail. The quoted matcher would accept it. No control in the artifact sends a receipt with the expected digest from a byte-different script.
- The author does not claim independent hashing of the registered file. Inferring "wrong file cannot pass" from 2c is stronger than the evidence.

Replay:

```bash
python3 - <<'PY'
from pathlib import Path
import json
p = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md")
text = p.read_text().splitlines()
receipt = json.loads(text[53].strip().split(" ", 1)[1])  # line 54 RECEIPT
verdict = json.loads(text[55].strip().split(" ", 1)[1])  # line 56 VERDICT
print("receipt.hook_sha256", receipt["hook_sha256"])
print("expected_hook_sha256", verdict["expected_hook_sha256"])
print("observed_hook_sha256", verdict["observed_hook_sha256"])
print("equal", receipt["hook_sha256"] == verdict["expected_hook_sha256"])
print("status", verdict["terminal_status"], verdict["reason"])
print("self-hash claim present", any("computes its own SHA-256" in ln for ln in text))
PY
```

Expected output:

```
receipt.hook_sha256 c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
expected_hook_sha256 8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65
observed_hook_sha256 c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
equal False
status failed HOOK_SHA256_MISMATCH
self-hash claim present True
```

### Forgery control (Route 3b)

- TESTED: two of the three forged ids (`bash-stale-nonce`, `bash-absent-from-stream`) are absent from `bash_event_ids`, which supports "the receipt handler cannot add a Bash identifier to that stream set" for socket injection in this run.
- TESTED against the printed counter: `FORGERIES_ACCEPTED 0` and `COUNT of forged receipts accepted: 0`.
- UNKNOWN: whether the surviving `receipt_event_ids` entry `bash-from-independent-stream` is a legitimate pre-forgery receipt or the first `FORGED` payload. The first forged object uses that same event id, `decision: "allow"`, and the *expected* digest `8354a7b3…`. The raw block shows no non-`FORGED` `RECEIPT` line, unlike Route 2a/2c. The author's "already accepted receipt" is not in the quoted log. `terminal_status: "accepted"` with `rejected_receipts: 3` is consistent with a hidden legitimate receipt plus three ingest rejections, and also consistent with the first forgery remaining in the map if the counter is wrong. Lack of the missing line does not make the count false.
- The Bash id `bash-from-independent-stream` is synthetic, not a `toolu_…` Claude id. Forgery resistance is not shown against a live Route 2 identifier.

### Other stated conclusions

- PROVEN inside the document: 1436 + 24 + 72 = 1532; start/final quoted digests of `settings.json` and `block-dangerous-git.sh` are pairwise identical; five named REQUIRED files match "COUNT of files added: 5".
- TESTED as disclosure, not as a green: three of four launch paths are called UNCOVERED; root `npm test` nonzero because conductor branch coverage was 82.87% against 83%; no `refuse` decision; live `block-dangerous-git.sh` was not the receipt hook. Those are accurately disclosed limitations.
- UNKNOWN vs the tree: launch-path line numbers, test totals, live file bytes, pushed-SHA existence, and "COUNT of files changed: 0". The registered brief forbids reading mega-monkey, so those claims were not checked outside the artifact.
- ASSUMED: isolated settings files actually isolated the live Claude settings; `sonnet` was the installed CLI alias used.

### What holds

The evidence supports the four Route 2 outcomes as written: missing receipt fails, matching receipt accepts, a self-reported wrong digest fails, and no Bash is `not_applicable` rather than success. It supports, as quoted code, a per-identifier missing-receipt check and a receipt-field digest check. It does not empirically show a two-Bash turn, and it does not show that a different script cannot pass by reporting the expected digest. No sentence was REFUTED.

Final verdict: SUPPORTS-WITH-LIMITS.

## UNVERIFIED

- mega-monkey at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` was not opened (registered brief: report is the entire evidence corpus).
- `corpus/A1/FROZEN_SHA` was not present next to the freeze copy; the SHA was taken from the wrapper and from the artifact FINAL STATE.
- Live `/home/monkey/.claude/settings.json` and `block-dangerous-git.sh` were not rehashed.
- Receipt-ingest / nonce-broker source is not in the artifact, so replay, stale nonce, and `rejected_receipts: 3` cannot be traced past the matcher excerpt.
- Whether `HOOK_SHA_MISMATCH_REASON` equals the printed `HOOK_SHA256_MISMATCH` is not shown.
- No model, product control, network, launcher, or sibling report was read.
- Resource brake: `vmstat 5 5` last four idle percents 56, 64, 23, 50; not red. Root 214G available. No Lean workers from this lane.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "SUPPORTS-WITH-LIMITS", refuted 0
