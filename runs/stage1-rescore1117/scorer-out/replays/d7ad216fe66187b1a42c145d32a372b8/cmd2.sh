python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
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
