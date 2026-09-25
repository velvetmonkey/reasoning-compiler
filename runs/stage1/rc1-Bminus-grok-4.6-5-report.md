DONE, cold review of the freeze artifact; printed single-Bash Route 2 verdicts and the receipt-claimed digest mismatch hold, with named coverage limits.

Subject SHA named by the wrapper and by the artifact FINAL STATE: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
Artifact: `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md` (14282 bytes, SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`).
Premise `test -s` on that path: exit 0.
Grant used: the freeze file only. This run did not open mega-monkey, reasoning-compiler, other `*-report.md` files, an answer key, a rubric, network, a live service, or a launcher.

## Route 2 printed controls

Five `VERDICT` objects appear in the artifact. Their `bash_event_ids` lengths are 1, 1, 1, 0, 1. Maximum length is 1.

| Control | terminal_status | n bash | n receipt | rejected_receipts | reason |
|---|---|---|---|---|---|
| unregistered | failed | 1 | 0 | 0 | HOOK_MISSING_PRE_TOOL_USE |
| registered | accepted | 1 | 1 | 0 | (none) |
| swapped | failed | 1 | 1 | 0 | HOOK_SHA256_MISMATCH |
| no-bash | not_applicable | 0 | 0 | 0 | (none) |
| forgery turn | accepted | 1 | 1 | 3 | (none) |

**TESTED.** Unregistered: one Bash id `toolu_01PM7Sdf7WgBjzyuJbkQPZzc`, empty `receipt_event_ids`, status `failed`, reason `HOOK_MISSING_PRE_TOOL_USE`. The prose "The negative control passed" names that intended fail. Child `CLAUDE_EXIT 0` sits beside the supervisor fail.

**TESTED.** Registered: receipt `event_id` and `bash_event_ids[0]` are both `toolu_016KVbcw5y7XseMdvJkCmJWh`; `hook_sha256` equals `expected_hook_sha256` `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`; status `accepted`.

**TESTED.** No-bash: empty arrays, status `not_applicable`. The prose "The supervisor did not report success" matches that status.

**TESTED** as an author count: "COUNT of Route 2 controls run: 4" and "COUNT of Route 2 controls passing: 4" match the four Route 2 dumps, with pass meaning intended outcome (`failed` / `accepted` / `failed` / `not_applicable`).

Replay from the supplied artifact:

```bash
python3 -c '
from pathlib import Path
import json, re
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
for i, m in enumerate(re.finditer(r"^VERDICT (\{.*\})$", text, re.M), 1):
    v = json.loads(m.group(1))
    print(i, len(v["bash_event_ids"]), len(v["receipt_event_ids"]),
          v["terminal_status"], v.get("reason", ""),
          v.get("rejected_receipts"), v.get("observed_hook_sha256", ""))
'
```

Expected output:

```text
1 1 0 failed HOOK_MISSING_PRE_TOOL_USE 0 
2 1 1 accepted  0 
3 1 1 failed HOOK_SHA256_MISMATCH 0 c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
4 0 0 not_applicable  0 
5 1 1 accepted  3 
```

## Pointer: receipt for every Bash identifier

Quoted matcher (`hook-turn-supervisor.ts` excerpt, artifact lines 147–175):

```ts
const missing = bashEventIds.find((eventId) => !this.receipts.has(eventId));
if (missing) {
  verdict = this.verdict('failed', bashEventIds, receiptEventIds, {
    reason: HOOK_MISSING_REASON,
    event_id: missing,
  });
}
```

`bashEventIds` is built from `[...this.bashEventIds]`. `.find` walks every identifier in that array. Under this quotation, a turn with two Bash identifiers and one receipt is `failed` with `HOOK_MISSING` on the identifier absent from `this.receipts`.

**PROVEN** for cardinality 1: the unregistered control is exactly one Bash id and zero receipts, and it fails `HOOK_MISSING_PRE_TOOL_USE`.

**TESTED** by quotation for cardinality 2+: the `.find` over the full array.

**UNKNOWN** empirically for cardinality 2+: every printed `bash_event_ids` array has length 0 or 1. The UNVERIFIED list names `allow`, missing receipt, wrong script digest, no Bash, replay, stale nonce, and an absent stream identifier. A two-Bash-one-receipt trial is outside that list. The "5 of 5" focused tests are unnamed in the artifact, so their coverage of two identifiers is UNKNOWN.

The evidence therefore requires a receipt for every Bash identifier in the quoted matcher, and demonstrates that requirement in a live dump only for a single identifier.

## Pointer: digest path

Quoted comparison:

```ts
.find((receipt) => receipt.hook_sha256 !== this.expectedHookSha256)
```

Route 4d on `pretool-receipt-hook.mjs`: "It computes its own SHA-256 and sends the synchronous receipt."

Swapped-control receipt `hook_sha256` is `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6`. Swapped VERDICT `expected_hook_sha256` is `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`. Those strings differ. `observed_hook_sha256` equals the receipt field. Status is `failed`, reason `HOOK_SHA256_MISMATCH`. `receipt_event_ids` still holds `toolu_01BLFdogpvaJFcX51f7GDrvi`. `rejected_receipts` is 0.

**PROVEN.** A receipt whose `hook_sha256` differs from `expected_hook_sha256` fails the turn. The prose "The supervisor detected the different script digest" matches this dump.

**TESTED** by quotation. The matcher compares the receipt field to `expectedHookSha256`. The quoted terminal matcher does not hash a script file.

**UNKNOWN** empirically: a substituted script whose receipt carries `hook_sha256` equal to `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`. Under the quoted comparison that receipt is digest-matching. The artifact contains no `sha256sum` of either hook file; both expected and observed values in Route 2 are supervisor/receipt fields.

`rejected_receipts` stays 0 on SHA mismatch because the quoted loop increments that counter only when a receipt `event_id` is absent from `bashEventIds`. The mismatched receipt remains bound to the Bash id and fails later via `HOOK_SHA256_MISMATCH`.

Replay:

```bash
python3 -c '
from pathlib import Path
import json, re
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
rec = json.loads(re.search(r"CONTROL swapped\nRECEIPT (\{.*\})", text).group(1))
ver = json.loads(re.search(r"CONTROL swapped\nRECEIPT \{.*\}\nCLAUDE_EXIT 0\nVERDICT (\{.*\})", text).group(1))
print("receipt", rec["hook_sha256"])
print("expected", ver["expected_hook_sha256"])
print("observed", ver["observed_hook_sha256"])
print("equal_receipt_observed", rec["hook_sha256"] == ver["observed_hook_sha256"])
print("equal_receipt_expected", rec["hook_sha256"] == ver["expected_hook_sha256"])
print("status", ver["terminal_status"], ver["reason"], "rejected", ver["rejected_receipts"])
'
```

Expected output:

```text
receipt c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
expected 8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65
observed c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6
equal_receipt_observed True
equal_receipt_expected False
status failed HOOK_SHA256_MISMATCH rejected 0
```

## Route 3 independence and forgeries

**TESTED** by quotation. `observeStreamLine` parses Claude stdout JSON and calls `observeBlock` on assistant content and on `stream_event` `content_block_start`. The quoted function has no receipt-map write into `bashEventIds`.

**TESTED** as printed counters: `FORGERIES_TRIED 3`, `FORGERIES_ACCEPTED 0`, `rejected_receipts` 3, `terminal_status` `accepted`, `bash_event_ids` and `receipt_event_ids` both `["bash-from-independent-stream"]`.

**UNKNOWN.** The first FORGED payload uses `event_id` `bash-from-independent-stream`, `hook_sha256` equal to expected, and `decision` `allow`. That is the sole Bash id in the verdict. The 3b dump contains three `FORGED` lines and no `RECEIPT` line for an earlier accepting receipt. The prose "The first forged receipt replayed an already accepted receipt" asserts that earlier receipt. Applying only the quoted matcher to the three FORGED payloads with an empty receipts map yields two extra-id deletions (`rejected_receipts` 2) and an accepted turn whose stored receipt is the first FORGED object. The printed `rejected_receipts` 3 and `FORGERIES_ACCEPTED` 0 require intake rejection (replay / nonce) that the quoted snippet does not show. This run does not treat that tension as a false sentence; the original receipt is unprinted.

The 3b Bash id is the synthetic label `bash-from-independent-stream`. Route 2 ids are `toolu_*`. The 3b dump has no Claude stream excerpt and no `CLAUDE_EXIT` line.

## Other conclusions that hold

**TESTED** by arithmetic: 1436 + 24 + 72 = 1532. The artifact states 1,532 passed and 0 failed, and states the root command returned nonzero because conductor branch coverage was 82.87 percent against a threshold of 83 percent. That nonzero is disclosed in FINAL STATE and UNVERIFIED.

**TESTED** as self-limits in the artifact UNVERIFIED and Route 1b: one launch shape; warm engine, conductor, and roundtable uncovered; live `lanelaunch` unwired; live `block-dangerous-git.sh` untested for this receipt format; `refuse` untested; no deployment measured.

**ASSUMED** (author measurement, unretyped here): live `settings.json` and `block-dangerous-git.sh` SHA-256 values identical before and after; 5 files added, 0 changed; TypeScript check after gravity then conductor builds; disk 241G used / 192G available before and after.

**UNKNOWN** without the repository or network: line-number accuracy of the TypeScript excerpts; that the remote branch exists at the pushed SHA; contents of the five focused tests; that expected `8354a7b3…` is the SHA-256 of `pretool-receipt-hook.mjs` bytes.

## REFUTED

None. No artifact sentence was shown false by a contradiction inside the freeze file. Coverage limits and unprinted steps are labeled UNKNOWN or named as limits.

## Lean, suite, resources

Lean build started: no. Frozen worktree `HEAD` `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`. `git merge-base origin/main HEAD` = `fca07c3274cf9ca2bf17e0d19262655db28d4105`. `git diff --name-only $(git merge-base origin/main HEAD)..HEAD | grep -c '^lean/'` = **0** (grep -c exit 1 with count file 0). Lean stage skipped on that count.
`command -v lake`: `/home/monkey/bin/lake`.
`lean` / `clang` worker processes started by this lane: 0. comm-name count `lean` 0, `clang` 0. No `lake build` parent.
Estate suite gate from `/home/monkey/scratch/rc1-Bminus-grok-4.6-5/wt`: `/home/monkey/bin/suiterun -- scripts/run-complete-product-suite.sh`. Live count before admit 0, after 0. Admitted after wait at live 0 / limit 3. Exit **127**. stderr: `suiterun: line 107: /home/monkey/scratch/rc1-Bminus-grok-4.6-5/wt/scripts/run-complete-product-suite.sh: No such file or directory`. `test -f` on that path was exit 1. Seal suite was not substituted.
Resource sample `vmstat 5 5` last four idle: 82, 82, 82, 82. `MemAvailable` 17160716 kB (16758 MB `free -m` available). Root 110G free. Brake green.

## UNVERIFIED

- Two-Bash-one-receipt behaviour on a live control (quoted matcher only).
- Supervisor-side hash of hook file bytes; substituted script that reports expected `hook_sha256`.
- The unprinted original receipt, nonce broker, and intake rejection that would make Route 3b `rejected_receipts` 3 and `FORGERIES_ACCEPTED` 0 match the quoted matcher.
- `observeBlock` filter: whether only Bash tool_use ids enter `bashEventIds`.
- Named assertions inside the 5 focused tests.
- Byte identity of the five added files with the excerpts; remote existence of `feat/hook-turn-supervisor` at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
- Live `settings.json` / `block-dangerous-git.sh` digests (live files were not read).
- Conductor 82.87 percent branch coverage and the 1,532-pass test run (author log only).
- Byte contents of the five added files (A1 grant keeps the freeze report as the review corpus; git name-only was used only for the Lean-path count).

## Verdict

The freeze artifact supports its Route 2 conclusions for turns with at most one Bash identifier, including missing-receipt fail, matching-receipt accept, honest digest-mismatch fail, and no-Bash `not_applicable`. The quoted matcher requires a receipt for every Bash identifier; the dumps never exercise two identifiers. The digest path that is in evidence is `receipt.hook_sha256` versus `expectedHookSha256`; a differing claimed digest fails the turn, and a same-claimed-digest file substitution is untested. Route 1b uncovered-path limits and the nonzero root test status are disclosed. Overall: conclusions hold on the printed single-Bash controls, with those named limits.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "SUPPORTS-WITH-LIMITS", artifact-sha256 "d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc", n-refuted 0, n-bash-max 1, lean-path 0, suiterun-exit 127
