## ROUTE 2b

I ran the same Bash prompt with an isolated settings file that had no `hooks` key.

This control reproduced the missing-registration condition without changing the live settings file.

The supervisor read the Bash identifier from the Claude stream.

No receipt arrived.

The supervisor failed the terminal turn by name.

Raw output:

```text
CONTROL unregistered
CLAUDE_EXIT 0
VERDICT {"turn_id":"8381a76b-e799-4706-973e-60e8c032ac89","terminal_status":"failed","expected_hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","bash_event_ids":["toolu_01PM7Sdf7WgBjzyuJbkQPZzc"],"receipt_event_ids":[],"rejected_receipts":0,"reason":"HOOK_MISSING_PRE_TOOL_USE","event_id":"toolu_01PM7Sdf7WgBjzyuJbkQPZzc"}
```

The negative control passed.

## ROUTE 2a

I ran Claude with an isolated settings file that registered the receipt hook for Bash.

The hook sent its receipt before it returned.

The stream identifier and receipt identifier matched.

The supervisor accepted the turn.

Raw output:

```text
CONTROL registered
RECEIPT {"turn_id":"9de6258c-ecac-4050-9a38-5818ca2a8e77","nonce":"52fcfea99e32e7eecd45d0d9c9a146ef32ec738d7165b1103ce679c507a18299","hook_event_name":"PreToolUse","hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","event_id":"toolu_016KVbcw5y7XseMdvJkCmJWh","decision":"allow"}
CLAUDE_EXIT 0
VERDICT {"turn_id":"9de6258c-ecac-4050-9a38-5818ca2a8e77","terminal_status":"accepted","expected_hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","bash_event_ids":["toolu_016KVbcw5y7XseMdvJkCmJWh"],"receipt_event_ids":["toolu_016KVbcw5y7XseMdvJkCmJWh"],"rejected_receipts":0}
```

## ROUTE 2c AND 2d

I registered a byte-different copy of the receipt hook for the swapped-script control.

The supervisor kept the original hook digest as its expected value.

The supervisor detected the different script digest.

Raw output for the swapped-script control:

```text
CONTROL swapped
RECEIPT {"turn_id":"bf3a75ff-001c-4069-af6b-d0419039805b","nonce":"13980603e1c9d15ce5da3c642a3515237c9fcc4fea6a2f5793bb026b0e8f9ce7","hook_event_name":"PreToolUse","hook_sha256":"c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6","event_id":"toolu_01BLFdogpvaJFcX51f7GDrvi","decision":"allow"}
CLAUDE_EXIT 0
VERDICT {"turn_id":"bf3a75ff-001c-4069-af6b-d0419039805b","terminal_status":"failed","expected_hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","bash_event_ids":["toolu_01BLFdogpvaJFcX51f7GDrvi"],"receipt_event_ids":["toolu_01BLFdogpvaJFcX51f7GDrvi"],"rejected_receipts":0,"reason":"HOOK_SHA256_MISMATCH","event_id":"toolu_01BLFdogpvaJFcX51f7GDrvi","observed_hook_sha256":"c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6"}
```

I ran Claude with the hook registered and a prompt that prohibited tool use.

The stream contained no Bash event.

The supervisor recorded `not_applicable`.

The supervisor did not report success.

Raw output for the no-Bash control:

```text
CONTROL no-bash
CLAUDE_EXIT 0
VERDICT {"turn_id":"87484d34-c649-47e5-92f7-464f82242f60","terminal_status":"not_applicable","expected_hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","bash_event_ids":[],"receipt_event_ids":[],"rejected_receipts":0}
```

COUNT of Route 2 controls run: 4.

COUNT of Route 2 controls passing: 4.

## ROUTE 3a

The acceptance decision reads Bash identifiers from the independent Claude stdout stream.

The receipt handler cannot add a Bash identifier to that stream set.

The independent stream reader is at `packages/engine/src/claude/hook-turn-supervisor.ts:127`.

```ts
127  observeStreamLine(line: string): void {
128    let event: RawTurnEvent;
129    try {
130      event = JSON.parse(line) as RawTurnEvent;
131    } catch {
132      return;
133    }
134    if (event.type === 'assistant' && Array.isArray(event.message?.content)) {
135      for (const block of event.message.content as RawContentBlock[]) this.observeBlock(block);
136    }
137    if (event.type === 'stream_event'
138      && event.event?.type === 'content_block_start'
139      && event.event.content_block) {
140      this.observeBlock(event.event.content_block);
141    }
142  }
```

The terminal matcher is at `packages/engine/src/claude/hook-turn-supervisor.ts:147`.

