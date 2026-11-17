python3 -c '
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
for i, m in enumerate(re.finditer(r"^VERDICT (\{.*\})$", text, re.M), 1):
    v = json.loads(m.group(1))
    print(i, len(v["bash_event_ids"]), len(v["receipt_event_ids"]),
          v["terminal_status"], v.get("reason", ""),
          v.get("rejected_receipts"), v.get("observed_hook_sha256", ""))
'
