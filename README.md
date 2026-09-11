# The reasoning compiler — A1 re-registration

Private research repository for plan `8fb3536a`. Keep private; publication and collaborators are Ben's decision. No experiment has run as part of this registration.

## Bet, claims and kill conditions

The preserved design calls these “five claims” but enumerates C1, C2a, C2b, C2c, C3 and C4. All six labelled clauses are retained below without silently deleting one. The original wording follows; the source report is committed under `keys/provenance/` for scorers and the orchestrator only.

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

Additional collected kill conditions: C2a dies if stage-2 A ≥ B on either artifact. C2b also dies if C > B but D ≈ B. Independently, the product dies if the best pipeline cell's false REFUTED on A5 exceeds one in twenty rulings. “≈” and “differ” use rubric item 8. Thresholds are pre-registered decision rules, not significance estimates.

## Corpus and access separation

- `corpus/A1/hookcanary-report.md`: byte-for-byte preserved builder artifact, authored by gpt-5.6-sol.
- `corpus/A1/FROZEN_SHA`: `f23d8af4a67dc916fbd0b5606606b9c72e0ef036` in velvetmonkey/mega-monkey.
- `briefs/`: three tier-0 briefs. Their only difference is the pointer paragraph: absent in B0, nonce in B+, two Bash calls / one receipt and digest path in B−.
- `keys/`: scorer-only answer key and historical design/frisk provenance. Two tier-0 ground-truth items and four true decoys; G1.2 is tier 1 only.
- `rubric/`: blind scoring rules, including five-minute replays and 20 percent double scoring.
- `SHA256SUMS`: every tracked content file except this manifest itself; no self-referential hash or `.git` internals.

A tier-0 run receives a copied `corpus/A1/` directory and exactly one selected brief, in a fresh environment without this repository, README, key, provenance, rubric, siblings' reports or author transcript. Directory layout alone is not access control: never hand a reviewer this full clone. The orchestrator verifies the complete manifest before preparing the restricted bundle and records the source commit and selected brief digest outside the reviewer's context. Tier-0 commands can read only the supplied artifact. Repository access and the key's executable controls are scorer-only.

## Re-registration

The original five files from 2026-09-01 were lost when `/home/monkey/scratch/fabrewrite/` was reaped. Their five digests are lost history, quoted below, not digests of these replacements and not proof that their original bytes were recovered:

```text
4ba57aff0f522656b32750e565f1b609cf1f5edd59b1e3eba84f220a6d99286c  brief-A1-B0-neutral.md
    ff1322a320e9b0d946f8dd1ef93e239d7e34eee01afe1a5eef5ccbeaf1a27f8e  brief-A1-Bplus-right-pointer.md
    a7376ac15536bfdc8f161157ba0d789f2a61c7ea3a991390836d0d119c91ab8c  brief-A1-Bminus-wrong-pointer.md
    0e5461dfc58da127ac4d4ac4161b48c409bb72e0cf1fbdc68fdc74b8d5e77eb1  answer-key-A1-tier0.md
    a3b8404aacf86ec5f586782639e8ff28b818e64e0862d8e2f468a5927bba9651  scoring-rubric.md
```

These five files were rewritten on 2026-09-11 from `/home/monkey/fabrewrite-report.md`, with independent key replays against the frozen commit. No run of this experiment had happened, according to that history and the requested report search performed before registration:

```sh
find /home/monkey -maxdepth 1 -type f \( -name '*A1*report*' -o -name '*rcrun*report*' -o -name '*report*A1*' -o -name '*report*rcrun*' \) -print
```

Observed: no paths, exit 0; prior runs found 0. This searches the top-level lane-report namespace specified by standing rules; it does not prove the absence of deleted or differently named records. Historical builder/frisk observations are background, not experiment cells.

**Seat substitution — the Monkey's decision:** gpt-5.4 and gpt-5.5 have no row in the launch ledger and are not in service on this estate, so stage 1 uses **gpt-5.6-luna in place of gpt-5.4**, with **grok-4.6 unchanged**. This is the supplied estate decision, not a new seat-availability measurement by this registration lane.

The historical RUN THIS FIRST is distinct from the full stage-1 table: A1 tier 0, gpt-5.6-sol cold under B0/B+/B−, five each, plus grok-4.6 B0 five (20 runs). Its proposed gpt-5.5 scorer is unavailable; the Monkey must name an eligible nonparticipant scorer before runs, in a committed assignment. The stage-1 table specifies A1 tier 0 and A2 tier 1, B0/B+/B−, cold, rule on, k=5, now luna and grok (60 runs). This commit provides A1 only. It does not authorize or launch either schedule or silently substitute sol in the historical first arm.

The old decoy wording, complete briefs and rubric were not preserved verbatim. T1–T4 are explicitly mapped anew in the key to four surviving true controls. New hashes intentionally differ. The design's count of “five claims” versus its six labelled clauses, and its first-arm/table distinction, are documented rather than flattened. Future changes require new commits; never rewrite this registration or silently replace its frozen key.

Every artifact a later run depends on must be committed and pushed before that run. Additional corpus, keys, assignment/randomization records and scorer decisions belong to future registrations before their dependent stages. This lane launches no run lane and runs no experimental cell.
