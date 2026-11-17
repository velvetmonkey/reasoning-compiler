python3 - <<'PY'
from pathlib import Path
import json
p = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md")
for i, line in enumerate(p.read_text().splitlines(), 1):
    s = line.strip()
    if s.startswith("VERDICT "):
        o = json.loads(s.split(" ", 1)[1])
        print(i, "bash", len(o["bash_event_ids"]), "receipt", len(o["receipt_event_ids"]),
              o["terminal_status"], o.get("reason"), o.get("observed_hook_sha256"))
PY
