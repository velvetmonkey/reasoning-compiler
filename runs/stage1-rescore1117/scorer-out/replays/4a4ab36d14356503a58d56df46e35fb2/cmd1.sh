python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
for i,m in enumerate(re.finditer(r"VERDICT (\{.*\})", text), 1):
    o = json.loads(m.group(1))
    print(i, o["terminal_status"], "bash_n="+str(len(o["bash_event_ids"])), o["bash_event_ids"], "receipt_n="+str(len(o["receipt_event_ids"])))
PY
