DONE, A1 cold review of the supplied hookcanary artifact: Route 2 transcripts support event-id and script-digest matching; nonce origin, readers, and hook-versus-other-process binding are not evidenced.

## Scope

Registered brief: cold, read-only review of the supplied artifact as the entire evidence corpus. Artifact path used: `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md`. Premise `test -s` on that path exited 0. Artifact SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`, 377 lines, 14282 bytes. The file begins at `## ROUTE 2b`; no earlier section is present in the freeze copy.

Subject SHA named by the wrapper and by the artifact's FINAL STATE: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`. The freeze directory contains only this artifact. This lane did not open mega-monkey, reasoning-compiler, other `*-report.md` files, network, launchers, or a product control. Lean stage skipped: read-only artifact review, no worktree, no `lean/` diff. `command -v lake` printed `/home/monkey/bin/lake`. No `lake`/`lean`/`clang` parent or workers.

Resource brake (one `vmstat 5 5`, last four idle percents 69, 68, 70, 71; `si`/`so` 0–36 KB/s; `MemAvailable` 16371536 kB; root 117G avail). Green. `suiterun --count` was 0. Suite not run: registered brief forbids a product control.

## Job: A1 adversarial review

Pointer: nonce origin, who can read it, whether possession shows the intended hook fired, and whether the report distinguishes a hook receipt from a receipt sent by another process.

### Nonce origin, readers, possession

UNKNOWN: where the nonce is created, how it reaches a sender, and who can read it.

The word `nonce` appears in receipt JSON, in one 3b sentence ("The second forged receipt used a stale nonce."), in a warm-engine limitation ("turn-scoped nonce broker" / "child process environment"), in the 4d ownership list, and in the UNVERIFIED tested-controls list. It never appears in either quoted TypeScript block.

4d says `hook-turn-supervisor.ts` "owns the private socket, turn identity, nonce, independent stream set, receipt set, and terminal matcher." That is an ownership assertion. The quoted terminal matcher (report lines 147–175) compares `bashEventIds` to `receipts` keys, then compares `receipt.hook_sha256` to `this.expectedHookSha256`. It does not read a nonce field.

The hook file is described as computing "its own SHA-256" and sending a synchronous receipt. That sentence attributes digest computation to the hook, not nonce minting.

Route 2a and 2c receipts each carry a 64-hex nonce. A byte-different swapped script still emitted a nonce and was failed for `HOOK_SHA256_MISMATCH`, not for a nonce error. That is consistent with any registered PreToolUse script being able to obtain whatever nonce the runner issued. It does not bind the nonce to one script file. Script identity, in the quoted matcher, is the digest check.

The warm-engine limitation says a long-lived child would need a nonce broker that can change context without changing the process environment. That sentence ASSUMES the built one-turn path can place turn context in the child environment. The report never shows an environment variable, stdin field, file, or socket handshake that carries the nonce.

Possession of a nonce, on this evidence, does not establish that the intended hook fired. A receipt in 2a shows some sender knew a nonce, a matching `event_id`, and a matching `hook_sha256`. 3b shows another process can write the same socket with the expected digest. The quoted matcher would accept such a payload if the `event_id` is in the stream set and the digest matches.

### Hook receipt versus another process

TESTED: an external process can send receipt JSON to the private socket. Quote: "I sent all three forged receipts directly to the private socket from outside the hook."

The report does not distinguish a hook sender from that other process. Receipt JSON has `turn_id`, `nonce`, `hook_event_name`, `hook_sha256`, `event_id`, `decision`. No sender pid, socket credential, or hook-path field is shown.

Route 3b raw output contains three `FORGED` lines, `FORGERIES_TRIED 3`, `FORGERIES_ACCEPTED 0`, and a `VERDICT` with `terminal_status":"accepted"`, `bash_event_ids":["bash-from-independent-stream"]`, `receipt_event_ids":["bash-from-independent-stream"]`, `rejected_receipts":3`. There is no `RECEIPT` line and no `CLAUDE_EXIT` line in that block. The accepted stream id is the synthetic string `bash-from-independent-stream`, not a `toolu_` id as in Route 2.

The first forged payload uses that same `event_id`. The author says it "replayed an already accepted receipt." The prior receipt is not in the transcript. Sender of the accepted receipt is UNKNOWN. `FORGERIES_ACCEPTED 0` is what the control script printed. Membership of the first forged `event_id` in `receipt_event_ids` means the transcript cannot show that the accepted receipt is a hook receipt rather than the external send.

