python3 - <<'PY'
from pathlib import Path
import json, hashlib, re
root = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1")
text = (root/"hookcanary-report.md").read_text()
frozen = (root/"FROZEN_SHA").read_text().strip()
print("frozen", frozen)
print("report_sha256", hashlib.sha256(text.encode()).hexdigest())
print("pushed_equals_frozen", frozen in text and frozen == "f23d8af4a67dc916fbd0b5606606b9c72e0ef036")
print("1436+24+72", 1436+24+72)
print("controls", re.findall(r"^CONTROL .*$", text, re.M))
print("forgeries", re.findall(r"^FORGERIES_.*$", text, re.M))
dec = json.JSONDecoder(); i=0; objs=[]
while i < len(text):
    if text[i]=="{":
        try:
            o,e = dec.raw_decode(text,i); objs.append(o); i=e; continue
        except json.JSONDecodeError: pass
    i+=1
for o in objs:
    if "terminal_status" in o:
        print(o["terminal_status"], o.get("reason"), o.get("bash_event_ids"), o.get("receipt_event_ids"), o.get("rejected_receipts"))
forged=[]
for m in re.finditer(r"FORGED (\{.*\})", text):
    forged.append(json.loads(m.group(1)))
verdict=[o for o in objs if o.get("turn_id")=="04586aa3-8246-496d-bd85-2df151402d46" and "terminal_status" in o][0]
print("first_forged_id", forged[0]["event_id"])
print("verdict_receipt_ids", verdict["receipt_event_ids"])
print("overlap", forged[0]["event_id"]==verdict["receipt_event_ids"][0])
PY
