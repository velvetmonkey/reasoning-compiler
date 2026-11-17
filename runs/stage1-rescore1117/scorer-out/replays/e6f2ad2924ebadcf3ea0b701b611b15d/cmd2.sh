python3 - <<'PY'
from pathlib import Path
import json
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
forged=[]; verdict=None
for line in text.splitlines():
    if line.startswith("FORGED "):
        forged.append(json.loads(line[len("FORGED "):])["event_id"])
    if line.startswith("VERDICT ") and "bash-from-independent-stream" in line:
        verdict=json.loads(line[len("VERDICT "):])
print("forged", forged)
print("bash", verdict["bash_event_ids"])
print("kept", verdict["receipt_event_ids"])
print("rejected_receipts", verdict["rejected_receipts"])
print("stale_in_stream", "bash-stale-nonce" in verdict["bash_event_ids"])
PY
