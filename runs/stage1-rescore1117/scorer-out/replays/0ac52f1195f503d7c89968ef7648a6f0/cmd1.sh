python3 - <<'PY'
from pathlib import Path
import json
lines = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text().splitlines()
forged = [json.loads(l[7:]) for l in lines if l.startswith("FORGED ")]
verdict = json.loads(next(l[8:] for l in lines if l.startswith("VERDICT ") and "04586aa3" in l))
matcher = "\n".join(lines[107:138])
print([f["event_id"] for f in forged])
print([f["nonce"] for f in forged])
print(all(f["hook_sha256"].startswith("8354a7b3") for f in forged))
print(verdict["terminal_status"], verdict["bash_event_ids"], verdict["receipt_event_ids"], verdict["rejected_receipts"])
print("nonce" in matcher.lower())
print([i+1 for i,l in enumerate(lines[139:163]) if l.startswith("RECEIPT ")])
PY
