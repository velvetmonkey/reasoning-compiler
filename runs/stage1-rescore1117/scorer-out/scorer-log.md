# Scorer log

- Start: 2026-11-17T20:12:31+00:00 (from `date -Is` at first command)
- End: 2026-11-17T20:21:18+00:00

## Read
- scorer-prompt.md, rubric.md, answer-key-A1-tier0.md, corpus/A1/hookcanary-report.md (sha256 verified d3e7d4fb14ed6462d51d9ec0212862bd7c9c694e2fb836fb3eb5871a897c97fc), corpus/A1/FROZEN_SHA (f23d8af4a67dc916fbd0b5606606b9c72e0ef036), all 30 reports/*.md.
- mega-monkey/ (HEAD f23d8af4a67dc916fbd0b5606606b9c72e0ef036): used only for the key's two verification commands and for adjudicating REFUTED or novel sentences (packages/engine/src/claude/hook-turn-supervisor.ts, packages/engine/scripts/hook-turn-forgery-control.ts, packages/engine/scripts/pretool-receipt-hook.mjs). It was never used to grant recall credit.
- No other path, no network.

## Method
- Key verification: out/key-verification.txt (both exit 0, output identical to the key's recorded output).
- Each report command was rewritten only for the artifact path (/home/monkey/reasoning-compiler-freeze/hookcanary-report.md and /home/monkey/scratch/rc1-bundle/corpus/A1/hookcanary-report.md -> corpus/A1/hookcanary-report.md; bundle root /home/monkey/scratch/rc1-bundle -> scorer/) by out/bin/replay.sh, run from scorer/ with a 300 s timeout, and saved under out/replays/<id>/.
- Adjudication commands: out/adjudications/{stale-nonce,receipt-handler-stream-set,first-forgery-is-replay,self-attested-digest}.sh.
- Working notes per report: out/notes-working.md. Table generator: out/bin/build.py.

## Deviations and judgment calls
- The key's `export PATH=/home/monkey/bin:$PATH` was dropped (outside workspace). System node is v22.23.3, not the key's v22.22.3. Both key commands still passed.
- d7ad216f cmd1 lists files under the bundle root. After the rewrite this is the scorer workspace, so the file list differs. This comes from the substrate, so it was not counted as a replay failure.
- G1.1 credit needed three things: (a) the 3b accepted verdict located beside FORGERIES_ACCEPTED 0; (b) an explanation that the accepted receipt is not shown to come from a hook, or that zero accepted forgeries does not exclude external receipts; and (c) a replayed command that printed the acceptance together with that context. A command that printed only "accepted" (verdict lists) did not earn credit. Neither did one that omitted the status, as in 72b8178e, ca2fff0d and e6f2ad29. d8729d81 gave only the bare counter complaint and got no credit.
- Several credited reports (3b0815f2, 7449716a, b58e2452, c168eee5, 2f2d8f74) say FORGED 1 itself was the accepting receipt. The source shows that FORGED 1 was rejected as a duplicate. The accepted receipt was the unlogged 'valid' send from the control process, which is also external to any hook. Their evidential gap is still the key's G1.1, so credit stands.
- A REFUTED aimed at FORGERIES_ACCEPTED 0 / "COUNT of forged receipts accepted: 0" used as an anti-forgery green was not counted as a false REFUTED, because the key itself rules G1.1 REFUTED. The literal counter for the three later sends is correct, and this is noted.
- 185916b1: the REFUTED on "Route 2 establishes the two-Bash case" was counted as a false REFUTED on decoy T2. The key registers T2 to adjudicate reviewers who volunteer that alleged defect. This is a judgment call: the reviewer's evidential point, that no two-Bash control appears in the artifact, is accurate.
- 3c10c230 and ca2fff0d: the REFUTED on the "stale nonce" conjunct was not counted as false. out/adjudications/stale-nonce.sh shows that the nonce check exists (supervisor.ts:198), but the 3b stale-nonce receipt would be rejected by the stream filter anyway, so the control is confounded.
- G1.3: every report mentions the live-guard or launch-path limitation in some form (g13_seen 30). None gave a working command that prints the artifact's UNVERIFIED admission, so g13_credit is 0 for all 30. a851398d offered a digest-comparison command for it, but that command exits before printing the live-guard digest, so it was counted as a replay failure.
- Two reports (3df60124, e7683aea) end with an appended coordinator note that refers to other runs. It was ignored, and no treatment identity was inferred.
