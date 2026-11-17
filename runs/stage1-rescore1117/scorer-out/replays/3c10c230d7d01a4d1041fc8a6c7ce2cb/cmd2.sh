python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
block = text.split("## ROUTE 4a")[0].split("## ROUTE 3b")[1]
forged = [json.loads(m) for m in re.findall(r"^FORGED (\{.*\})$", block, re.M)]
verdict = json.loads(re.search(r"^VERDICT (\{.*\})$", block, re.M).group(1))
r3a = text.split("## ROUTE 3b")[0].split("## ROUTE 3a")[1]
print("bash_event_ids", verdict["bash_event_ids"])
print("receipt_event_ids", verdict["receipt_event_ids"])
print("rejected_receipts", verdict["rejected_receipts"])
print("terminal_status", verdict["terminal_status"])
for i, f in enumerate(forged, 1):
    print(i, "event_id=", f["event_id"], "nonce=", f["nonce"],
          "in_bash=", f["event_id"] in verdict["bash_event_ids"],
          "in_receipts=", f["event_id"] in verdict["receipt_event_ids"])
print("nonce_in_route_3a_section", "nonce" in r3a)
print("replay_in_route_3a_section", "replay" in r3a)
PY
