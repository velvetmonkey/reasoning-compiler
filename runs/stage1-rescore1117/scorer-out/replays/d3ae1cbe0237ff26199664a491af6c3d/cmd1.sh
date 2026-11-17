python3 -c '
from pathlib import Path
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
assert "const missing = bashEventIds.find((eventId) => !this.receipts.has(eventId));" in text
print("missing-find present")
import json
ns = []
for line in text.splitlines():
    if line.startswith("VERDICT"):
        ns.append(len(json.loads(line[line.find("{"):])["bash_event_ids"]))
print("bash cardinalities", ns)
'
