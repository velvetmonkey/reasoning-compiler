# fabrewrite report — seat claude-fable-5-1, round 2

Forensic, repair lane. Nothing installed, nothing changed. Round 1
(`fabcompiler-report.md`) is accepted and not repeated. Pre-registration
artifacts are in `/home/monkey/scratch/fabrewrite/` (three briefs, one answer
key, one rubric, `SHA256SUMS`). Their digests are in this report so the
registration is dated before any run. Sunset: delete after checkpointing to
plan 8fb3536a-1c89-4b0a-b26f-0d663bd8ecc7.

Short form, for the checkpoints:

- The bet is restated as five claims, each with a kill result. Two of the
  plan's three components are cut as written and replaced by the thing they
  were standing in for: the five-word vocabulary becomes "every REFUTED carries
  a replay", and "different model family" becomes "not the author's context",
  with vendor pool kept only as a separately testable rider.
- The active ingredient, on today's record, is the hypothesis written into the
  brief, delivered to a reader without the author's context. Model quality is
  second. Vendor is unmeasured and probably nothing. If that holds, the product
  is not a compiler; it is a defect-class library with a dispatcher, and the
  estate already has the prototype under three names.
- The ratchet is fixed by freezing the defect set per round, scoring by a blind
  seat, and letting novel findings enter only the next round's key.
- Run first: 20 read-only lanes, one afternoon, no Fable quota. The author's own
  model, cold, under three briefs, against the builder's own report.
- If model quality explains everything: no product. A practice and a benchmark
  survive, and neither is sellable on its own.

---

## THE RESTATED BET

Preamble that is scope, not a claim: the corpus is artifacts where at least one
shipped sentence is false while the test suite is green. That is an inclusion
criterion for what we test on. It is no longer a component of the bet, because
"a green suite misses" is a fact about the artifact, not about the pipeline.

**THE BET.** On such artifacts, a review run that (a) has none of the author's
context, (b) is handed a brief that names a defect class to falsify, and (c)
must attach a replayable command to every REFUTED, finds more of a
pre-registered defect set and makes fewer false refutations than the strongest
single model available reading cold with a neutral brief and no rules. Each of
(a), (b), (c) contributes measurably. The vendor of the reviewer contributes
nothing beyond (a).

Each component, with the result that kills it. "Differ" and "≈" are defined in
the rubric (`scoring-rubric.md` item 8): two ground-truth items across k=5, or
two false REFUTEDs.

**C1. THE REPLAY RULE** (replaces the grammar). Claim: requiring every REFUTED
to carry a command a stranger can run halves the false-REFUTED count relative
to the same seat, same brief, without the rule, and costs at most one
ground-truth item of recall. Kill: false-REFUTED totals ≈ across the G0 and G2
arms on the seeded artifact A5, or recall drops by two or more items. Then the
rule is a reporting format and is dropped from the bet.

**C2a. SEPARATION.** Claim: a cold session of the author's own model finds at
least twice the ground-truth items that a session preloaded with the author's
transcript finds. Kill: cell A (author context) ≥ cell B (cold, same seat). Then
the author can review its own work, and the whole "stranger" framing dies.

**C2b. VENDOR** (replaces "different model family", which the estate could not
define; family here means vendor pool: OpenAI, xAI, Anthropic, which is what
`lanelaunch` actually dispatches on). Claim: a cold cross-vendor reviewer finds
more than a cold same-vendor reviewer, and the effect reverses when the author
is Claude-family (interaction). Kill: B ≈ C on either artifact A1 (GPT-authored)
or A4 (Fable-authored). One kill is enough. Then vendor is decoration and the
component is deleted, not reworded.

**C2c. THE BRIEF** (new, the rival hypothesis). Claim: a brief naming the
defect class that contains the ground truth raises recall over a neutral brief,
and a brief naming a class with no defect at that head lowers it below neutral.
Kill: B0 ≈ B+ ≈ B− on both A1 and A2. Then the orchestrator's hypothesis is not
the ingredient, and whatever is left of the bet is (a) plus model quality.

**C3. THE SUBSTRATE.** Claim: the same seat with the frozen repository open
makes at most one false REFUTED in five runs, while the same seat given the
documentation files alone makes three or more, and finds fewer ground-truth
items. Kill: docs-only ≈ with-repo on BOTH recall and false REFUTED. Then the
substrate buys nothing the model does not already carry, and the plan's second
falsifier has fired for real. This component is kept because the estate's own
record makes the kill plausible: the false green in A1 was visible in the
report with no code, and the coherence lanes found real defects by comparing
sentences to sentences.