Stale-nonce and absent-stream forgeries use `event_id` values that are absent from `bash_event_ids`. The quoted matcher deletes those receipts for missing stream ids and increments `rejectedReceipts`, without reading `nonce`. Those two sends do not isolate nonce checking. See REFUTED.

If the receipts map is keyed by `event_id` as the quote uses `this.receipts.keys()` / `get` / `delete`, the quoted filter over the three forged keys predicts two deletions. The printed `rejected_receipts` is 3. UNKNOWN additional insert-time logic may exist. It is not quoted, so it cannot be credited as nonce authentication.

### Route 2 controls

TESTED as internal transcripts of a matcher on stream `event_id` plus `hook_sha256`:

- 2b unregistered: Bash id present, `receipt_event_ids` empty, `failed` / `HOOK_MISSING_PRE_TOOL_USE`. Author calls this a passing negative control. Consistent.
- 2a registered: receipt `event_id` equals stream id `toolu_016KVbcw5y7XseMdvJkCmJWh`, digest equals `expected_hook_sha256`, `accepted`.
- 2c swapped: receipt digest `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6` versus expected `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`, `failed` / `HOOK_SHA256_MISMATCH`.
- 2d no-Bash: empty id lists, `not_applicable`. Author says the supervisor did not report success. Consistent.

`COUNT of Route 2 controls run: 4` and `COUNT of Route 2 controls passing: 4` match those four outcomes. They support a supervisor that pairs Claude stream ids with a digest-bearing receipt. They do not support nonce-authenticated hook identity.

ASSUMED: "The hook sent its receipt before it returned." The 2a log prints `RECEIPT` then `CLAUDE_EXIT`. That is runner-log order.

### Route 3a stream set

The quoted `observeStreamLine` parses Claude JSON lines and calls `observeBlock` on assistant content and `content_block_start`. It does not insert receipt ids into `bashEventIds`. That much is PROVEN of the quoted function.

"The receipt handler cannot add a Bash identifier to that stream set" reaches past the quote. The receipt handler is not shown. `observeBlock` is not shown. 3b's `bash_event_ids` contains a planted-looking label. ASSUMED as a general theorem; TESTED only that the quoted parser is stream-JSON.

### Launch paths and scope

TESTED as disclosure, and internally consistent: four launch sites named; supervisor built for the one-process one-turn shape at `lanelaunch:278`; control runner is branch code and does not change that launcher; warm engine, conductor, and roundtable UNCOVERED; "No report can imply that the uncovered paths have supervision." UNVERIFIED later says the controls did not test Fable at that same line. Building for a shape and testing `lanelaunch` are separate; the report states both.

4d: five files REQUIRED/added, zero files changed, zero scope creep. File inventory is UNKNOWN from the artifact alone (no tree listing).

### Tests, live files, final state

4c numeric totals (1532 passed, coverage 82.87% versus 83%, focused 5/5, engine tsc after gravity then conductor builds) are the author's measurements. UNKNOWN independently. Internally consistent with FAILED ATTEMPTS. Nonzero root `npm test` because of an existing conductor threshold is disclosed, not hidden as a green.

4a live `settings.json` and `block-dangerous-git.sh` digests, ports unused, engine not restarted: UNKNOWN independently; presented as equal start/final hashes. Accurately a local hygiene claim, not a hook-firing claim.

FINAL STATE SHA matches the wrapper subject. No merge, no pull request, no deploy: author's statements, unreplicated here.

## REFUTED

Claim (UNVERIFIED, report line 303): "The controls tested `allow`, missing receipt, wrong script digest, no Bash, replay, stale nonce, and an absent stream identifier."

The conjunct "stale nonce" is a failed inference that nonce validation was exercised as its own control.

Evidence: the stale payload is

`FORGED {"turn_id":"04586aa3-8246-496d-bd85-2df151402d46","nonce":"stale-nonce",...,"event_id":"bash-stale-nonce",...}`

The same block's verdict has `bash_event_ids":["bash-from-independent-stream"]` only. The quoted matcher (lines 147–153) deletes a receipt when `!this.bashEventIds.has(eventId)` and does not mention nonce. `bash-stale-nonce` is the same reject class as the third forgery (`bash-absent-from-stream`), which the report already counts as "an absent stream identifier."

Replay command, from the supplied artifact only:

