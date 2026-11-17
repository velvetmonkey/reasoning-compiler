python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
sec = text.split("## ROUTE 3b",1)[1].split("## ROUTE 1a",1)[0]
block = re.search(r"```text\n(.*?)```", sec, re.S).group(1)
forged=[]
for line in block.splitlines():
    if line.startswith("FORGED "):
        forged.append(json.loads(line[7:]))
    elif line.startswith("FORGERIES_"):
        print(line)
    elif line.startswith("VERDICT "):
        v=json.loads(line[8:])
        print("terminal_status", v["terminal_status"])
        print("bash_event_ids", v["bash_event_ids"])
        print("receipt_event_ids", v["receipt_event_ids"])
        print("rejected_receipts", v["rejected_receipts"])
        print("first_forged_event_id", forged[0]["event_id"])
        print("first_forged_sha_equals_expected", forged[0]["hook_sha256"]==v["expected_hook_sha256"])
        print("first_forged_equals_kept_receipt", forged[0]["event_id"]==v["receipt_event_ids"][0])
        print("implied_receipts_processed", v["rejected_receipts"]+len(v["receipt_event_ids"]))
print("n_forged", len(forged))
print("forged_event_ids", [f["event_id"] for f in forged])
print("second_forged_event_id_in_bash", forged[1]["event_id"] in v["bash_event_ids"])
PY
