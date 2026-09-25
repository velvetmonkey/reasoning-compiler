DONE, cold read-only review of the supplied hookcanary artifact at frozen sha f23d8af4a67dc916fbd0b5606606b9c72e0ef036; the report's evidence does not establish that nonce possession proves the intended hook fired.

Subject: velvetmonkey/mega-monkey frozen commit `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
Artifact: `/home/monkey/reasoning-compiler-freeze/hookcanary-report.md` (14282 bytes, 377 lines, SHA-256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`).
Corpus bound: the registered brief makes this report the entire evidence corpus. Local reads of that file only. No repository checkout, no other `*-report.md`, no answer key, no rubric, no network, no launcher, no product control, no Lean build.

`command -v lake` printed `/home/monkey/bin/lake`. Lean workers started: 0. clang workers started: 0. `suiterun --count` printed 0.

Resource brake (one `vmstat 5 5`; last four idle samples 55, 62, 69, 77 percent; `si`/`so` not sustained above 1000 KB/s; `MemAvailable` 15099120 kB; root 116G free): green.

# A1 review — hookcanary-report.md

The artifact opens at `## ROUTE 2b` with no title, no hypothesis, and no method. Route 2a/2c/2d, Route 3, Route 1, and Route 4 follow. That is a coverage limit of the supplied file, not a finding that a header exists elsewhere.

## Pointer: the nonce

**Where the nonce comes from: UNKNOWN.**
The word `nonce` appears 11 times. Eight of those are JSON field values inside receipts or forgeries. The remaining three are:

- Route 1b: the unbuilt warm engine path "needs a turn-scoped nonce broker that can change context without changing the child process environment."
- Route 4d: `hook-turn-supervisor.ts` "owns the private socket, turn identity, nonce, independent stream set, receipt set, and terminal matcher."
- UNVERIFIED: "The controls tested ... replay, stale nonce, and an absent stream identifier."

No sentence describes generation, lifetime, binding (turn, event, or both), or the channel that delivers the nonce to the hook (environment, argv, stdin, file, or socket handshake). Observed values are three 64-hex strings plus the literal `stale-nonce`. Those shapes are compatible with a SHA-256, and they do not identify a producer.

**Who can read it: UNKNOWN.**
"Private socket" is named twice and never given a path, owner, mode, or peer-authentication rule. Route 3b states that an outside-the-hook process sent three payloads to that socket, so reachability from a non-hook process is TESTED as an author claim about the control. How the legitimate hook learns the nonce, and which other processes share that view, is not in the artifact.

**Does possession of the nonce establish that the intended hook fired: no, on this evidence.**

The terminal matcher quoted in Route 3a (`hook-turn-supervisor.ts` lines 147–175 as printed) does this:

1. Drop stored receipts whose `event_id` is not in `this.bashEventIds`, counting them on `rejectedReceipts`.
2. If the Bash-id list is empty, emit `not_applicable`.
3. If some Bash id has no remaining receipt, emit `failed` / `HOOK_MISSING_PRE_TOOL_USE`.
4. If some remaining receipt has `hook_sha256 !== this.expectedHookSha256`, emit `failed` / `HOOK_SHA256_MISMATCH`.
5. Otherwise emit `accepted`.

That quote never reads `nonce`, `turn_id`, `hook_event_name`, or `decision`. Label: TESTED that the printed matcher uses stream-set membership and a SHA comparison. UNKNOWN whether unquoted intake code checks the nonce. A lack of quoted nonce logic does not prove the code omits it.

Route 4d says the receipt hook "computes its own SHA-256 and sends the synchronous receipt." The swapped-script control (Route 2c) then shows an honest different script reporting `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6` against expected `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`. That TESTED that a self-reported digest unequal to the expected constant fails the turn. It does not TESTED that a non-hook sender who copies the expected constant is rejected. All three Route 3b forgeries do copy `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65`.

## Hook receipt versus another process

The report tries to separate those senders in Route 3b: three payloads "directly to the private socket from outside the hook," then `FORGERIES_TRIED 3` and `FORGERIES_ACCEPTED 0`.

Exact objects in that fence:

- FORGED `event_id=bash-from-independent-stream`, nonce `3221b1a7…`, sha = expected.
- FORGED `event_id=bash-stale-nonce`, nonce `stale-nonce`, sha = expected.
- FORGED `event_id=bash-absent-from-stream`, nonce `3221b1a7…` (same as the first), sha = expected.
- VERDICT `terminal_status=accepted`, `bash_event_ids=["bash-from-independent-stream"]`, `receipt_event_ids=["bash-from-independent-stream"]`, `rejected_receipts=3`.

Findings:

1. **The accepted receipt id is the first forgery's event_id.** The fence contains no `RECEIPT` line and no `CLAUDE_EXIT` line. Routes 2a–2d use Claude `toolu_*` ids. Route 3b uses the synthetic id `bash-from-independent-stream`. The prose says the first forgery "replayed an already accepted receipt." That prior receipt is not in the printed raw output. Label: TESTED that the control printed `FORGERIES_ACCEPTED 0` and an `accepted` verdict for that synthetic id. UNKNOWN whether the accepted map entry was a hook receipt, a planted harness receipt, or the first FORGED payload itself. A lack of the prior body does not REFUTE the replay sentence.

2. **The stale-nonce trial is confounded.** The second payload does carry `nonce":"stale-nonce"`. Its `event_id` is `bash-stale-nonce`, which is absent from `bash_event_ids`. The quoted matcher rejects that id for stream-set membership without consulting nonce. The third payload reuses the first hex nonce and is described, accurately, as naming an event absent from the stream; that trial is not a nonce trial. Therefore the dump does not isolate a nonce check as the cause of any of the three rejections.

3. **The campaign never shows the decisive outsider case:** current unused nonce, expected (copyable) `hook_sha256`, `event_id` present in the independent stream set, sent from outside the hook, and then rejected. The first forgery is the only in-stream id, and it is labeled a replay of an already-accepted receipt. If that label is granted, a first-time outsider send with a live nonce was not tested. If that label is withheld, the accepted verdict is consistent with an outsider send being accepted.

Replay from the supplied artifact (stranger, read-only, under five minutes):

```bash
python3 - <<'PY'
from pathlib import Path
import re, json
text = Path("/home/monkey/reasoning-compiler-freeze/hookcanary-report.md").read_text()
sec = re.search(r"## ROUTE 3b\n(.*?)(?=\n## )", text, re.S).group(1)
fence = re.search(r"```text\n(.*?)```", sec, re.S).group(1)
forged, verdict = [], None
for line in fence.splitlines():
    if line.startswith("FORGED "):
        forged.append(json.loads(line.split(" ", 1)[1]))
    elif line.startswith("VERDICT "):
        verdict = json.loads(line.split(" ", 1)[1])
matcher = re.search(r"```ts\n(.*?)```", text, re.S)
# second ts fence is the matcher at printed source line 147
blocks = re.findall(r"```ts\n(.*?)```", text, re.S)
matcher = blocks[1]
print("forged_event_ids", [f["event_id"] for f in forged])
print("forged_nonces", [f["nonce"] for f in forged])
print("verdict_status", verdict["terminal_status"])
print("bash_event_ids", verdict["bash_event_ids"])
print("receipt_event_ids", verdict["receipt_event_ids"])
print("rejected_receipts", verdict["rejected_receipts"])
print("first_forged_id_in_receipts", forged[0]["event_id"] in verdict["receipt_event_ids"])
print("stale_event_in_stream", forged[1]["event_id"] in verdict["bash_event_ids"])
print("matcher_contains_nonce", "nonce" in matcher)
print("fence_has_RECEIPT_line", any(l.startswith("RECEIPT ") for l in fence.splitlines()))
PY
```

Expected output:

```text
forged_event_ids ['bash-from-independent-stream', 'bash-stale-nonce', 'bash-absent-from-stream']
forged_nonces ['3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0', 'stale-nonce', '3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0']
verdict_status accepted
bash_event_ids ['bash-from-independent-stream']
receipt_event_ids ['bash-from-independent-stream']
rejected_receipts 3
first_forged_id_in_receipts True
stale_event_in_stream False
matcher_contains_nonce False
fence_has_RECEIPT_line False
```

No REFUTED label is attached to `COUNT of forged receipts accepted: 0` because an unprinted prior receipt would make the counter consistent. The inference that Route 3b distinguishes a hook-authored receipt from another process is unsupported.

## Route 2 control transcripts

Four printed controls, four stated passes. Internally consistent.

| Control | Printed status | Receipt ids | Notes |
|---|---|---|---|
| 2b unregistered | `failed` / `HOOK_MISSING_PRE_TOOL_USE` | `[]` | Bash id present, no receipt. CLAUDE_EXIT 0. |
| 2a registered | `accepted` | matches Bash id `toolu_016KVbcw5y7XseMdvJkCmJWh` | Receipt carries nonce `52fcfea9…` and expected sha. Verdict does not mention nonce. |
| 2c swapped script | `failed` / `HOOK_SHA256_MISMATCH` | same `toolu_01BLFdogpvaJFcX51f7GDrvi` | Honest different sha. `rejected_receipts: 0` (kept in the map, then sha-failed). |
| 2d no-Bash | `not_applicable` | `[]` | Empty Bash set. Author says the supervisor did not report success. Counting this as a passing control is consistent with that spec. |