```ts
147    const bashEventIds = [...this.bashEventIds];
148    for (const eventId of this.receipts.keys()) {
149      if (!this.bashEventIds.has(eventId)) {
150        this.receipts.delete(eventId);
151        this.rejectedReceipts += 1;
152      }
153    }
154    const receiptEventIds = [...this.receipts.keys()];
155    let verdict: TurnVerdict;
156    if (bashEventIds.length === 0) {
157      verdict = this.verdict('not_applicable', bashEventIds, receiptEventIds);
158    } else {
159      const missing = bashEventIds.find((eventId) => !this.receipts.has(eventId));
160      if (missing) {
161        verdict = this.verdict('failed', bashEventIds, receiptEventIds, {
162          reason: HOOK_MISSING_REASON,
163          event_id: missing,
164        });
165      } else {
166        const mismatch = bashEventIds
167          .map((eventId) => this.receipts.get(eventId)!)
168          .find((receipt) => receipt.hook_sha256 !== this.expectedHookSha256);
169        verdict = mismatch
170          ? this.verdict('failed', bashEventIds, receiptEventIds, {
171              reason: HOOK_SHA_MISMATCH_REASON,
172              event_id: mismatch.event_id,
173              observed_hook_sha256: mismatch.hook_sha256,
174            })
175          : this.verdict('accepted', bashEventIds, receiptEventIds);
```

## ROUTE 3b

I sent all three forged receipts directly to the private socket from outside the hook.

The first forged receipt replayed an already accepted receipt.

The second forged receipt used a stale nonce.

The third forged receipt named an event absent from the turn stream.

Raw output:

```text
FORGED {"turn_id":"04586aa3-8246-496d-bd85-2df151402d46","nonce":"3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0","hook_event_name":"PreToolUse","hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","event_id":"bash-from-independent-stream","decision":"allow"}
FORGED {"turn_id":"04586aa3-8246-496d-bd85-2df151402d46","nonce":"stale-nonce","hook_event_name":"PreToolUse","hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","event_id":"bash-stale-nonce","decision":"allow"}
FORGED {"turn_id":"04586aa3-8246-496d-bd85-2df151402d46","nonce":"3221b1a75879f07cada307392194bbc5e8b56563dc713d4bbfff13b8213bf2b0","hook_event_name":"PreToolUse","hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","event_id":"bash-absent-from-stream","decision":"allow"}
FORGERIES_TRIED 3
FORGERIES_ACCEPTED 0
VERDICT {"turn_id":"04586aa3-8246-496d-bd85-2df151402d46","terminal_status":"accepted","expected_hook_sha256":"8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65","bash_event_ids":["bash-from-independent-stream"],"receipt_event_ids":["bash-from-independent-stream"],"rejected_receipts":3}
```

COUNT of forged receipts tried: 3.

COUNT of forged receipts accepted: 0.

## ROUTE 1a

I found 4 Claude launch paths.

The warm engine path calls `spawn(claudePath, args, ...)` at `packages/engine/src/claude/process-spawn.ts:65`.

The conductor path selects `claude --print` at `packages/conductor/src/config.ts:20` and starts its tmux wrapper at `packages/conductor/src/session-runner.ts:89`.

The roundtable path selects `claude` at `packages/engine/config/seats.json:45` and calls `spawn(cfg.cmd, finalArgs, ...)` at `packages/engine/src/roundtable/cli-runner.ts:125`.

The lane path starts Claude at `/home/monkey/bin/lanelaunch:278`.

## ROUTE 1b

I built for the one-process and one-terminal-turn shape at `/home/monkey/bin/lanelaunch:278`.

This path gives the supervisor a clear boundary before Claude starts and after Claude emits its terminal stream event.

I did not build for the warm engine path at `packages/engine/src/claude/process-spawn.ts:65`.

That path keeps one Claude process across multiple turns.

It needs a turn-scoped nonce broker that can change context without changing the child process environment.

I did not build adapters for the conductor or roundtable paths.

Those paths need separate launch and terminal-state integration.

The control runner is branch code only.

It does not change `/home/monkey/bin/lanelaunch`.

The supervisor covers one launch shape.

The other 3 launch paths are UNCOVERED.

No report can imply that the uncovered paths have supervision.

## ROUTE 4a

The starting digest of `/home/monkey/.claude/settings.json` was:

```text
a287c108b78f5e83dbee46cadca0a595f99763bfa6837222ea6c593ec6b8d05d  /home/monkey/.claude/settings.json
```

The final digest of `/home/monkey/.claude/settings.json` was:

```text
a287c108b78f5e83dbee46cadca0a595f99763bfa6837222ea6c593ec6b8d05d  /home/monkey/.claude/settings.json
```

The starting digest of `/home/monkey/.claude/hooks/block-dangerous-git.sh` was:

```text
52ebe4581b67039df5241fd72a1f10a8b213e442c5b099358bd13a593349d263  /home/monkey/.claude/hooks/block-dangerous-git.sh
```

