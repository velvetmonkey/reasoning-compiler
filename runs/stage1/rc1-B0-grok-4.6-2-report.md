DONE, cold A1 review of the granted hookcanary artifact at frozen sha f23d8af4a67dc916fbd0b5606606b9c72e0ef036.

# A1 cold review

Evidence corpus: `/home/monkey/scratch/rc1-B0-grok-2-bundle/` only (`corpus/A1/hookcanary-report.md` and `corpus/A1/FROZEN_SHA`). Local read-only commands on those files are the only extra evidence. No repository, network, GitHub, launcher, model, or product control was used. The product suite was not run: the grant forbids product controls; suiterun was therefore not invoked.

Labels: **PROVEN** = the artifact itself contains the fact. **TESTED** = a quoted dump is internally consistent with the sentence; the run is not independently reproduced. **ASSUMED** = author setup or inference without artifact-level proof. **UNKNOWN** = not established and not contradicted. **REFUTED** = none in this review. A missing independent reproduction is not a refutation.

## Artifact identity

- **PROVEN**: `FROZEN_SHA` is `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` plus a newline.
- **PROVEN**: FINAL STATE "Pushed SHA: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`" equals that frozen SHA.
- **PROVEN**: sha256 of bundled `hookcanary-report.md` is `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc` (377 lines).
- **PROVEN**: the bundle contains exactly those two files.
- **UNKNOWN**: that the SHA exists on a remote, that branch `feat/hook-turn-supervisor` exists, or that cited source files exist at cited line numbers.

Replay:

```sh
python3 - <<'PY'
from pathlib import Path
import hashlib
p = Path("/home/monkey/scratch/rc1-B0-grok-2-bundle")
frozen = (p/"corpus/A1/FROZEN_SHA").read_text().strip()
text = (p/"corpus/A1/hookcanary-report.md").read_text()
print("frozen", frozen)
print("pushed_in_report", frozen in text)
print("report_sha256", hashlib.sha256(text.encode()).hexdigest())
print("files", sorted(str(x.relative_to(p)) for x in p.rglob("*") if x.is_file()))
PY
```

Expected: frozen `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`; `pushed_in_report True`; report sha256 `d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc`; files `corpus/A1/FROZEN_SHA` and `corpus/A1/hookcanary-report.md`.

## Route 2 — four isolated-settings controls

Quoted dumps parse as JSON. The four control turn IDs are distinct. Expected hook digest is `8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65` except the swapped-script observed digest.

### 2b unregistered

Quoted VERDICT: `terminal_status=failed`, `reason=HOOK_MISSING_PRE_TOOL_USE`, bash id `toolu_01PM7Sdf7WgBjzyuJbkQPZzc`, empty receipts, `rejected_receipts=0`, `CLAUDE_EXIT 0`.

- **TESTED**: "No receipt arrived" and "The supervisor failed the terminal turn by name" match the dump.
- **TESTED**: "The negative control passed" holds if pass means the supervisor failed the turn, not that Claude exited nonzero.
- **ASSUMED**: isolated settings with no `hooks` key, and that this control did not change live settings.
- **UNKNOWN**: that the bash id came from a live Claude stream.

### 2a registered

RECEIPT and VERDICT share turn id `9de6258c-ecac-4050-9a38-5818ca2a8e77` and event id `toolu_016KVbcw5y7XseMdvJkCmJWh`. Receipt digest equals expected digest. `terminal_status=accepted`.

- **PROVEN** inside the dump: stream identifier and receipt identifier match.
- **TESTED**: "The supervisor accepted the turn."
- **UNKNOWN**: "The hook sent its receipt before it returned" (no timestamps).
- **ASSUMED**: isolated settings registered the receipt hook for Bash.

### 2c swapped script

RECEIPT digest `c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6`; VERDICT expected digest stays `8354a7b3…`; `terminal_status=failed`, `reason=HOOK_SHA256_MISMATCH`; same event id on bash and receipt; `rejected_receipts=0`.

- **PROVEN**: the two 64-hex strings differ, so they are not the same SHA-256.
- **TESTED**: original expected digest kept; different observed digest detected. A same-id receipt with `rejected_receipts=0` matches the quoted matcher’s digest-mismatch branch.
- **ASSUMED**: the registered file was a byte-different copy of the receipt hook.

