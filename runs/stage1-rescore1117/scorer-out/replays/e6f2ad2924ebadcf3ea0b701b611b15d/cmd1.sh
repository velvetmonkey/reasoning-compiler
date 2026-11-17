python3 - <<'PY'
from pathlib import Path
import json
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
for line in text.splitlines():
    if line.startswith("VERDICT "):
        v = json.loads(line[len("VERDICT "):])
        print(v["terminal_status"], v.get("reason"), v["bash_event_ids"], v["receipt_event_ids"])
PY