**"The stream identifier and receipt identifier matched" (2a): TESTED** by the printed JSON.

**"The hook sent its receipt before it returned" (2a): UNKNOWN.** The fence orders `RECEIPT`, then `CLAUDE_EXIT 0`, then `VERDICT`. That is supervisor-log order through Claude exit, not hook-return versus send.

**Causal reading of 2a versus 2b: TESTED within the document** that registering the receipt hook in isolated settings coincides with a receipt, and omitting `hooks` coincides with a missing receipt. That supports "the registered hook is involved in producing the receipt in these Claude runs." It does not support "the nonce is a capability that only that hook can possess."

## Other conclusions

**Three of four launch paths UNCOVERED: accurately disclosed.** Route 1a names four paths with file:line citations. Route 1b says the supervisor was built for the lanelaunch one-process one-terminal-turn shape and not for warm engine, conductor, or roundtable. "No report can imply that the uncovered paths have supervision" is a limitation statement, not a false green. Existence of those line numbers in the tree is UNKNOWN (repository not in this corpus).

**Live settings and `block-dangerous-git.sh` digests unchanged: TESTED as two pairs of identical quoted SHA-256 lines.** Independent recomputation of those paths was not done. The UNVERIFIED section already says the live destructive-git guard was not the receipt hook under test.

**`hook_sha256` as script identity: limited.** 2c TESTED honest mismatch. Self-attestation plus a copyable expected constant is a material coverage limit. Preserved as a limitation, not scored as a false sentence.

**Test totals 1,532 passed / 0 failed, root command nonzero at conductor 82.87% versus 83%: ASSUMED** as author arithmetic. No runner log is in the artifact. The nonzero root command is disclosed, so it is not a silent false green.

**COUNT of files added 5, changed 0, scope creep 0: ASSUMED.** No diff, no path list beyond the five REQUIRED files named in Route 4d.

**File:line code quotes (observeStreamLine, matcher, spawn sites): TESTED as text in the report.** UNKNOWN as faithful excerpts of `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.

**"The receipt handler cannot add a Bash identifier to that stream set": UNKNOWN.** `observeStreamLine` as quoted only walks assistant / `stream_event` content blocks and calls `observeBlock`. The receipt handler itself is not quoted, so exclusive write access to `bashEventIds` is not shown.

**Pushed SHA in FINAL STATE equals the wrapper frozen commit: TESTED** (`f23d8af4a67dc916fbd0b5606606b9c72e0ef036`). Author states no merge, no pull request, no deploy.

## What holds

The four Route 2 transcripts support their local stated outcomes: missing registration fails closed, registration plus matching ids accepts, swapped self-reported digest fails, no Bash is `not_applicable`. The author discloses that three launch paths, live lanelaunch wiring, Fable, a `refuse` decision, and the live git-guard hook were not in the campaign. Those disclosures are not false greens.

## What does not hold as proven

Possession of the nonce, or of a receipt JSON that contains one, does not on this evidence establish that the intended PreToolUse hook fired. The printed matcher does not use the nonce. `hook_sha256` is self-reported and was copied by the outside-the-hook forgeries. Route 3b does not isolate nonce checking, uses synthetic stream ids, omits any hook `RECEIPT` line, and leaves an `accepted` verdict on the same `event_id` as the first FORGED payload.

## Verdict

DOES-NOT-SUPPORT. The artifact supports the Route 2 isolated-settings outcomes as internal transcripts and supports the uncovered-path limitation as a disclosure. It does not support treating nonce possession, or an accepted receipt, as proof that the intended hook fired, and it does not distinguish a receipt sent by that hook from a receipt sent by another process that can write the socket and copy the expected fields.

## UNVERIFIED

- Faithfulness of every `packages/engine/...` line citation to tree `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` (repository excluded by the registered brief).
- Nonce generation, delivery channel, readers, single-use rule, and any unquoted intake check.
- Socket path, permissions, and authentication.
- Independent SHA-256 of `pretool-receipt-hook.mjs` versus expected `8354a7b3…`.
- Whether Route 3b planted `bashEventIds` / a prior receipt in-process rather than running Claude.
- Runner logs behind 1,532 / 24 / 72 / 5-of-5 test counts and the 82.87% conductor coverage figure.
- Live `/home/monkey/.claude/settings.json` bytes at review time (live file, not in corpus).
- Any material outside the single supplied artifact.

No Lean stage: this lane reviewed a markdown artifact and touched no `lean/` file. Lean-file count against a branch range was not applicable; no worktree was cut.

state AT-GATE, repo velvetmonkey/mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", verdict "DOES-NOT-SUPPORT"