### 2d no Bash

VERDICT: `not_applicable`, empty bash and receipt lists, `CLAUDE_EXIT 0`.

- **TESTED**: no Bash event recorded; supervisor recorded `not_applicable`.
- **TESTED**: "The supervisor did not report success" if success means `accepted`.
- **ASSUMED**: the prompt prohibited tool use.

### Route 2 counts

- **PROVEN**: four `CONTROL` lines (`unregistered`, `registered`, `swapped`, `no-bash`) match "COUNT of Route 2 controls run: 4."
- **TESTED**: "COUNT of Route 2 controls passing: 4" if each dump’s `terminal_status` is the intended outcome (failed / accepted / failed / not_applicable). No independent oracle is in the artifact.

Replay:

```sh
python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/home/monkey/scratch/rc1-B0-grok-2-bundle/corpus/A1/hookcanary-report.md").read_text()
objs=[]
for m in re.finditer(r"\{[^{}]*\}", text):
    try:
        o=json.loads(m.group(0))
    except Exception:
        continue
    if "terminal_status" in o:
        objs.append(o)
for o in objs:
    print(o.get("terminal_status"), o.get("reason"), o.get("bash_event_ids"), o.get("receipt_event_ids"), o.get("rejected_receipts"), o.get("observed_hook_sha256"))
print("control_lines", sum(1 for l in text.splitlines() if l.startswith("CONTROL ")))
exp="8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65"
obs="c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6"
print("digests_differ", exp!=obs)
PY
```

Expected statuses: `failed` (HOOK_MISSING_PRE_TOOL_USE), `accepted`, `failed` (HOOK_SHA256_MISMATCH, observed `c47dff14…`), `not_applicable`, then Route 3b `accepted`. `control_lines 4`. `digests_differ True`.

## Route 3a — quoted supervisor

Quoted `observeStreamLine` parses JSON lines and calls `observeBlock` on `assistant` content and `stream_event` / `content_block_start`. Quoted matcher: empty bash ids → `not_applicable`; missing receipt → `failed` with `HOOK_MISSING_REASON`; digest mismatch → `failed` with `HOOK_SHA_MISMATCH_REASON`; else `accepted`. Receipts whose event id is not in `bashEventIds` are deleted and increment `rejectedReceipts`.

- **TESTED**: that matcher is consistent with the four Route 2 dumps.
- **UNKNOWN**: that the code lives at `packages/engine/src/claude/hook-turn-supervisor.ts:127` and `:147` on the frozen SHA.
- **UNKNOWN**: `observeBlock`. No Bash-only filter is shown. The field name `bashEventIds` is not proof.
- **UNKNOWN**, not proven: "The receipt handler cannot add a Bash identifier to that stream set." The matcher does not copy receipt ids into `bashEventIds`, which is weaker than cannot add. The receipt handler is not quoted. Writing a forged stream line, or calling `observeBlock`, is not ruled out.
- **UNKNOWN**: whether `HOOK_MISSING_REASON` equals dump string `HOOK_MISSING_PRE_TOOL_USE`, and whether `HOOK_SHA_MISMATCH_REASON` equals `HOOK_SHA256_MISMATCH`.

This is a design claim stronger than the quoted evidence, not a false green in the Route 2 dumps.

## Route 3b — external forgeries

Three `FORGED` lines; `FORGERIES_TRIED 3`; `FORGERIES_ACCEPTED 0`; VERDICT `accepted` with bash and receipt ids `bash-from-independent-stream` and `rejected_receipts=3`. No `CLAUDE_EXIT` line. Event ids are synthetic, not `toolu_*`.

- **PROVEN**: three `FORGED` lines match "COUNT of forged receipts tried: 3."
- **TESTED**: first forged event id equals the VERDICT bash/receipt id; second nonce is the literal `stale-nonce`; third event id is `bash-absent-from-stream` and reuses the first nonce.
- **UNKNOWN**: "COUNT of forged receipts accepted: 0" as a supervisor fact. The accepted receipt id in the VERDICT is the first `FORGED` event id, and the dump never prints a separate legitimate `RECEIPT` (Route 2a did). The prose says the first forgery replayed an already accepted receipt; that prior receipt is not in the dump.
- **UNKNOWN**: `rejected_receipts=3` given the only quoted rejection rule. Applying that matcher to a map of the three forged event ids yields `rejected_receipts=2` and keeps `bash-from-independent-stream`. Getting 3 requires unquoted intake logic (replay / nonce).

