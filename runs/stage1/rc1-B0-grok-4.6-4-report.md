DONE, cold artifact-only review of hookcanary-report.md; Route 2 control outcomes hold; no claim REFUTED; Route 3 security inferences remain unproven.

Subject SHA named by the wrapper and by the report's FINAL STATE: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
Supplied artifact: `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md` (377 lines, 14282 bytes, SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`).
Premise `test -s /home/monkey/reasoning-compiler-freeze/hookcanary-report.md` held (exit 0).
Registered brief makes this report the entire evidence corpus. Local commands read that file only.

Resource brake: `vmstat 5 5` last four idle readings 87, 89, 98, 93. `free -m` available 16494 MB. `/proc/meminfo` MemAvailable 16890404 kB. Root 117G free. Last four swap `so` rows 0. Brake green.
Lean: this lane started no Lean build, created 0 `lean` workers and 0 `clang` workers, and `command -v lake` printed `/home/monkey/bin/lake`. No repository edit; Lean stage skipped.

## A1 — cold read-only review

The report's conclusions that have raw control JSON behind them hold. The independent-stream injection claim and the isolation of nonce/replay checks are inferences the quoted evidence does not complete. Coverage limits in the report's own UNVERIFIED section match the evidence that is present. No sentence is REFUTED from the artifact.

### Route 2 controls — TESTED

Four quoted control blocks exist. Each `VERDICT` JSON parses, and each `terminal_status` matches the named case:

| control | printed status | bash ids | receipt ids | extra |
|---|---|---|---|---|
| unregistered | `failed` | 1 (`toolu_01PM7Sdf7WgBjzyuJbkQPZzc`) | empty | `reason` `HOOK_MISSING_PRE_TOOL_USE` |
| registered | `accepted` | 1 | same id | receipt `hook_sha256` equals `expected_hook_sha256` |
| swapped | `failed` | 1 | same id | `HOOK_SHA256_MISMATCH`; observed `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6` |
| no-bash | `not_applicable` | empty | empty | |

The quoted matcher at the report's `hook-turn-supervisor.ts:147` produces exactly those four statuses: missing receipt → `failed`; matching sha → `accepted`; sha mismatch → `failed`; empty bash set → `not_applicable`.

"COUNT of Route 2 controls run: 4" is PROVEN by the four blocks.
"COUNT of Route 2 controls passing: 4" is TESTED under the report's own meaning: the unregistered case is a negative control whose expected outcome is `failed`, and the no-bash case is expected `not_applicable`. One of the four verdicts has `terminal_status` `accepted`.

Expected digest `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65` is identical across every verdict. The swapped receipt is the only quoted payload that carries the other digest.

Replay from the artifact:

```bash
python3 - <<'PY'
from pathlib import Path
import json
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
for line in text.splitlines():
    if line.startswith("VERDICT "):
        v = json.loads(line[len("VERDICT "):])
        print(v["terminal_status"], v.get("reason"), v["bash_event_ids"], v["receipt_event_ids"])
PY
```

Expected output:

```text
failed HOOK_MISSING_PRE_TOOL_USE ['toolu_01PM7Sdf7WgBjzyuJbkQPZzc'] []
accepted None ['toolu_016KVbcw5y7XseMdvJkCmJWh'] ['toolu_016KVbcw5y7XseMdvJkCmJWh']
failed HOOK_SHA256_MISMATCH ['toolu_01BLFdogpvaJFcX51f7GDrvi'] ['toolu_01BLFdogpvaJFcX51f7GDrvi']
not_applicable None [] []
accepted None ['bash-from-independent-stream'] ['bash-from-independent-stream']
```

### Route 3a independent stream — ASSUMED

Claim: "The acceptance decision reads Bash identifiers from the independent Claude stdout stream."
Claim: "The receipt handler cannot add a Bash identifier to that stream set."

The quoted `observeStreamLine` parses stdout JSON and calls `observeBlock` for assistant content and `content_block_start`. That supports stream-side observation of some identifiers. The quote does not include `observeBlock`, every writer of `bashEventIds`, or the receipt handler. The second claim is an inference from an incomplete excerpt. Label ASSUMED.

### Route 3b forgeries — TESTED with an isolation gap

Quoted payloads:

- replay event_id `bash-from-independent-stream`, nonce `3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0`
- stale nonce event_id `bash-stale-nonce`, nonce `stale-nonce`
- absent event_id `bash-absent-from-stream`, same nonce as the first forgery

Control counters: `FORGERIES_TRIED 3`, `FORGERIES_ACCEPTED 0`.
Final verdict: `terminal_status` `accepted`, `bash_event_ids` and `receipt_event_ids` both `[bash-from-independent-stream]`, `rejected_receipts` 3.

"COUNT of forged receipts tried: 3" is PROVEN.
"COUNT of forged receipts accepted: 0" is TESTED as a printed counter. The kept receipt id equals the first forgery's event_id, so the counter's definition is load-bearing.

The quoted matcher increments `rejectedReceipts` only when it deletes a receipt whose event id is absent from `bashEventIds`. Under that rule, the three forged event ids yield two deletions and one kept receipt, so `rejected_receipts` would be 2. The printed value is 3. That number is compatible with an unquoted ingest-time reject of the replay, and it is also compatible with the control runner writing `3` because three forgeries were tried. The artifact does not distinguish those stories. Label UNKNOWN for the extra increment.

Stale-nonce isolation is UNKNOWN. `bash-stale-nonce` is absent from the verdict's `bash_event_ids`, so the quoted matcher drops it as an unknown stream id without reading the nonce. The same holds for `bash-absent-from-stream`. Sending those payloads is PROVEN. Demonstrating a nonce check from this output is an unsupported inference.

The 3b bash id is the synthetic string `bash-from-independent-stream`, unlike the Route 2 `toolu_*` ids. The forgery block does not quote a Claude stream. 3b tests the socket/matcher against a planted id.

Replay:

```bash
python3 - <<'PY'
from pathlib import Path
import json
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
forged=[]; verdict=None
for line in text.splitlines():
    if line.startswith("FORGED "):
        forged.append(json.loads(line[len("FORGED "):])["event_id"])
    if line.startswith("VERDICT ") and "bash-from-independent-stream" in line:
        verdict=json.loads(line[len("VERDICT "):])
print("forged", forged)
print("bash", verdict["bash_event_ids"])
print("kept", verdict["receipt_event_ids"])
print("rejected_receipts", verdict["rejected_receipts"])
print("stale_in_stream", "bash-stale-nonce" in verdict["bash_event_ids"])
PY
```

Expected output:

```text
forged ['bash-from-independent-stream', 'bash-stale-nonce', 'bash-absent-from-stream']
bash ['bash-from-independent-stream']
kept ['bash-from-independent-stream']
rejected_receipts 3
stale_in_stream False
```

### Route 1 launch shapes — UNKNOWN census, disclosed limit TESTED as text

The report names four launch sites by path:line and says three of them are UNCOVERED. It also says the control runner is branch code and does not change `/home/monkey/bin/lanelaunch`. Those are disclosures. Completeness of the census is UNKNOWN: the artifact has no search transcript. "The supervisor covers one launch shape" sits next to the later line that live lanelaunch was not tested. That pair is a disclosed limit.

### Route 4a live files — TESTED as identical hash pairs

Starting and final digests of `settings.json` are both `a287c108b78f5e83dbee46cadca0a595f99763bfa6837222ea6c593ec6b8d05d`.
Starting and final digests of `block-dangerous-git.sh` are both `52ebe4581b67039df5241fd72a1f10a8b213e442c5b099358bd13a593349d263`.
Byte-identity of those two paths, as hashed in the report, is PROVEN from the quoted pairs. Other live files, engine restart, and the named ports are ASSUMED.

### Route 4c tests — arithmetic PROVEN; run logs UNKNOWN

1436 + 24 + 72 = 1532. "Tests failed: 0" and "root command returned nonzero because conductor branch coverage was 82.87 percent" against an 83 percent threshold appear together in the same section and again in FINAL STATE. That is a disclosed nonzero exit. Raw `npm test` / coverage output is absent, so the counts themselves are UNKNOWN as independent measurements.

### Route 4d five files — internally consistent, UNKNOWN against the tree

Five paths are named REQUIRED. "COUNT of files added: 5", "COUNT of files changed: 0", "COUNT ruled SCOPE CREEP: 0" restates that list. No `git` output is quoted. FAILED ATTEMPTS describes editing the new test to resolve the hook path from `import.meta.url`; that is compatible with five added files and zero files changed versus `main` if the edit stayed inside a new file. Label UNKNOWN against the frozen tree.

### What holds

- Route 2 four controls, with expected-failure and not-applicable counting as passes, HOLD on the quoted JSON and the quoted matcher.
- The report's UNVERIFIED list (live lanelaunch, warm engine, conductor, roundtable, live `block-dangerous-git.sh` receipt format, `refuse` decision, Fable at `lanelaunch:278`, deployment) matches the evidence that is present. Those are disclosed limits.
- No merge, no pull request, no deploy: stated, uncontradicted by anything in the artifact.
- Disk start/end figures in the report are identical to each other.

### Final verdict

HOLDS-WITH-LIMITS. Evidence in the artifact supports the Route 2 control outcomes and the report's own coverage disclosures. Route 3a's "receipt handler cannot add a Bash identifier" claim is ASSUMED. Route 3b's printed `FORGERIES_ACCEPTED 0` is TESTED as a counter and does not isolate nonce checking. No claim is REFUTED from the supplied artifact. A lack of evidence was labeled UNKNOWN.

## UNVERIFIED

- Quoted TypeScript at `packages/engine/src/claude/hook-turn-supervisor.ts:127` and `:147` against the frozen tree. Registered brief: the report is the entire evidence corpus.
- `observeBlock`, receipt ingest, nonce/replay logic, and every writer of `bashEventIds`.
- How `FORGERIES_ACCEPTED` and `rejected_receipts` are computed in `hook-turn-forgery-control.ts`.
- Whether a legitimate receipt existed in turn `04586aa3-8246-496d-bd85-2df151402d46` before the three `FORGED` lines.
- `corpus/A1/FROZEN_SHA` (not present in the freeze directory; wrapper SHA and report Pushed SHA agree).
- Remote existence of `feat/hook-turn-supervisor` at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
- File-add / file-change counts versus that commit.
- Raw engine, gravity, conductor, and focused-test logs; coverage percentages.
- Recomputation of the two live-file SHA-256 pairs.
- "sonnet" alias, isolated settings contents, and "hook sent its receipt before it returned" as hook-internal ordering.
- Exhaustiveness of the four launch-path census.
- Ports 3211, 3212, 3124, 3125, 8443 and engine-restart claim.
- This lane started no Lean build.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "HOLDS-WITH-LIMITS", refuted 0
