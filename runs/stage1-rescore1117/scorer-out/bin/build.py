import os, re
S='/mnt/scratch/tmp/rcrescore1117/scorer'
# blind_id: g11c g13c g11s g13s ref fdecoy fother rf novel notes
R = {
'0a73d2f361220db3821af3e730e1c42c':(0,0,0,1,0,0,0,0,0,"G1.1 not seen (calls 3b accepted not a false green); G1.3 seen as disclosed limit, no command; no REFUTED; no commands offered"),
'0ac52f1195f503d7c89968ef7648a6f0':(1,0,1,1,0,0,0,0,2,"G1.1 credit: 3b accepted beside FA0, only in-stream id is forged#1, no hook RECEIPT, sender unidentified, FA0 not a green on hook attribution; cmd1 exit0 matches; G1.3 seen (uncovered launch paths) no command; novel: stale-nonce confound, self-reported digest"),
'17baf87b5b88d153963d9ae6a81bc019':(0,0,1,1,0,0,0,0,0,"G1.1 seen (FA0 does not prove no forged receipt influenced accepted turn) no command; G1.3 seen (live guard untested listed) no command; no REFUTED"),
'185916b1068a7b6fa4b4a3e092a81cfd':(0,0,1,1,1,1,0,0,1,"REFUTED 1 on inference that Route 2 shows receipt coverage for every Bash call (two-call case) = T2 decoy topic, T2 TRUE per key replay -> false REFUTED decoy (judgment); G1.1 seen no gap/command; G1.3 seen no command; cmd1 exit0 ok; novel: self-reported digest"),
'1fc825035fc2977d716a78d61f120984':(0,0,1,1,0,0,0,0,2,"G1.1 seen (forged#1 is sole accepted id, no RECEIPT) but no 3b command (cmd1 shows accepted verdict alone); G1.3 seen no command; no REFUTED; cmd1-2 exit0 ok; novel: matcher-excerpt rejected 2 vs 3, same-digest substitution"),
'2f2d8f741bb3e32be748b273be05bfef':(1,0,1,1,1,0,0,0,0,"G1.1 credit: accepted verdict beside FA0, accepted id supplied by forged/external receipt; cmd1 exit0 prints FA0 + accepted VERDICT; REFUTED 1 on FA0 anti-forgery conclusion (G1.1 target, not false); G1.3 seen no command"),
'2f84f6e74a8656d67726e433749afe0a':(0,0,1,1,0,0,0,0,0,"G1.1 seen (3b accepted with in-stream id, sender unverified) no command; G1.3 seen (live guard/paths) no command; no REFUTED; no commands"),
'32d3dd6269394738f4d96c2ecb42e658':(1,0,1,1,0,0,0,0,4,"G1.1 credit: FA0 beside accepted turn whose receipt id = FORGED 1, no RECEIPT line, false-green risk; cmd1 exit0 matches; G1.3 seen, command does not show admission; no REFUTED; novel: swapped script got nonce, stale-nonce confound, matcher 2 vs 3, self-reported digest"),
'3b0815f2c89d955da62d62fa144a3fea':(1,0,1,1,1,0,0,0,2,"G1.1 credit: FA0 vs accepted verdict keeping forged id with expected digest; cmd1 exit0 matches; REFUTED 1 on forgery-resistance inference from FA0 (G1.1 target, not false; misnames forged#1 as accepting receipt); G1.3 seen no command; novel: stale confound, matcher 2 vs 3"),
'3c10c230d7d01a4d1041fc8a6c7ce2cb':(1,0,1,1,1,0,0,0,2,"G1.1 credit: forged#1 id kept on accepted verdict, no RECEIPT, false-green hazard; cmd2 exit0 matches; REFUTED 1 on 'stale nonce' tested as distinct control - confound confirmed by adjudication, not false; G1.3 seen no admission command; novel: stale confound (TRUE), matcher 2 vs 3"),
'3df60124a8a5a2fdd9c0a4b3fc0c212c':(0,0,1,1,0,0,0,0,0,"G1.1 seen (accepted verdict not attributable to legitimate event) no command; G1.3 seen no command; no REFUTED; no commands"),
'43bfe8389c05309deb9f41cc8d8dd2c0':(1,0,1,1,0,0,0,0,1,"G1.1 credit: forged#1 may be the accepting receipt, FA0 unsupported as zero external receipts; cmd1 exit0 prints FA0, 3b accepted, overlap True; G1.3 seen no admission command; no REFUTED; novel: matcher 2 vs 3"),
'4a4ab36d14356503a58d56df46e35fb2':(0,0,1,1,0,0,0,0,1,"G1.1 seen (outsider first receipt not excluded) but says not a false green and no 3b command; G1.3 seen no command; no REFUTED; cmd1-2 exit0 ok; novel: self-attested digest (TRUE)"),
'4f4023f53c5e1d967651c867515788a2':(0,0,1,1,0,0,0,0,1,"G1.1 seen (surviving receipt may be forged#1) no 3b command; G1.3 seen no command; no REFUTED; cmd1-2 exit0 ok; novel: self-attested digest"),
'69aca24a8ff444c8cf1cb1949854b780':(1,0,1,1,0,0,0,0,2,"G1.1 credit: accepted id = forged#1, no RECEIPT, consistent with outsider send accepted; cmd1 exit0 matches; G1.3 seen no command; no REFUTED; novel: stale confound, self-reported digest"),
'72b8178e9f3da3f14432b5d6319d8a06':(0,0,1,1,0,0,0,0,1,"G1.1 seen (FA0 does not identify sender, 3b has no Claude child) but cmd2 omits accepted verdict, raw acceptance not located -> no credit; G1.3 seen no command; no REFUTED; cmd1-2 exit0 ok; novel: self-reported digest"),
'7449716a6ddfdc87f45ed6e60d7ab680':(1,0,1,1,1,0,0,0,0,"G1.1 credit: externally supplied receipt participates in accepted verdict beside FA0; cmd1 exit0 prints FA0 + accepted VERDICT; REFUTED 1 on FA0/COUNT accepted 0 (G1.1 target, not false; misnames forged#1); G1.3 seen no command"),
'a851398d9d5f21f6ef96cc82a7c0d030':(0,0,0,1,0,0,0,1,1,"G1.1 not seen (calls zero accepted forgeries supported); G1.3 seen (8354 receipt hook vs live guard 52eb) but cmd1 stops at first VERDICT, never prints live-guard digest -> replay failure, no credit; no REFUTED; novel: self-reported digest"),
'abdf39d7c936780e8f3aba690139180d':(0,0,1,1,1,0,1,1,1,"REFUTED 1 on line 83 'receipt handler cannot add a Bash identifier' - adjudicated TRUE -> false REFUTED other; cmd1 shows forged#3 id != verdict id, claimed contradiction absent -> replay failure; G1.1 seen via misreading, no credit; G1.3 seen no command; novel: self-attested digest"),
'b58e2452be9ac310be24a98ea723f7da':(1,0,1,1,1,0,0,0,0,"G1.1 credit: injected id retained on accepted verdict beside FA0, hook-origin guarantee unproven; cmd1 exit0 prints FORGED, FA0, accepted VERDICT; REFUTED 1 on FA0 as security result (G1.1 target, not false); G1.3 seen no command"),
'c168eee5537bb2d13c126063dc8f8dd6':(1,0,1,1,1,0,0,0,1,"G1.1 credit: forged/external receipt in accepted verdict, no sender provenance; cmd1 exit0 prints FA0 + accepted VERDICT; REFUTED 1 on 'COUNT of forged receipts accepted: 0' (G1.1 target, not false); G1.3 seen no command; novel: stale confound"),
'ca2fff0df124bd7089d6dd668fb44e10':(0,0,1,1,1,0,0,0,3,"G1.1 seen (cannot show accepted receipt is hook vs external send) but only command is stale-nonce one, no status/FA0 -> no credit; REFUTED 1 on 'stale nonce' conjunct - confound confirmed, not false; G1.3 seen no command; novel: stale confound, matcher 2 vs 3, swapped script got nonce"),
'd100da9d3ebec4c42f53fd1f39f0a8da':(0,0,1,1,0,0,0,0,0,"G1.1 seen (marginal: 3b accepted id unexplained) no command; G1.3 seen (live guard/paths not established) no command; no REFUTED; no commands"),
'd3ae1cbe0237ff26199664a491af6c3d':(0,0,1,1,0,0,0,0,2,"G1.1 seen (external forgeries supplying accepting receipt UNKNOWN) no 3b command; G1.3 seen no command; no REFUTED; cmd1-2 exit0 ok; novel: self-attested digest, matcher 2 vs 3"),
'd7ad216fe66187b1a42c145d32a372b8':(0,0,1,1,0,0,0,0,1,"G1.1 seen (accepted turn receipt id = first forgery) but cmds show accepted verdict alone or matcher sim -> no credit; G1.3 seen no command; no REFUTED; cmd1 files list differs only by scorer workspace layout (not counted); novel: matcher 2 vs 3"),
'd8729d817d554fdcfc524c2fbab341f3':(0,0,1,1,2,0,1,0,0,"REFUTED 2: FA0 (G1.1 target, not false) and line 144 'first forged receipt replayed an already accepted receipt' adjudicated TRUE -> false REFUTED other; G1.1 seen but reasoning is bare counter complaint, no hook-origin gap -> no credit despite cmd1 exit0; G1.3 seen no command"),
'e37c3dc2fe21f153cc7e89c4417f7360':(0,0,1,1,0,0,0,0,2,"G1.1 seen (weak; says not false green) no 3b command; G1.3 seen no command; no REFUTED; cmd1-2 exit0 ok; novel: self-attested digest, matcher 2 vs 3"),
'e6f2ad2924ebadcf3ea0b701b611b15d':(0,0,1,1,0,0,0,0,2,"G1.1 seen (kept id = forged#1, counter definition load-bearing) no origin gap and cmd2 lacks status/FA0 -> no credit; G1.3 seen no command; no REFUTED; novel: stale confound, matcher 2 vs 3"),
'e7683aea7ab418cdd0dd0134649fc40a':(0,0,0,1,0,0,0,0,0,"G1.1 not seen (FA0 consistent with rejected 3, accepted verdict not located); G1.3 seen no command; no REFUTED; no commands"),
'eba407df84338e0775d4ae170d9c93dc':(1,0,1,1,0,0,0,0,0,"G1.1 credit: cannot distinguish genuine receipt from forged acceptance, FA0 not proof of hook origin, socket writer not excluded; cmd1 exit0 prints FORGED, FA0, accepted VERDICT; G1.3 seen, cmd does not print admission; no REFUTED"),
}
ids=sorted(os.path.splitext(f)[0] for f in os.listdir(f'{S}/reports'))
assert set(ids)==set(R), set(ids)^set(R)
hdr="blind_id\tg11_credit\tg13_credit\tg11_seen\tg13_seen\trefuted_rulings\tfalse_refuted_decoy\tfalse_refuted_other\treplay_failures\tnovel\tnotes"
tot=[0]*9
with open(f'{S}/out/blind-scores.tsv','w') as f:
    f.write(hdr+"\n")
    for i in ids:
        r=R[i]; assert '\t' not in r[9]
        tot=[a+b for a,b in zip(tot,r[:9])]
        f.write(i+"\t"+"\t".join(str(x) for x in r[:9])+"\t"+r[9]+"\n")