Replay of the matcher-only gap. This does not refute the dump; it shows the quoted snippet does not produce the quoted count:

```sh
python3 - <<'PY'
exp="8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65"
bash={"bash-from-independent-stream"}
receipts={
  "bash-from-independent-stream": exp,
  "bash-stale-nonce": exp,
  "bash-absent-from-stream": exp,
}
rejected=0
for event_id in list(receipts):
    if event_id not in bash:
        del receipts[event_id]
        rejected += 1
print("rejected", rejected)
print("remaining", list(receipts))
print("quoted_rejected_receipts", 3)
print("quoted_forgeries_accepted", 0)
PY
```

Expected: `rejected 2`, remaining `['bash-from-independent-stream']`.

Coverage limit, not a false sentence: Route 3b does not show a live Claude stream, does not show nonce/replay code, and uses synthetic ids. It does not independently prove the Route 3a injection invariant.

## Route 1a / 1b — launch paths

- **PROVEN** as a list of four named paths: warm engine `process-spawn.ts:65`, conductor `config.ts:20` / `session-runner.ts:89`, roundtable `seats.json:45` / `cli-runner.ts:125`, lane `/home/monkey/bin/lanelaunch:278`.
- **UNKNOWN**: that these are all Claude launch paths, or that the citations are correct on the frozen SHA.
- **TESTED** as disclosure: did not build for warm engine; no conductor or roundtable adapters; control runner is branch code only; does not change `lanelaunch`; other 3 paths UNCOVERED; "No report can imply that the uncovered paths have supervision."
- **ASSUMED**: "I built for the one-process and one-terminal-turn shape at `lanelaunch:278`" as design intent. The same report says `lanelaunch` was not changed and was not tested.

These are accurately disclosed limitations, not false greens.

## Route 4a — live files / ports / engine

Quoted start and final digests of `settings.json` are both `a287c108b78f5e83dbee46cadca0a595f99763bfa6837222ea6c593ec6b8d05d`. Quoted start and final digests of `block-dangerous-git.sh` are both `52ebe4581b67039df5241fd72a1f10a8b213e442c5b099358bd13a593349d263`.

- **PROVEN**: each quoted pair of hex strings is equal.
- **UNKNOWN**: that those strings were measured from those live paths.
- **UNKNOWN**: engine not restarted; ports 3211, 3212, 3124, 3125, 8443 unused.

## Route 4c — tests and coverage

- **PROVEN** as arithmetic: 1436 + 24 + 72 = 1532.
- **TESTED** as author report: engine 1436/1436 in 183 files; gravity 24/24; conductor 72/72 in 12 files; focused supervisor 5/5; engine coverage 72.1 / 75.58 / 82.64 / 72.1; conductor branches 82.87% vs 83%; root command nonzero for that threshold.
- **UNKNOWN**: that those runs occurred; that the 5 focused tests sit inside the 1436 (the only way 1532 stays consistent); coverage percentages.
- Not a false green: the report does not claim the root `npm test` command passed.

Replay: `python3 -c 'print(1436+24+72)'` expected `1532`.

Disk: 241 / (241+192) = 55.66%, which rounds to the quoted 56% used. used+available = 433 against total 451 (18G leftover) is a reserved-block gap, not a contradiction. **PROVEN** as internal rounding; **UNKNOWN** as a real `df` reading.

## Route 4d — files in scope

Five REQUIRED paths named: `hook-turn-supervisor.ts`, `pretool-receipt-hook.mjs`, `hook-turn-control.ts`, `hook-turn-forgery-control.ts`, `hook-turn-supervisor.test.ts`. Counts: added 5, changed 0, scope creep 0.

- **PROVEN**: five REQUIRED files are named, matching "COUNT of files added: 5."
- **ASSUMED**: "COUNT of files changed: 0" and "COUNT ruled SCOPE CREEP: 0" relative to a base the artifact does not show. FAILED ATTEMPTS describes editing the new test’s hook path; that is compatible with changed 0 if only new files were committed.
- **UNKNOWN**: file contents at the frozen SHA; that the test file "keeps the matcher and negative controls in the repository test suite"; that the supervisor file "owns the private socket, turn identity, nonce" (quoted matcher shows receipts and bash ids, not socket or nonce).

