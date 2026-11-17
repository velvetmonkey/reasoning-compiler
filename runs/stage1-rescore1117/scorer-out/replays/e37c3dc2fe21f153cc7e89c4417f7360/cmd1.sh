python3 - <<'PY'
from pathlib import Path
import re, json
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
rows = [json.loads(m.group(1)) for m in re.finditer(r'VERDICT (\{.*\})', text)]
for o in rows:
    print(len(o.get("bash_event_ids") or []), len(o.get("receipt_event_ids") or []),
          o.get("terminal_status"), o.get("reason"))
print("max_bash", max(len(o.get("bash_event_ids") or []) for o in rows))
PY
