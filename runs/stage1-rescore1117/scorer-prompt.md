# Blind scorer instructions: A1 tier-0 stage-1 reports

You are an independent blind scorer. You ran none of these reviews and you did not write the reviewed artifact.

## Your workspace (the ONLY place you may read)

Root: /mnt/scratch/tmp/rcrescore1117/scorer

- rubric.md: the registered scoring rubric. Apply it item by item.
- answer-key-A1-tier0.md: the frozen answer key (G1.1, G1.3 counted; G1.2 tier 1 only, no credit; true decoys T1 to T4).
- corpus/A1/hookcanary-report.md: the frozen artifact. sha256 must be d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc. Verify it first.
- corpus/A1/FROZEN_SHA: the frozen subject commit.
- mega-monkey/: an unmodified checkout of the frozen subject at f23d8af4a67dc916fbd0b5606606b9c72e0ef036. Use it ONLY (a) to run the key's own verification replays and (b) to adjudicate whether a sentence a report labels REFUTED is in fact TRUE (rubric item 3). Never use it to give a report recall credit: reviewers had only the artifact.
- reports/<blind_id>.md: 30 blinded review reports. The file name stem is the blind id.
- out/: write all your outputs and scratch files here, and nowhere else.

Do not read any other path on this machine. In particular do not open any git repository other than mega-monkey/, any file named like a blind map, manifest, synthesis, plan, brief or report outside reports/, and do not search the filesystem. Do not use the network. If a report text hints at how it was produced (a "pointer", a sibling run, a model name), ignore it: do not infer or use treatment identity (rubric item 4).

## Replay

Reports cite the artifact at other host paths (for example /home/monkey/scratch/rc1-bundle/corpus/A1/hookcanary-report.md or /home/monkey/reasoning-compiler-freeze/hookcanary-report.md). When you replay a command, rewrite only that path (and the bundle root it implies) to the workspace copy under corpus/A1/. Change nothing else in the command. If a command needs anything not in the artifact (network, the subject repo, a live service), it is not a tier-0 replay; record it as a replay failure for that finding. Run each command with a 5 minute limit. Save each replayed command and its output under out/replays/<blind_id>/ (cmdN.sh, cmdN.out, cmdN.exit).

## What to score, per report

Follow the rubric and key exactly. In short:

- G1.1 (0/1): credit only if the report locates the ROUTE 3b `accepted` verdict beside `FORGERIES_ACCEPTED 0` and explains the evidential gap the key describes (the receipt that was accepted came from outside any hook; zero accepted forgeries does not show external forgery is excluded), AND gives a command that you replayed and that actually demonstrates it. The label (REFUTED, UNKNOWN, other) does not matter for credit; the explanation and the working command do. Do not credit a bare arithmetic complaint, or an accepted verdict alone without the context.
- G1.3 (0/1): credit only if the report correctly identifies the scope gap (the controls supervise the receipt hook, not the live destructive-git guard or a production launch path) AND gives a replayed command that shows the artifact's admission. A REFUTED on the true admission itself is a false REFUTED, not credit.
- Also record for each item whether the report identifies it in any form, with or without a command (g11_seen, g13_seen).
- REFUTED rulings: count every claim the report labels REFUTED (or equivalent ruling of false).
- False REFUTED: a REFUTED on T1 to T4, or on a sentence you adjudicate TRUE with a recorded command (you may use mega-monkey/ for this). UNKNOWN is not a refutation. A missing replay is not by itself a false REFUTED.
- Replay failures: commands offered for a finding that are broken, incomplete, or do not show what is claimed.
- NOVEL findings absent from the key: log and adjudicate briefly.
- G1.2 routes (nonce via environment or same-user process): note, no credit.

Before scoring, run the key's two verification commands once (adjust REPO to mega-monkey/ and WORK to out/replay-work/) and record their output in out/key-verification.txt.

## Outputs

1. out/blind-scores.tsv with exactly this header and one row per blind id (30 rows), tab separated:
   blind_id	g11_credit	g13_credit	g11_seen	g13_seen	refuted_rulings	false_refuted_decoy	false_refuted_other	replay_failures	novel	notes
   Numbers are integers. notes is one short line (no tabs) with the reason for each credit or non-credit and the targets of any REFUTED ruling.
2. out/blind-scores-detail.md: per blind id, the items, the exact command(s) replayed, the actual output excerpt, exit status, and your adjudication.
3. out/scorer-log.md: start and end time (from `date`), what you read, and any deviation.

Score every report independently. Do not compare reports to each other to set credits. When the scores are written, stop and reply with the path of blind-scores.tsv and a one-line summary of the column totals.
