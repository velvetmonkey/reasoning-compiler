python3 - <<'PY'
from pathlib import Path
import json
p = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md")
text = p.read_text().splitlines()
receipt = json.loads(text[53].strip().split(" ", 1)[1])  # line 54 RECEIPT
verdict = json.loads(text[55].strip().split(" ", 1)[1])  # line 56 VERDICT
print("receipt.hook_sha256", receipt["hook_sha256"])
print("expected_hook_sha256", verdict["expected_hook_sha256"])
print("observed_hook_sha256", verdict["observed_hook_sha256"])
print("equal", receipt["hook_sha256"] == verdict["expected_hook_sha256"])
print("status", verdict["terminal_status"], verdict["reason"])
print("self-hash claim present", any("computes its own SHA-256" in ln for ln in text))
PY
