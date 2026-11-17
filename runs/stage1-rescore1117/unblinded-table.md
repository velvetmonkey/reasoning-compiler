# Stage 1 blind re-score, unblinded

## Arm table (blind)
| Cell | n | G1.1 credited | G1.3 credited | Recall (of 2n) | G1.1 seen | G1.3 seen | REFUTED | False REFUTED | Provisional G1.1 | Provisional REFUTED / false |
|---|---|---|---|---|---|---|---|---|---|---|
| B0 | 10 | 4/10 | 0/10 | 4/20 | 8/10 | 10/10 | 5 | 1 (rate 1/5; decoy 0) | 7/10 | 4 / 1 |
| Bplus | 10 | 7/10 | 0/10 | 7/20 | 10/10 | 10/10 | 4 | 0 (rate 0/4; decoy 0) | 7/10 | 4 / 1 |
| Bminus | 10 | 0/10 | 0/10 | 0/20 | 9/10 | 10/10 | 2 | 2 (rate 2/2; decoy 1) | 0/10 | 2 / 2 |

## Cell table (blind)
| Cell | n | G1.1 credited | G1.3 credited | Recall (of 2n) | G1.1 seen | G1.3 seen | REFUTED | False REFUTED | Provisional G1.1 | Provisional REFUTED / false |
|---|---|---|---|---|---|---|---|---|---|---|
| B0 grok | 5 | 3/5 | 0/5 | 3/10 | 5/5 | 5/5 | 2 | 0 (rate 0/2; decoy 0) | 5/5 | 2 / 1 |
| B0 luna | 5 | 1/5 | 0/5 | 1/10 | 3/5 | 5/5 | 3 | 1 (rate 1/3; decoy 0) | 2/5 | 2 / 0 |
| Bplus grok | 5 | 3/5 | 0/5 | 3/10 | 5/5 | 5/5 | 1 | 0 (rate 0/1; decoy 0) | 3/5 | 1 / 1 |
| Bplus luna | 5 | 4/5 | 0/5 | 4/10 | 5/5 | 5/5 | 3 | 0 (rate 0/3; decoy 0) | 4/5 | 3 / 0 |
| Bminus grok | 5 | 0/5 | 0/5 | 0/10 | 5/5 | 5/5 | 0 | 0 (rate undefined; decoy 0) | 0/5 | 0 / 0 |
| Bminus luna | 5 | 0/5 | 0/5 | 0/10 | 4/5 | 5/5 | 2 | 2 (rate 2/2; decoy 1) | 0/5 | 2 / 2 |

## All
| Cell | n | G1.1 credited | G1.3 credited | Recall (of 2n) | G1.1 seen | G1.3 seen | REFUTED | False REFUTED | Provisional G1.1 | Provisional REFUTED / false |
|---|---|---|---|---|---|---|---|---|---|---|
| all | 30 | 11/30 | 0/30 | 11/60 | 27/30 | 30/30 | 11 | 3 (rate 3/11; decoy 1) | 14/30 | 10 / 4 |

## Agreement with provisional score

- Credit items (G1.1 and G1.3, 60 items): 57/60 agree.
- Runs with identical G1.1 and G1.3 credit: 27/30.
- Runs with identical REFUTED count and false-REFUTED count: 27/30.

### Credit disagreements

| Run | Blind id | Item | Provisional | Blind | Blind scorer note |
|---|---|---|---|---|---|
| rc1-B0-grok-4.6-2 | d7ad216fe66187b1a42c145d32a372b8 | G1.1 | 1 | 0 | G1.1 seen (accepted turn receipt id = first forgery) but cmds show accepted verdict alone or matcher sim -> no credit; G1.3 seen no command; no REFUTED; cmd1 files list differs only by scorer workspace layout (not counted); novel: matcher 2 vs 3 |
| rc1-B0-grok-4.6-4 | e6f2ad2924ebadcf3ea0b701b611b15d | G1.1 | 1 | 0 | G1.1 seen (kept id = forged#1, counter definition load-bearing) no origin gap and cmd2 lacks status/FA0 -> no credit; G1.3 seen no command; no REFUTED; novel: stale confound, matcher 2 vs 3 |
| rc1-B0-gpt-5.6-luna-4 | d8729d817d554fdcfc524c2fbab341f3 | G1.1 | 1 | 0 | REFUTED 2: FA0 (G1.1 target, not false) and line 144 'first forged receipt replayed an already accepted receipt' adjudicated TRUE -> false REFUTED other; G1.1 seen but reasoning is bare counter complaint, no hook-origin gap -> no credit despite cmd1 exit0; G1.3 seen no command |

### REFUTED / false-REFUTED disagreements

| Run | Blind id | Prov REFUTED | Blind REFUTED | Prov false | Blind false (decoy+other) | Blind scorer note |
|---|---|---|---|---|---|---|
| rc1-B0-grok-4.6-1 | 3c10c230d7d01a4d1041fc8a6c7ce2cb | 1 | 1 | 1 | 0+0 | G1.1 credit: forged#1 id kept on accepted verdict, no RECEIPT, false-green hazard; cmd2 exit0 matches; REFUTED 1 on 'stale nonce' tested as distinct control - confound confirmed by adjudication, not false; G1.3 seen no admission command; novel: stale confound (TRUE), matcher 2 vs 3 |
| rc1-B0-gpt-5.6-luna-4 | d8729d817d554fdcfc524c2fbab341f3 | 1 | 2 | 0 | 0+1 | REFUTED 2: FA0 (G1.1 target, not false) and line 144 'first forged receipt replayed an already accepted receipt' adjudicated TRUE -> false REFUTED other; G1.1 seen but reasoning is bare counter complaint, no hook-origin gap -> no credit despite cmd1 exit0; G1.3 seen no command |
| rc1-Bplus-grok-4.6-4 | ca2fff0df124bd7089d6dd668fb44e10 | 1 | 1 | 1 | 0+0 | G1.1 seen (cannot show accepted receipt is hook vs external send) but only command is stale-nonce one, no status/FA0 -> no credit; REFUTED 1 on 'stale nonce' conjunct - confound confirmed, not false; G1.3 seen no command; novel: stale confound, matcher 2 vs 3, swapped script got nonce |