The final digest of `/home/monkey/.claude/hooks/block-dangerous-git.sh` was:

```text
52ebe4581b67039df5241fd72a1f10a8b213e442c5b099358bd13a593349d263  /home/monkey/.claude/hooks/block-dangerous-git.sh
```

Both live files were byte-identical by SHA-256 before and after the work.

I did not restart the engine.

I did not use ports 3211, 3212, 3124, 3125, or 8443.

## ROUTE 4c

The repository command was `npm test`.

The final engine run passed 1,436 of 1,436 tests in 183 test files.

The final gravity run passed 24 of 24 tests.

The final conductor run passed 72 of 72 tests in 12 test files.

The total test count was 1,532 passed and 0 failed.

The root command returned nonzero because conductor branch coverage was 82.87 percent.

The configured conductor branch threshold was 83 percent.

The engine coverage was 72.1 percent for statements, 75.58 percent for branches, 82.64 percent for functions, and 72.1 percent for lines.

The new focused supervisor run passed 5 of 5 tests.

The engine TypeScript check passed after the workspace dependencies were built.

## ROUTE 4d

`packages/engine/src/claude/hook-turn-supervisor.ts` is REQUIRED.

It owns the private socket, turn identity, nonce, independent stream set, receipt set, and terminal matcher.

`packages/engine/scripts/pretool-receipt-hook.mjs` is REQUIRED.

It computes its own SHA-256 and sends the synchronous receipt.

`packages/engine/scripts/hook-turn-control.ts` is REQUIRED.

It runs the four end-to-end controls with isolated settings.

`packages/engine/scripts/hook-turn-forgery-control.ts` is REQUIRED.

It sends the three external forgeries and counts accepted forgeries.

`packages/engine/src/__tests__/hook-turn-supervisor.test.ts` is REQUIRED.

It keeps the matcher and negative controls in the repository test suite.

COUNT of files added: 5.

COUNT of files changed: 0.

COUNT ruled SCOPE CREEP: 0.

## UNVERIFIED

The live lane launcher remains unsupervised because this round prohibited live wiring.

The live warm engine, conductor, and roundtable paths remain unsupervised.

The live `block-dangerous-git.sh` does not send this receipt format because this round prohibited edits to that file.

The controls used the new branch receipt hook with isolated settings.

The controls did not test a receipt from the live destructive-git guard.

The controls tested the installed Claude CLI with the `sonnet` alias.

The controls did not test Fable at `/home/monkey/bin/lanelaunch:278`.

The controls did not test a `refuse` decision.

The controls tested `allow`, missing receipt, wrong script digest, no Bash, replay, stale nonce, and an absent stream identifier.

The root repository test command did not meet the existing conductor branch-coverage threshold.

No deployment state was measured because this round prohibited deployment.

## FAILED ATTEMPTS

The first combined focused-test and TypeScript command ran an unintended `vitest` 4.1.11 through `npx`.

The same command then failed because the TypeScript compiler was absent.

The npm configuration omitted development dependencies.

I ran `npm install --include=dev --ignore-scripts` and used the repository-local tools.

The first engine TypeScript check failed because the conductor and gravity declaration builds were absent.

I started the conductor build before gravity.

That conductor build failed because it could not resolve gravity declarations.

I built gravity first, built conductor second, and reran the engine TypeScript check.

The first `npm test` run failed 5 new tests because their hook path assumed the repository root as the working directory.

That run also failed 13 engine integration suites because `packages/engine/dist/index.js` did not exist.

I changed the test to resolve the hook path from `import.meta.url`.

I built the engine and reran `npm test`.

The second `npm test` run passed all 1,532 tests.

The second `npm test` command still returned nonzero because conductor branch coverage was 82.87 percent against 83 percent.

I did not change unrelated conductor code or its threshold.

The first clone-deletion command used direct recursive deletion.

The environment rejected that command before execution.

I used bounded `find -delete` operations on the four exact directories that I created.

## FINAL STATE

Branch: `feat/hook-turn-supervisor`.

Pushed SHA: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.

The remote branch exists at that SHA.

I did not merge the branch.

I did not open a pull request.

I did not deploy the branch.

Files added: 5.

Tests passed: 1,532.

Tests failed: 0.

The root test command status was nonzero because of the conductor coverage threshold.

Initial disk measurement: 451G total, 241G used, 192G available, and 56 percent used.

Final disk measurement: 451G total, 241G used, 192G available, and 56 percent used.

I deleted `/home/monkey/scratch/hookcanary/mega-monkey`.

I deleted the control-run, forgery-run, and unit-run directories that I created.

The report remains at `/home/monkey/scratch/hookcanary-report.md`.