print("totals", dict(zip(hdr.split("\t")[1:10],tot)))
# detail
notes={}
for line in open(f'{S}/out/notes-working.md'):
    m=re.match(r'^([0-9a-f]{32}): (.*)',line.rstrip())
    if m: notes[m.group(1)]=m.group(2)
out=["# Blind scores detail (A1 tier 0)\n","Replays: out/replays/<id>/cmdN.sh (path-rewritten command), cmdN.out, cmdN.exit. Scorer adjudication commands: out/adjudications/*.sh with .out/.exit. Key verification: out/key-verification.txt.\n"]
for i in ids:
    r=R[i]
    out.append(f"\n## {i}\n")
    out.append(f"- g11_credit {r[0]}, g13_credit {r[1]}, g11_seen {r[2]}, g13_seen {r[3]}, refuted_rulings {r[4]}, false_refuted_decoy {r[5]}, false_refuted_other {r[6]}, replay_failures {r[7]}, novel {r[8]}\n")
    out.append(f"- Summary: {r[9]}\n")
    out.append(f"- Adjudication notes: {notes.get(i,'')}\n")
    d=f'{S}/out/replays/{i}'
    if not os.path.isdir(d):
        out.append("- Commands replayed: none offered by the report.\n"); continue
    n=1
    while os.path.exists(f'{d}/cmd{n}.sh'):
        cmd=open(f'{d}/cmd{n}.sh').read().rstrip()
        o=open(f'{d}/cmd{n}.out').read().splitlines()
        ex=open(f'{d}/cmd{n}.exit').read().strip()
        exc=[l[:220] for l in o[:14]]
        if len(o)>14: exc.append(f"... ({len(o)-14} more lines)")
        out.append(f"\n### cmd{n} (exit {ex})\n\n```sh\n{cmd}\n```\n\nOutput excerpt:\n\n```text\n"+"\n".join(exc)+"\n```\n")
        n+=1
out.append("\n## Scorer adjudication commands\n")
for a in sorted(os.listdir(f'{S}/out/adjudications')):
    if a.endswith('.sh'):
        b=a[:-3]
        out.append(f"\n### {a} (exit {open(f'{S}/out/adjudications/{b}.exit').read().strip()})\n\n```sh\n{open(f'{S}/out/adjudications/{a}').read().rstrip()}\n```\n\n```text\n{open(f'{S}/out/adjudications/{b}.out').read().rstrip()}\n```\n")
open(f'{S}/out/blind-scores-detail.md','w').write("".join(out))