```bash
python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
stale = json.loads(re.search(
    r'FORGED ({[^\n]*bash-stale-nonce[^\n]*})', text).group(1))
block = re.search(
    r'FORGERIES_TRIED 3\nFORGERIES_ACCEPTED 0\nVERDICT ({.*})', text).group(1)
verdict = json.loads(block)
matcher = re.search(r"```ts\n147.*?```", text, re.S).group(0)
print("stale.event_id =", stale["event_id"])
print("stale.nonce =", stale["nonce"])
print("verdict.bash_event_ids =", verdict["bash_event_ids"])
print("stale event in stream set =", stale["event_id"] in verdict["bash_event_ids"])
print("matcher contains 'nonce' =", "nonce" in matcher.lower())
print("rejected_receipts =", verdict["rejected_receipts"])
PY
```

Expected output:

```text
stale.event_id = bash-stale-nonce
stale.nonce = stale-nonce
verdict.bash_event_ids = ['bash-from-independent-stream']
stale event in stream set = False
matcher contains 'nonce' = False
rejected_receipts = 3
```

The "allow" / missing / digest / no-Bash items are not covered by this refutation. Replay remains UNKNOWN as a distinct nonce-reuse check: the first forged `event_id` is in the stream set, and the accepted receipt set is that same id.

## What holds

Route 2a/2b/2c/2d transcripts support a turn matcher that requires a Bash stream id for `accepted`, fails closed when that id has no receipt, fails on digest mismatch, and returns `not_applicable` when no Bash id appears. 2c supports distinguishing a byte-different registered script via `hook_sha256`. Uncovered launch paths, live `block-dangerous-git.sh` not sending this receipt, no `refuse` test, no Fable/`lanelaunch` test, and the conductor coverage miss are disclosed limitations, not false greens.

## UNVERIFIED

- Nonce generation, transport, storage, rotation, and the set of processes that can read it.
- Any nonce comparison in unquoted supervisor or hook code.
- Sender of the 3b accepted receipt; existence of the "already accepted" receipt as a hook message.
- Whether `FORGERIES_ACCEPTED` is supervisor receipt-set membership or a control-script counter.
- `observeBlock` Bash filtering; receipt-handler body; private-socket bind mode and peer credentials.
- Whether Route 2 receipts were produced by `pretool-receipt-hook.mjs` as opposed to another registered command.
- Live file SHA-256 values, test totals, coverage percentages, TypeScript success, and the five-file inventory.
- Existence of remote branch `feat/hook-turn-supervisor` at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` (named, not fetched).
- Behavior of warm engine, conductor, roundtable, live lane launcher, and `refuse`.
- Artifact completeness: freeze copy starts at Route 2b; a Route 0/1 nonce section, if it existed, is not in this corpus.
- This lane did not recompute any digest with a product mechanism.

Final verdict: the artifact's evidence supports event-id pairing plus script-digest matching under isolated Route 2 settings. It does not support the conclusion that possession of the nonce, or of a receipt on the private socket, establishes that the intended hook fired. The report does not distinguish a hook receipt from a receipt sent by another process.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "NONCE-BINDING-UNSHOWN", artifact-sha256 "d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc"

## Resume: estate suite gate and Lean skip

Old footer above is historical. A1 verdict is unchanged. This section records the estate-wide suite gate and the Lean skip measured on a detached scratch worktree at the frozen SHA. The worktree was not used to re-score nonce claims.

Lean stage skipped. `git diff --name-only $(git merge-base origin/main HEAD)..HEAD` against local `origin/main` `85fe61862c5ebda5e1786a70da17dae8a4b37f0f` (merge-base `fca07c3274cf9ca2bf17e0d19262655db28d4105`) gave lean-path count **0**. `command -v lake` printed `/home/monkey/bin/lake`. No Lean build started. `lean`/`clang`/`lake` worker count: 0. Parent `lake build`: none.

Suite: `/home/monkey/bin/suiterun --count` was **0** before and **0** after. Command run from `/home/monkey/scratch/rc1-Bplus-grok-4.6-4/wt` (HEAD `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`): `/home/monkey/bin/suiterun -- scripts/run-complete-product-suite.sh`. Admission waited at live count 0 / limit 3 (flock held by other `suiterun` children), then `live count 0 below 3, admitting`. Child exit **127**: `No such file or directory` for `.../wt/scripts/run-complete-product-suite.sh`. Direct invocation was not used. No substitute suite was run. That 127 is apparatus: this frozen tree has no product-suite script.

## UNVERIFIED (resume)

- Whether GitHub `origin/main` still equals local `85fe61862c5ebda5e1786a70da17dae8a4b37f0f` (no network).
- Product-suite behavior if a later commit added `scripts/run-complete-product-suite.sh`.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "NONCE-BINDING-UNSHOWN", artifact-sha256 "d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc", suiterun-exit 127, lean-path 0, lake /home/monkey/bin/lake
