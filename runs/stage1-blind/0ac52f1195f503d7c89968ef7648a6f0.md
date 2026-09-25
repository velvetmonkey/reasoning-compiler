DONE, the artifact supports its Route 2 matcher logs as self-descriptions and does not establish that a nonce or an accepted receipt proves the intended hook fired.

## A1 — cold read-only review of hookcanary-report.md

Reviewed only `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md` (377 lines, 14282 bytes, SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`). Premise `test -s` on that path held (exit 0). Did not read mega-monkey, reasoning-compiler, other `*-report.md` files, an answer key, a rubric, network, live services, or launchers. Did not start a Lean build. `command -v lake` printed `/home/monkey/bin/lake`. Live `lean` workers: 0. Live `clang` workers: 0. Resource sample `vmstat 5 5` last four rows: idle 98 percent, `si`/`so` 0; `available` RAM 17087 MB; root 214G free. Brake green.

Labels below are PROVEN / REFUTED / TESTED / ASSUMED / UNKNOWN. No quoted sentence met the REFUTED bar (internal contradiction plus a five-minute replay from this artifact). Several security inferences fail even so.

### What the logs do support

Route 2 quoted verdicts are internally consistent with the author's pass/fail story. TESTED from the artifact's own JSON:

- Unregistered: `terminal_status=failed`, `reason=HOOK_MISSING_PRE_TOOL_USE`, empty `receipt_event_ids`.
- Registered: `terminal_status=accepted`, one Bash id, same id in `receipt_event_ids`.
- Swapped script: `terminal_status=failed`, `reason=HOOK_SHA256_MISMATCH`, observed digest `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6` versus expected `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`.
- No Bash: `terminal_status=not_applicable`, empty Bash and receipt id lists.

`COUNT of Route 2 controls run: 4` and `passing: 4` hold as counts of those four quoted outcomes. They do not hold as proof of hook attribution. Arithmetic `1436+24+72=1532` is PROVEN from the report's own totals. The nonzero root `npm test` because conductor branches were 82.87 percent against 83 percent is disclosed, not a false green.

Uncovered launch paths (warm engine, conductor, roundtable) and the live `lanelaunch` path are named as UNCOVERED. That is an accurately disclosed limitation, not a false sentence.

### Nonce: origin, readers, and what possession proves

The pointer is the nonce. The artifact does not answer it.

Where it comes from: UNKNOWN. The only origin sentence is that `hook-turn-supervisor.ts` "owns" the nonce. No generator, no broker for the built path, no stdin/env/file/socket handshake is shown. The warm-path note that a nonce broker must "change context without changing the child process environment" is a hint that environment is a plausible channel, not evidence of the channel used.

Who can read it: UNKNOWN, except that Route 3b's outside-the-hook forger possessed the live 64-hex value `3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0` and put it on two forged messages. The report never says how that process learned the value (copied from a prior receipt, read from env, read from supervisor state, or invented). Legitimate Route 2 receipts also carry a 64-hex nonce in the receipt JSON itself, so any observer of a receipt sees the nonce after first use.

Does possession establish that the intended hook fired: not on this evidence. The quoted terminal matcher (`hook-turn-supervisor.ts` excerpt at lines 147–175) never mentions nonce. It (1) drops receipts whose `event_id` is absent from `bashEventIds`, (2) fails if a Bash id lacks a receipt, (3) fails if `receipt.hook_sha256 !== expectedHookSha256`, else accepts. A matching `event_id` plus a self-reported expected digest is enough in the quoted code.

`packages/engine/scripts/pretool-receipt-hook.mjs` "computes its own SHA-256 and sends the synchronous receipt." The digest in the receipt is therefore self-reported. Route 2c only caught an honest different script that reported its own different digest. A sender that writes the expected digest is not that control. All three Route 3b forgeries already do that: each `hook_sha256` equals the expected value.

"The hook sent its receipt before it returned" (Route 2a) is ASSUMED from experimental setup plus a `RECEIPT` line appearing before `CLAUDE_EXIT`. The log does not identify the sending process.

### Route 3b does not distinguish hook receipts from other processes

Exact claims:

- "I sent all three forged receipts directly to the private socket from outside the hook."
- "The first forged receipt replayed an already accepted receipt."
- "The second forged receipt used a stale nonce."
- "The third forged receipt named an event absent from the turn stream."
- "COUNT of forged receipts accepted: 0."

Delivery from outside the hook is TESTED only as author prose; the log lines are tagged `FORGED`. The three invalidating defects are the stated rejection reasons. The report does **not** claim that "outside the hook" was itself the reason for rejection. That honesty matters: the controls then do not test the one case that would distinguish senders, namely a first-use receipt with a live nonce, an in-stream `event_id`, and the expected digest, sent by a non-hook process.

The quoted matcher already rejects forgeries 2 and 3 by `event_id` alone (`bash-stale-nonce` and `bash-absent-from-stream` are absent from `bash_event_ids`). The "stale nonce" payload is confounded with an absent stream identifier. Whether any nonce check ran is UNKNOWN.

Forgery 1 is the only message whose `event_id` (`bash-from-independent-stream`) is in the stream set. The same id is the sole entry in both `bash_event_ids` and `receipt_event_ids`. `terminal_status` is `accepted`. No `RECEIPT` line appears in the Route 3b block. The "already accepted receipt" that the first forgery allegedly replayed is not in the quoted log. So "replayed an already accepted receipt" is ASSUMED, not PROVEN. `COUNT of forged receipts accepted: 0` is the control's own counter, not independently shown. It is not REFUTED: `rejected_receipts: 3` is compatible with three ingest/match rejects plus a hidden prior receipt. It is also compatible with a counter that does not treat the remaining receipt as a forgery. Either way, the remaining receipt's sender is not identified.

`bash-from-independent-stream` is not a Claude `toolu_…` id. Whether Route 3b used a real independent Claude stdout stream, or a test double that already contained that string, is UNKNOWN. "The receipt handler cannot add a Bash identifier to that stream set" is ASSUMED from a partial `observeStreamLine` excerpt. The receipt-ingest function is not quoted.

Replay from the supplied artifact (no repo):

```bash
python3 - <<'PY'
from pathlib import Path
import json
lines = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text().splitlines()
forged = [json.loads(l[7:]) for l in lines if l.startswith("FORGED ")]
verdict = json.loads(next(l[8:] for l in lines if l.startswith("VERDICT ") and "04586aa3" in l))
matcher = "\n".join(lines[107:138])
print([f["event_id"] for f in forged])
print([f["nonce"] for f in forged])
print(all(f["hook_sha256"].startswith("8354a7b3") for f in forged))
print(verdict["terminal_status"], verdict["bash_event_ids"], verdict["receipt_event_ids"], verdict["rejected_receipts"])
print("nonce" in matcher.lower())
print([i+1 for i,l in enumerate(lines[139:163]) if l.startswith("RECEIPT ")])
PY
```

Expected output:

```text
['bash-from-independent-stream', 'bash-stale-nonce', 'bash-absent-from-stream']
['3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0', 'stale-nonce', '3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0']
True
accepted ['bash-from-independent-stream'] ['bash-from-independent-stream'] 3
False
[]
```

### Other claims

`COUNT of files added: 5` / `changed: 0` / `SCOPE CREEP: 0` are UNKNOWN without the tree. Live `settings.json` and `block-dangerous-git.sh` digests matching before and after are TESTED as two quoted SHA-256 pairs for those two paths only. "I did not restart the engine" and unused ports are UNKNOWN. "The remote branch exists at that SHA" is UNKNOWN (no network). Pushed SHA `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` is the frozen subject named to this lane; that equality is PROVEN as a string match against the wrapper, not as a git object this review opened.

### Final verdict

The evidence supports these conclusions: four Route 2 controls produced the four quoted matcher statuses; a self-reported wrong digest fails a turn; a missing receipt fails a turn when a Bash id is present; no Bash yields `not_applicable`; three malformed outside-hook messages were counted as not accepted; three of four Claude launch shapes remain unsupervised, and the report says so.

The evidence does not support these conclusions: that the intended hook was the process that sent an accepted receipt; that possession of the nonce binds the sender to that hook; that the supervisor distinguishes a hook receipt from another process that can write the private socket; that Route 3b demonstrated nonce checking or unforgeability.

That last cluster is a material coverage limit, not a demonstrated false sentence. Treating `FORGERIES_ACCEPTED 0` as a green on hook attribution would be a false green in the reader, not a REFUTED sentence in the report.

No REFUTED claims.

## UNVERIFIED

- Nonce generation, distribution, storage, lifetime, and who can read it besides the supervisor and the 3b forger.
- Whether receipt ingest checks nonce, replay, or sender identity; those functions are not in the quoted excerpts.
- Whether any accepted receipt was sent by `pretool-receipt-hook.mjs` rather than by another process with the nonce and socket.
- The unprinted "already accepted receipt" asserted for Route 3b.
- Whether Route 3b's Bash id came from live Claude stdout or a fixture.
- File-add/change counts, live engine/port/disk claims, remote-branch existence, and the 1,532-test run, all as facts about the world rather than as sentences in the artifact.
- mega-monkey at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` was in scope as a frozen subject and was not opened, per the registered brief's "report is your entire evidence corpus" rule.

state AT-GATE, repo velvetmonkey/mega-monkey, pr none, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "NOT-PROVEN", refuted 0, artifact-sha256 "d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc"
