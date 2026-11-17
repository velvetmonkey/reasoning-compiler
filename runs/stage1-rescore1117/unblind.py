import csv, sys, collections
MAP='/home/monkey/.mega-monkey/rc1-answer-key-quarantine/scratch-keys/stage1-blind-map.tsv'
B='/mnt/scratch/tmp/rcrescore1117/scorer/out/blind-scores.tsv'
P='/mnt/scratch/tmp/rcrescore1117/analysis/provisional.tsv'
m={r['report_id']:r['run_id'] for r in csv.DictReader(open(MAP),delimiter='\t')}
b={r['blind_id']:r for r in csv.DictReader(open(B),delimiter='\t')}
p={r['run_id']:r for r in csv.DictReader(open(P),delimiter='\t')}
assert len(b)==30 and set(b)==set(m), (len(b), set(m)^set(b))
rows=[]
for bid,run in m.items():
    s=b[bid]; arm=run.split('-')[1]; seat='luna' if 'luna' in run else 'grok'; k=run.rsplit('-',1)[1]
    I=lambda x:int(s[x])
    rows.append(dict(run=run,bid=bid,arm=arm,seat=seat,k=k,g11=I('g11_credit'),g13=I('g13_credit'),g11s=I('g11_seen'),g13s=I('g13_seen'),
        ref=I('refuted_rulings'),fd=I('false_refuted_decoy'),fo=I('false_refuted_other'),rf=I('replay_failures'),nov=I('novel'),notes=s['notes'],
        pg11=int(p[run]['g11']),pg13=int(p[run]['g13']),pref=int(p[run]['refuted']),pf=int(p[run]['false_decoy'])+int(p[run]['false_other'])))
out=open('unblinded-runs.tsv','w')
out.write('run_id\tblind_id\tg11_credit\tg13_credit\tg11_seen\tg13_seen\trefuted\tfalse_refuted_decoy\tfalse_refuted_other\treplay_failures\tnovel\tprov_g11\tprov_g13\tprov_refuted\tprov_false_refuted\n')
for r in rows:
    out.write('\t'.join(str(r[x]) for x in ['run','bid','g11','g13','g11s','g13s','ref','fd','fo','rf','nov','pg11','pg13','pref','pf'])+'\n')
def table(key):
    g=collections.OrderedDict()
    for r in rows: g.setdefault(key(r),[]).append(r)
    lines=['| Cell | n | G1.1 credited | G1.3 credited | Recall (of 2n) | G1.1 seen | G1.3 seen | REFUTED | False REFUTED | Provisional G1.1 | Provisional REFUTED / false |','|---|---|---|---|---|---|---|---|---|---|---|']
    for c,rs in g.items():
        S=lambda x:sum(r[x] for r in rs); fr=S('fd')+S('fo'); n=len(rs)
        rate=f"{fr}/{S('ref')}" if S('ref') else 'undefined'
        lines.append(f"| {c} | {n} | {S('g11')}/{n} | {S('g13')}/{n} | {S('g11')+S('g13')}/{2*n} | {S('g11s')}/{n} | {S('g13s')}/{n} | {S('ref')} | {fr} (rate {rate}; decoy {S('fd')}) | {S('pg11')}/{n} | {S('pref')} / {S('pf')} |")
    return '\n'.join(lines)
order={'B0':0,'Bplus':1,'Bminus':2}
rows.sort(key=lambda r:(order[r['arm']],r['seat'],r['k']))
md=['## Arm table (blind)',table(lambda r:r['arm']),'','## Cell table (blind)',table(lambda r:f"{r['arm']} {r['seat']}"),'','## All',table(lambda r:'all')]
# agreement
dis=[]; agree_items=0
for r in rows:
    for item,a,b_ in [('G1.1',r['pg11'],r['g11']),('G1.3',r['pg13'],r['g13'])]:
        if a==b_: agree_items+=1
        else: dis.append((r['run'],r['bid'],item,a,b_,r['notes']))
runs_agree=sum(1 for r in rows if r['pg11']==r['g11'] and r['pg13']==r['g13'])
ref_agree=sum(1 for r in rows if r['pref']==r['ref'] and r['pf']==r['fd']+r['fo'])
md+=['',f'## Agreement with provisional score','',f'- Credit items (G1.1 and G1.3, 60 items): {agree_items}/60 agree.',f'- Runs with identical G1.1 and G1.3 credit: {runs_agree}/30.',f'- Runs with identical REFUTED count and false-REFUTED count: {ref_agree}/30.','','### Credit disagreements','','| Run | Blind id | Item | Provisional | Blind | Blind scorer note |','|---|---|---|---|---|---|']
md+=[f'| {a} | {b_} | {c} | {d} | {e} | {f} |' for a,b_,c,d,e,f in dis]
md+=['','### REFUTED / false-REFUTED disagreements','','| Run | Blind id | Prov REFUTED | Blind REFUTED | Prov false | Blind false (decoy+other) | Blind scorer note |','|---|---|---|---|---|---|---|']
md+=[f"| {r['run']} | {r['bid']} | {r['pref']} | {r['ref']} | {r['pf']} | {r['fd']}+{r['fo']} | {r['notes']} |" for r in rows if not (r['pref']==r['ref'] and r['pf']==r['fd']+r['fo'])]
open('unblinded-table.md','w').write('# Stage 1 blind re-score, unblinded\n\n'+'\n'.join(md)+'\n')
print('\n'.join(md))
