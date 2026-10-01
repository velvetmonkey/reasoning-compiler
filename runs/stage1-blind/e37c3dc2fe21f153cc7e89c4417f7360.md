DONE, cold adversarial review of the frozen hookcanary artifact.

Subject SHA in the wrapper and in the artifact FINAL STATE: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
Artifact: `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md` (14282 bytes, SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`).
Premise `test -s` on that path holds. This review used only that file. No Lean build was started. `command -v lake` printed `/home/monkey/bin/lake`. Live `lean` / `clang` / `lake` process count: 0.

Resource brake: `vmstat 5 5` last four idle percents 88, 84, 84, 84. `free -m` available column 16492 MB. `/proc/meminfo` MemAvailable 16888176 kB. Root 117G free. `suiterun --count` printed 0. Work continued. No product suite was run.

## Scope of the artifact

The file opens at `## ROUTE 2b` and has no title, no overall claim paragraph, and no `## ROUTE 4b`. Conclusions are the section-level sentences plus FINAL STATE. Labels below apply to those sentences.

## Pointer 1 — two Bash identifiers, one receipt

**TESTED.** Every `VERDICT` object in the artifact has zero or one entry in `bash_event_ids`. Maximum length is 1.

| Control | `bash_event_ids` length | `receipt_event_ids` length | `terminal_status` |
|---|---|---|---|
| 2b unregistered | 1 | 0 | failed |
| 2a registered | 1 | 1 | accepted |
| 2c swapped | 1 | 1 | failed |
| 2d no-bash | 0 | 0 | not_applicable |
| 3b forgeries | 1 | 1 | accepted |

**TESTED.** The quoted matcher at the cited lines 159–163 fails a turn on the first `bashEventIds` entry absent from `this.receipts`:

```
const missing = bashEventIds.find((eventId) => !this.receipts.has(eventId));
if (missing) {
  verdict = this.verdict('failed', bashEventIds, receiptEventIds, {
    reason: HOOK_MISSING_REASON,
```

That predicate requires a receipt key for every identifier in `bashEventIds`. Route 2b is the empirical case of one identifier and zero receipts, and it returns `HOOK_MISSING_PRE_TOOL_USE`.

**UNKNOWN empirically.** The artifact contains no transcript whose `bash_event_ids` array has two identifiers. The two-Bash, one-receipt case is untested in the supplied evidence. The report does not claim that case was run. The artifact UNVERIFIED list names missing-receipt as a tested shape and does not name a multi-Bash turn.

Replay from the artifact:

```sh
python3 - <<'PY'
from pathlib import Path
import re, json
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
rows = [json.loads(m.group(1)) for m in re.finditer(r'VERDICT (\{.*\})', text)]
for o in rows:
    print(len(o.get("bash_event_ids") or []), len(o.get("receipt_event_ids") or []),
          o.get("terminal_status"), o.get("reason"))
print("max_bash", max(len(o.get("bash_event_ids") or []) for o in rows))
PY
```

Expected output:

```
1 0 failed HOOK_MISSING_PRE_TOOL_USE
1 1 accepted None
1 1 failed HOOK_SHA256_MISMATCH
0 0 not_applicable None
1 1 accepted None
max_bash 1
```

## Pointer 2 — digest path

**PROVEN.** Route 2c's swapped-script control reports a receipt `hook_sha256` of `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6` and a verdict `expected_hook_sha256` of `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`, `terminal_status` `failed`, reason `HOOK_SHA256_MISMATCH`. Those two 64-hex strings differ. The sentence "The supervisor detected the different script digest." matches that JSON.

**TESTED.** The quoted matcher (cited lines 166–168) compares the receipt field to the supervisor's expected string:

```
.find((receipt) => receipt.hook_sha256 !== this.expectedHookSha256)
```

**UNKNOWN.** The artifact never shows the supervisor hashing hook-file bytes at match time. Route 4d says the hook script "computes its own SHA-256 and sends the synchronous receipt." Under that path, a byte-different script that still places `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65` in `hook_sha256` would make the quoted `!==` test false and would fall through to `accepted`. No control in the artifact presents that lying-digest case. Route 3b's three `FORGED` lines all carry the expected digest; they do not test a different digest getting accepted.

Replay from the artifact:

```sh
python3 - <<'PY'
from pathlib import Path
import re, json
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
receipts = [json.loads(m.group(1)) for m in re.finditer(r'RECEIPT (\{.*\})', text)]
verdicts = [json.loads(m.group(1)) for m in re.finditer(r'VERDICT (\{.*\})', text)]
swapped_r = next(r for r in receipts if r["hook_sha256"].startswith("c47dff"))
swapped_v = next(v for v in verdicts if v.get("reason")=="HOOK_SHA256_MISMATCH")
print(swapped_r["hook_sha256"])
print(swapped_v["expected_hook_sha256"])
print(swapped_r["hook_sha256"] == swapped_v["expected_hook_sha256"])
print(swapped_v["terminal_status"], swapped_v["reason"])
print("matcher_compares_receipt_field",
      "receipt.hook_sha256 !== this.expectedHookSha256" in text)
PY
```

Expected output:

```
c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65
False
failed HOOK_SHA256_MISMATCH
matcher_compares_receipt_field True
```

## Route 2 controls

**PROVEN.** Four Route 2 raw blocks exist, matching "COUNT of Route 2 controls run: 4."

**TESTED.** "COUNT of Route 2 controls passing: 4" is consistent with control-success semantics already used in "The negative control passed" after a `failed` verdict. The four outcomes are: missing-hook fail, registered accept, swapped-digest fail, no-Bash `not_applicable`. Each matches the sentence immediately above its raw block.

**ASSUMED.** That "passing" means "control met its designed outcome." A reader who treats "passing" as `terminal_status=accepted` would misread two of the four blocks. The artifact's own wording of 2b and 2d makes the designed-outcome reading the supported one.

## Route 3a — independent stream set

**TESTED.** `observeStreamLine` as quoted parses Claude stream JSON and calls `observeBlock`. Extra receipts whose ids are absent from `bashEventIds` are deleted and counted in `rejectedReceipts`.

**TESTED by 3b JSON.** `bash-stale-nonce` and `bash-absent-from-stream` appear on `FORGED` lines and do not appear in the verdict `bash_event_ids`. That supports the sentence "The receipt handler cannot add a Bash identifier to that stream set" for those two ids.

**UNKNOWN.** `observeBlock` is not quoted, so the artifact does not show the tool-name filter that fills `bashEventIds`. Nonce and replay checks are not in the quoted matcher; Route 3b depends on them.

## Route 3b — forgeries

**PROVEN.** The raw block contains three `FORGED` lines, `FORGERIES_TRIED 3`, and `FORGERIES_ACCEPTED 0`.

**UNKNOWN.** The same block's `VERDICT` is `terminal_status=accepted` with `receipt_event_ids=["bash-from-independent-stream"]`, which is also the first forged `event_id`. The block has no `RECEIPT` line. The sentence "The first forged receipt replayed an already accepted receipt" is the only account of a prior receipt. The quoted log does not display that prior receipt, so the surviving receipt is not independently distinguished from the first `FORGED` line. Lack of that line does not make `FORGERIES_ACCEPTED 0` false; it leaves the count dependent on the control runner.

**TESTED.** `rejected_receipts: 3` is a larger number than the quoted matcher can produce from event-id filtering alone if one of the three forged ids is in `bashEventIds`. That implies ingest-time rejection beyond the quoted snippet. The snippet is incomplete for the replay and stale-nonce stories.

## Launch coverage, live files, tests, scope

**TESTED as disclosure.** Route 1b states one launch shape is covered and three are UNCOVERED, and "No report can imply that the uncovered paths have supervision." UNVERIFIED repeats that the live lane launcher, warm engine, conductor, and roundtable paths remain unsupervised.

**TESTED as paired digests.** Route 4a prints identical SHA-256 values before and after for `settings.json` (`a287c108…d05d`) and `block-dangerous-git.sh` (`52ebe458…d263`). Byte-identity of those live files is a claim of matching printed hashes. This review did not rehash any live file.

**PROVEN arithmetic.** 1436 + 24 + 72 = 1532. The artifact states 1,532 passed and 0 failed, and that the root command returned nonzero because conductor branch coverage was 82.87 percent against a configured 83 percent. That is an accurately disclosed command failure beside a passing test count.

**UNKNOWN against the tree.** "COUNT of files added: 5", "COUNT of files changed: 0", "COUNT ruled SCOPE CREEP: 0", and the four launch-path line citations are not checkable from the artifact alone. FINAL STATE pushed SHA matches the wrapper subject SHA.

**TESTED as self-report.** FAILED ATTEMPTS describes an `import.meta.url` fix on a new test, a gravity-then-conductor build order, and bounded deletes. Those are process notes, not Route 2 greens.

## REFUTED

None. No sentence in the artifact is contradicted by another sentence or by the JSON it quotes. The pointer items are coverage limits and an incomplete digest-authentication path in the quoted matcher.

## What holds

- Unregistered Bash with no receipt fails by `HOOK_MISSING_PRE_TOOL_USE`.
- Registered matching identifier and expected digest accepts.
- Honest self-hash of a byte-different hook fails by `HOOK_SHA256_MISMATCH`.
- No Bash yields `not_applicable`.
- Quoted matcher requires a receipt for each id in `bashEventIds` and compares `receipt.hook_sha256` to `expectedHookSha256`.
- Three of four launch paths are disclosed uncovered.
- Root tests-passed count and coverage-threshold nonzero status are disclosed together.

## Final verdict

The evidence supports the narrow Route 2 control outcomes and the quoted matcher behavior. It does not empirically demonstrate a two-Bash, one-receipt turn. It does not demonstrate that a different hook file is rejected when it reports the expected digest. Route 3b's zero-accepted-forgeries count is runner-asserted and is not independently shown by a distinct `RECEIPT` line. Those are coverage and inference limits. They are not false greens of the four Route 2 blocks as written.

Verdict: **SUPPORTED-WITH-LIMITS**.

## UNVERIFIED

- File:line citations into mega-monkey at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` (repository not opened; registered brief is artifact-only).
- Behavior of `observeBlock`, the nonce broker, and the private-socket ingest path, which are unquoted.
- Whether a two-Bash turn with one receipt fails at runtime.
- Whether a byte-different hook that reports `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65` is accepted.
- Whether the Route 3b surviving receipt is distinct from the first `FORGED` line.
- Live SHA-256 of `/home/monkey/.claude/settings.json` and `block-dangerous-git.sh` at review time.
- npm test, coverage percents, and the five added files on disk.
- Control prompts, Claude `sonnet` alias behavior, and any product control (none were run).
- Contents of any other `*-report.md`, answer key, rubric, or the reasoning-compiler repository.
- Lean stages: skipped because this lane touched no repository tree; `git diff --name-only … | grep -c '^lean/'` was not applicable. No `lake`/`leanbuild` process was started.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "SUPPORTED-WITH-LIMITS", refuted 0, artifact-sha256 "d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc"