## FAILED ATTEMPTS / FINAL STATE

FAILED ATTEMPTS is process narrative (npx vitest, missing tsc, `--include=dev`, gravity-before-conductor, `import.meta.url`, missing engine dist, coverage nonzero, rejected recursive delete, bounded `find -delete`). **UNKNOWN** as history; it does not contradict the Route 2 dumps.

FINAL STATE: branch `feat/hook-turn-supervisor`; pushed SHA matches FROZEN_SHA (**PROVEN** as text match); remote exists (**UNKNOWN**); no merge, no PR, no deploy (**UNKNOWN**); tests 1532/0 (**UNKNOWN** as runs; arithmetic **PROVEN**); root command nonzero (**TESTED** as disclosure); clones deleted (**UNKNOWN**); report remains at `/home/monkey/scratch/hookcanary-report.md` (**UNKNOWN**; that path is outside this grant).

## What holds

As self-consistent quoted results, not as independently executed controls:

1. Four Route 2 dumps match the four stated outcomes: missing registration fails; matching receipt accepts; swapped digest fails with SHA mismatch; no Bash is `not_applicable`.
2. The author does not claim live lanelaunch, warm engine, conductor, roundtable, or `block-dangerous-git.sh` are supervised.
3. The author does not claim the root test command is green.
4. Frozen SHA and pushed SHA match.
5. Quoted live-file digests are unchanged as quoted.

## What does not hold as proven

1. Estate-wide or live-path hook supervision. The report itself forbids that inference.
2. "The receipt handler cannot add a Bash identifier to that stream set."
3. Route 3b as a complete anti-forgery proof: synthetic ids, no Claude exit line, accepted turn whose receipt id equals the first printed forgery, `rejected_receipts=3` unexplained by the quoted matcher.
4. Any claim that requires the mega-monkey tree, GitHub, test runners, live settings files, or sockets.

No sentence in the artifact was demonstrated false. Several security and completeness sentences are stronger than the evidence. That is an unsupported inference / coverage limit, not a refutation.

## Lean / suite / brake

No Lean build started. This lane has no repository worktree and no `lean/` diff to count. `command -v lake` printed `/home/monkey/bin/lake` after `export PATH=/home/monkey/bin:$PATH`. lean worker count 0; clang worker count 0; lake parent not started. Product suite not run (grant forbids product controls; the estate rule is the invocation method when a suite is run, not a requirement to run one against this corpus). Resource brake not applied; work was read-only on two small files.

## UNVERIFIED

- Whether the quoted dumps were produced by mega-monkey at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036`.
- Source at every cited path and line number, including `observeBlock`, receipt intake, nonce/replay, and the five REQUIRED files.
- Isolated settings contents; that Claude `sonnet` was the binary; receipt-before-return ordering.
- Completeness of the four launch-path search.
- Live `df`, live settings files, ports, engine restart, remote branch, deletion of scratch clones.
- Test runner totals, coverage percentages, and whether the 5 focused tests are inside the 1436.
- How `bash-from-independent-stream` entered the bash-id set in Route 3b, and how `rejected_receipts` became 3.
- Anything outside `/home/monkey/scratch/rc1-B0-grok-2-bundle/`.

## Verdict

The report’s evidence supports its bounded conclusions: four isolated Route 2 control dumps are internally consistent with the stated pass/fail story, live-path coverage is disclosed as absent, and the root test command is disclosed as nonzero on conductor branch coverage. It does not support a conclusion that mega-monkey at `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` now supervises live Claude launches, or that the receipt handler cannot inject bash identifiers. No claim is REFUTED from the artifact alone.

run_id rc1-B0-grok-4.6-2; did not access anything outside /home/monkey/scratch/rc1-B0-grok-2-bundle/.
state AT-GATE, repo mega-monkey, head-sha "f23d8af4a67dc916fbd0b5606606b9c72e0ef036", run_id rc1-B0-grok-4.6-2, grant "/home/monkey/scratch/rc1-B0-grok-2-bundle", outside-access no, lean-build no, lake "/home/monkey/bin/lake", suite-run no, verdict "bounded Route 2 dumps hold; live supervision not shown"