**C4. NOT MODEL QUALITY** (the clause that makes it a product). Claim: the best
pipeline cell (a mid seat, cold, right-pointer brief, replay rule) matches or
beats the strongest single seat (Fable) cold with a neutral brief and no rule,
on recall and on false REFUTED, on all three artifacts. Kill: Fable-cold-neutral
≥ pipeline on recall and ≤ on false REFUTED on two of three artifacts. Then the
compiler is a prompt and the product is the model.

The bet as a whole is dead if C4 dies, or if C2a and C2c both die. It is alive
but renamed if C2b dies alone. It is a different product if C2c is the only
survivor, and that is the case I expect.

## COMPONENTS CUT

**The five-word vocabulary as a component.** PROVEN / REFUTED / TESTED /
ASSUMED / UNKNOWN stays as the report format and nothing more. It cannot carry
a falsifier the estate has not already run: `QUEUE-LOG.md:12262`, `:12755`,
`:13070` record the grammar slipping six times in one day in lanes whose briefs
carried it, and the Monkey's own line at 13070 is "the boilerplate is in every
brief and lanes keep breaking it anyway, so the rule needs to become a CHECK."
A vocabulary in a brief is a sentence, and the estate's own doctrine is that a
rule that exists only as a sentence is not a control. What the vocabulary was
standing in for is C1, which is a check.

**"Different model family" as training lineage.** Cut because it cannot be
stated on this estate: round 1 showed gpt-5.4 on gpt-5.6-luna called
"cross-family" in one brief and grok on gpt-5.6-sol called "CROSS-FAMILY" in
another. Replaced by vendor pool, which is measurable, and demoted to rider C2b
with a one-artifact kill.

**"Reading it as a hostile stranger."** An attitude is not a treatment. What
can be manipulated is (i) whether the reader has the author's context and (ii)
what the brief tells it to falsify. Those are C2a and C2c. The attitude word is
dropped.

**The market-boundary corollary** (code, contracts, filings, ESG data). Not
testable on this estate with these seats. It is scope, recorded on the plan as
the 2026-10-01 re-check, and it is not part of the bet.

**"A green suite and a single-model review both miss."** Becomes the corpus
inclusion criterion. As a claim it was already contradicted by the record:
single-model reviews found every defect in the corpus.

## THE ACTIVE INGREDIENT

**My belief: the brief.** Specifically, a hypothesis about a defect class,
written by the orchestrator after the previous round, handed to a reader who
does not share the author's context. Ranked: brief first, separation second,
model quality third, vendor at or near zero.

The argument from the record, each item checked by me today unless marked:

1. Same seat, brief changed, verdict flipped. `briefs/finalcold.md` (gpt-5.4,
   pointer: fences, prose "outside fenced blocks" as a secondary sweep) ruled
   MERGE on `1302806`. `briefs/runtimecold.md` (gpt-5.4, "this round is
   prose-first") ruled SEND BACK and found three more passages beyond the four
   it was handed. I confirmed the four sentences exist at `1302806`
   (`what-is-protected-right-now.md:44,255,259,261,265`) and the dead-token
   table at `when-something-looks-wrong.md:394-413` was already there. So the
   finalcold reviewer had every defect in front of it and a brief pointing
   elsewhere. Recall 0 of 8, then 7 of 8, same model id, eighty minutes apart.
2. The pointer's hit rate is the class's hit rate. `briefs/hookcanarycold.md:55-59`
   named the nonce; all three accepted forgeries were nonce inheritance.
   `briefs/coherencecold2.md` (per its report) pointed at derived values; the
   finding was a derived value that does not hash. `briefs/runtimecold.md:36`
   said "assume there is another"; there was.
3. The orchestrator already attributes the miss to the brief.
   `briefs/runtimecold.md:12-17`: "the earlier briefs pointed you at output
   fences, and these were prose."
4. The one in-report false green (A1, G1.1) needed no code, no execution, and
   no second vendor. It needed a reader who did not classify the first
   `send(valid)` as valid. I read `hook-turn-forgery-control.ts` at `f23d8af`
   today: the supervisor is started with no Claude child, the stream is faked
   with `observeStreamLine`, the "valid" receipt is sent by the script, and only
   the next three are counted. Separation alone should find this. That is the
   test I put first.

The honest evidence against me, and it is the reason C2b is a rider rather
than deleted outright:

5. Same brief, two seats, different precision. On `.cache/seal`, the Fable seat
   confirmed the literal-grep rationale and the GPT seat caught `bin/seal:18`
   building the path with `path.join`. Brief held constant, seat varied, result
   varied. n=1, on precision rather than recall, and consistent with "one seat
   read less" as much as with vendor.
6. The gpt-5.4 catch of the `.mcp.json` digest was a same-vendor catch of a
   gpt-5.6 builder's output. That cuts against vendor and for the brief, but
   it is also consistent with model quality if 5.4 happens to hash things.

**What would show I am wrong.** In the first arm: the author's own model, cold,
finds G1.1 at the same rate under all three briefs (B0 ≈ B+ ≈ B−). Then the
brief is not the ingredient; separation is, and the product collapses to
"fresh session, strong model". Or: the wrong pointer does not depress recall
(B− ≈ B0) while the right one raises it (B+ > B0). Then the brief is an
amplifier, not the ingredient, and amplifiers stack cheaply, so the product is
still separation plus the strongest model, with a checklist bolted on. Or, in
stage 5: Fable cold neutral beats every pointed cell. Then it is model quality
and the brief is a way of making a weaker model behave like a stronger one for
one round, which is worth something but is not a product.

**What it means if I am right.** The product is not a compiler. It is a
DEFECT-CLASS LIBRARY WITH A DISPATCHER: a growing list of adversarial
hypotheses, each born from a real found defect, each phrased as a pointer
("a grep absence is not a refutation", "the error text is a claim", "invent a
fourth", "assume there is another"), and a step that selects and writes them
into a cold reader's brief. The estate already runs the prototype under three
names: THE RAZOR, `briefs/_deadclaims`, and the lane-brief doctrine. That is a
better product than the compiler for two reasons. It is model-agnostic, so it
does not die when the strongest model changes hands. And it compounds: every
found defect adds a class, and the library is data no model vendor has. It is
a worse product for one reason: it is an operator's craft dressed as software,
and item 1 above shows the operator can point the wrong way and cost a whole
round.

## PRE-REGISTERED EXPERIMENT

All of this is written before any run. The A1 briefs, key and rubric are on
disk with these digests (`scratch/fabrewrite/SHA256SUMS`):

    4ba57aff0f522656b32750e565f1b609cf1f5edd59b1e3eba84f220a6d99286c  brief-A1-B0-neutral.md
    ff1322a320e9b0d946f8dd1ef93e239d7e34eee01afe1a5eef5ccbeaf1a27f8e  brief-A1-Bplus-right-pointer.md
    a7376ac15536bfdc8f161157ba0d789f2a61c7ea3a991390836d0d119c91ab8c  brief-A1-Bminus-wrong-pointer.md
    0e5461dfc58da127ac4d4ac4161b48c409bb72e0cf1fbdc68fdc74b8d5e77eb1  answer-key-A1-tier0.md
    a3b8404aacf86ec5f586782639e8ff28b818e64e0862d8e2f468a5927bba9651  scoring-rubric.md

Before the first lane launches, the orchestrator copies those digests into
`QUEUE.md` with a timestamp. Keys for A2 to A5 are written the same way, before
their stages, and their digests posted the same way.

### Corpus

Five artifacts, all frozen, all reachable today (I checked each SHA with
`git cat-file -t`, read-only).

**A1** mega-monkey `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` plus
`scratch/hookcanary-report.md` (377 lines). Author gpt-5.6-sol. Green: engine
1430 pass, conductor 72 pass; the one red is pre-existing on `fca07c3`. Key:
G1.1 in-report false green (report lines 157-158; the "valid" receipt is sent
by the control script with no hook process); G1.2 nonce inheritance, three
routes (tier 1 only); G1.3 the supervisor watches `pretool-receipt-hook.mjs`,
not the live guard (admitted in the builder's own UNVERIFIED). True decoys T1-T4
in the key. Right pointer: the nonce. Wrong pointer: two Bash calls, one
receipt, and the digest path, which the frisk showed do not false-green.

**A2** seal `1302806`, `docs/guide/what-is-protected-right-now.md` and
`docs/guide/when-something-looks-wrong.md`. Authors gpt-5.6-luna and
gpt-5.6-terra lanes on `docs/coherence-pass`, prose partly copied from Monkey
briefs. Green: 659 tests, only the deliberate pin red. Key, eight items:
line 44 "cached component that `seal verify` uses"; 255 "downloaded on demand";
259 "normal state of a fresh install"; 261 "cached and every file matches";
265 "delete `~/.cache/seal` and re-download"; `when-something-looks-wrong.md`
389-392 "obtains the pinned runtime"; 394-417 four tokens `seal verify`
cannot emit; 448-450 "same tokens whether installed command or standalone
checker". Refutation for all: `ensureRuntime` is defined at `bin/seal:259` and
has no caller (I re-checked at this SHA: one grep hit). True decoys: every
sentence `runtimecold-report.md` ruled TRUE at `61339f8` that is unchanged at
`1302806`, plus the `Runtime: present` and `integrity check failed` state
strings. Right pointer: prose, not fences. Wrong pointer: output fences, which
were clean at this head. The wrong-pointer cell already has one historical run
(finalcold: MERGE), which is logged as prior evidence and not counted.

**A3** seal `7955052`, `docs/guide/choosing-what-to-protect.md:62,165,166`,
the `.mcp.json` digest `0c49dc5f...` that does not hash from the page's own
JSON (I confirmed the three lines exist at this SHA; I did not re-hash). Key:
G3.1 the digest; G3.2 `docs/guide/README.md` "Every command shown here was
actually run". Optional artifact; used in stage 5 only.

**A4** oph-physics-sim `eccf59c`. Author Fable. The crossover artifact. Key:
G4.1 the freeze manifest schema checks shape only, so a post-freeze decision
rule edit passes validation while the template says a later operator cannot
bypass it; G4.2 `repository_head` is the base commit `3bc1dd1`, not the freeze
commit. Refutation for G4.1 is the `jsonschema` command in
`ophl10cold-report.md`. True decoys: the boundary held (no run, no seed), and
the preregistration-without-driver ruling SOUND. Right pointer: "is the freeze
surface a control or prose about a control". Wrong pointer: upstream
contamination and the execution boundary.

**A5** SEEDED. The Monkey takes a scratch copy of A2's two pages at `1302806`,
plants five false sentences of five types (a dead-code capability, a wrong
path, a wrong count, a state string the product never prints, an instruction
that cannot be followed) and five true sharp sentences as decoys, writes the
key, posts its digest to `QUEUE.md`, and hands lanes the copy plus the frozen
repository. This is the only artifact with a known-complete key, so it is the
only one on which false-REFUTED rate is a clean number. Nothing is written to
any repository.

### Ground-truth freeze, the ratchet fix

The key for a round is fixed when its digest is posted. A run that finds
something not in the key gets it logged as NOVEL, adjudicated by the scorer
with a recorded command, and entered into the NEXT round's key. It earns no
recall credit in the round that found it. A run that finds different or more
defects than the key is therefore visible, which the plan's original rule made
impossible.

### Scoring

`scoring-rubric.md`, in full on disk. The load-bearing rules: a finding counts
only with a replay the scorer can execute in five minutes from the report
alone; false REFUTED is a ruling of false on a decoy or on a sentence the
scorer adjudicates true with a recorded command; the scorer is a seat that ran
no cell of that stage, receives reports under random ids with brief text
stripped, and twenty percent are double-scored, with the rubric revised and
everything re-scored if the two scorers disagree on more than one in five.

### Arms

k = 5 runs per cell throughout. Lane duration measured today from brief mtime
to report mtime: 3 to 21 minutes for tier 0 and tier 1 frisks, median about 10.
Seven lanes ran concurrently this evening at load 2.27.

| stage | tests | artifacts | seats | factor varied | lanes |
|---|---|---|---|---|---|
| 1 | C2c brief | A1 tier 0, A2 tier 1 | gpt-5.4, grok-4.6 | B0 / B+ / B−, rule on, cold | 60 |
| 2 | C2a, C2b | A1, A4 | per cell below | context × vendor, B0, rule on | 40 |
| 3 | C1 rule | A5 | gpt-5.4 | G0 (no rule) vs G2 (replay rule), B0, cold | 10 |
| 4 | C3 substrate | A2 | gpt-5.4 | docs-only vs repo, B0, G2, cold | 5 (+5 reused) |
| 5 | C4 model | A1, A2, A4 | Fable | cold, B0, G0 | 15 |
| scoring | | | seat outside each stage | 10 reports per lane | ~15 |

Stage 2 cells, on each of A1 and A4: A = author context (the builder's own
transcript preloaded; for A1 that is
`.codex/sessions/2026/08/31/rollout-2026-08-31T23-44-44-*.jsonl`, which
exists), same vendor; B = cold, same vendor (A1: gpt-5.6-terra; A4: Fable, the
only Claude seat); C = cold, different vendor (A1: grok-4.6; A4: gpt-5.6-terra);
D = author transcript preloaded into the different vendor. Cell D is what
separates a vendor effect from context contamination wearing a vendor label.

Stage 5's comparator is the best pipeline cell from stages 1 to 3, chosen by
its stage-1 numbers before stage 5 launches, and named in `QUEUE.md` at that
time.

Total: about 145 run lanes and 15 scoring lanes, about 27 hours of lane time,
three days at five concurrent. Fable quota: 15 lanes plus at most 5 in stage 2.

### Kill conditions, collected

- C1 dies: stage 3 false-REFUTED totals ≈ between G0 and G2, or G2 recall two
  items lower.
- C2a dies: stage 2 A ≥ B on either artifact.
- C2b dies: stage 2 B ≈ C on either artifact, or C > B but D ≈ B.
- C2c dies: stage 1 B0 ≈ B+ ≈ B− on both artifacts.
- C3 dies: stage 4 docs-only ≈ repo on both recall and false REFUTED.
- C4 dies, and the bet with it: stage 5 Fable-cold-neutral ≥ pipeline on
  recall and ≤ on false REFUTED on two of three artifacts.
- Independently of the bet, the PRODUCT dies if the best pipeline cell's false
  REFUTED on A5 exceeds one in twenty rulings. That is the switch-off line
  both earlier seats set, and the manual run scored 3 sound of 5.

Every seat named exists on this estate: gpt-5.6-sol, gpt-5.6-terra,
gpt-5.6-luna, gpt-5.5, gpt-5.4, grok-4.6, claude-fable-5-1. gpt-5.5 and
gpt-5.6-luna are spare seats for scoring. No person, money or tool is needed
beyond `lanelaunch`, `tmux`, `sha256sum`, and `git` at frozen SHAs.

## RUN THIS FIRST

**The arm:** A1, tier 0, read-only. The author's own model, gpt-5.6-sol, in a
fresh session with nothing but the builder's report, under B0, B+ and B−, five
runs each. Plus grok-4.6 under B0, five runs, as the vendor comparator. Then
two scoring lanes on a seat that did not run (gpt-5.5).

**Cost:** 20 run lanes and 2 scoring lanes. Each lane reads one 377-line file
and writes one report; today's tier-0 lanes took 3 to 13 minutes. At five
concurrent that is about an hour of wall time, plus the hour it takes the
orchestrator to post the digests and fill the SEAT lines. No Fable quota. No
repository access, so no worktree, no disk, no risk to a live path. One
afternoon.

**Why this one moves belief most:** it is the single cell where round 1's
three confounds come apart at once on the cheapest artifact. Same model as
the author kills vendor as an explanation. No transcript tests separation.
Three briefs test the rival. And the defect (G1.1) is provably in the file:
line 158 says `accepted` on a run with no hook.

**What each outcome means**, reading sol's three cells and grok's one:

| sol B0 | sol B+ | sol B− | grok B0 | reading |
|---|---|---|---|---|
| high | high | high | any | Separation suffices for in-report defects. Vendor and brief are not the ingredient here. C2b is in trouble before stage 2 runs. |
| low | high | ≤ B0 | any | The brief is the ingredient. It turned the author's own model into the finder. Product = defect-class library with a dispatcher. Proceed to stage 1 on A2 to see if it holds with code. |
| low | high | ≈ B0 | any | The brief amplifies but does not blind. Product = separation plus the strongest model plus a checklist. Cheaper product, weaker moat. |
| low | low | low | high | A seat effect with the brief held constant. Run stage 5 (Fable B0) before believing it is vendor rather than quality. |
| low | low | low | low | Tier 0 is uninformative for this defect; the class needs driving. Repeat the same design at tier 1 on A1 with the diff, cost about three times. |
| any | any | ≥ 2 below B0 | any | The wrong hypothesis actively blinds. The orchestrator is load-bearing AND the main risk; a bad pointer costs more than none. That is a product finding on its own, and the finalcold run says to expect it. |

"High" means G1.1 found in three or more of five runs; "low" means one or
fewer. Two of five is read as neither, and the cell is re-run with k = 10.

## IF THE BET DIES

Suppose stage 5 returns Fable-cold-neutral beating every pipeline cell, and
stages 1 to 3 return flat. Model quality explains everything.

**What is dead:** the compiler, the three components, the vocabulary, vendor,
the brief as ingredient, and the sentence "not because of model quality". The
plan closes.

**What survives, honestly listed:**

1. **A benchmark.** Five artifacts with green suites, false shipped sentences,
   frozen SHAs, replayable refutations, a rubric and a blind scorer. That is
   real, and it is the only thing this plan has produced that does not depend
   on the bet. It is not a product. Benchmarks of this size are given away.
2. **A format.** REFUTED plus the command. Any model can emit it; nothing about
   it is defensible.
3. **A practice.** Cold reads, pre-registered keys, novel findings deferred to
   the next round. The estate should keep it whether or not anyone pays for it.
4. **Seal's existing guard scripts.** The "collapse into doctests" version of
   the idea already runs in the seal repository as fourteen hand-declared
   claim guards. That is the product that exists, and it is seal, not a new
   one.

**Is there a product?** No. If the strongest model cold with a neutral brief
matches everything the pipeline does, the thing being sold is a session of the
strongest model, and the vendor of that model sells it. A wrapper that adds a
vocabulary and a second vendor is a wrapper. The one asset that could outlive
a model change is the defect-class library, and in this world stage 1 has
shown pointers do not help, so the library is a notebook.

The intermediate world is the likely one, and it should be named so it is not
mistaken for a rescue: the brief helps (C2c lives), vendor does not (C2b dies),
and Fable cold is close to but below the pointed mid seat. Then there is a
product, it is the library and dispatcher, its moat is the library's growth
rate, and its ceiling is one strong-model release away. A product with a
six-month moat is still a product. It is not a compiler and it should stop
being called one.

## UNVERIFIED

Things I did not drive, and paths I read outside the brief's named ones:

- I read the repositories `/home/monkey/src/seal` and
  `/home/monkey/src/mega-monkey` read-only (`git cat-file`, `git show`,
  `git branch`) to confirm the SHAs exist and that the ground-truth lines are
  present at those SHAs. The brief named only `briefs/` and `QUEUE.md` as
  readable. Nothing was written. I also read the plan file under
  `obsidian/Ben/plans/2026-09/` and stat'd report mtimes for lane durations.
- G1.1's mechanism: I read `hook-turn-forgery-control.ts` at `f23d8af` and it
  starts the supervisor with no Claude child and sends `valid` from the
  script. I did not run it.
- G1.2's three routes and the socket mode: taken from `hookcanarycold-report.md`.
  Not re-driven. `scratch/hookcanarycold/` no longer exists.
- A2's decoy list depends on `runtimecold-report.md` rulings at `61339f8`
  being valid at `1302806` for the sentences that did not change between the
  two heads. I did not diff the two heads sentence by sentence; the key author
  must, before stage 1.
- A3: I confirmed the digest string appears at three lines of `7955052`. I did
  not re-hash the page's JSON; the refutation is `coherencecold2-report.md`'s.
- A4: taken from `ophl10cold-report.md`. I did not re-run the `jsonschema`
  tamper.
- The builder transcript for A1: the codex rollout file dated 23:44:44 on
  2026-08-31 matches the lane's launch time and greps for `hookcanary`. I did
  not open it to confirm it is the sol builder session rather than another
  lane that mentioned the word.
- Lane durations are brief-mtime to report-mtime, which undercounts if a brief
  was edited after launch and overcounts idle time before the seat started.
- Concurrency: "seven Fable lanes at load 2.27" is the Monkey's line at
  `QUEUE.md` 20:03 and 20:12. I did not measure load.
- Whether the release-notes catch (ckpt-a5677dd0, grok on gpt-5.6-terra) ran
  under a pointed or neutral brief. I did not find its brief. It is the one
  cross-vendor catch in the record I could not classify, so it neither
  supports nor cuts against the brief hypothesis here.
- Who authored the A2 prose. The plan says the Monkey wrote some sentences
  into briefs and lanes copied them. If the Monkey is Claude-family, cell B for
  A2 is not "same vendor as author" for those sentences. The key author must
  mark, per sentence, which lane wrote it.
- Every threshold in the rubric (two items, two false REFUTEDs, one in twenty,
  three of five) is a decision rule I chose, not a measured quantity. They are
  registered so they cannot move after the runs; they are not claimed to be
  optimal.
- Nothing in this report has been run. The experiment's first lane has not
  launched, and the digests above are the only thing that is dated.
