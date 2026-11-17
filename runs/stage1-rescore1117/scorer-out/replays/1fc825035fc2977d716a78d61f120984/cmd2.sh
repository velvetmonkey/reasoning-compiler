python3 -c '
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
rec = json.loads(re.search(r"CONTROL swapped\nRECEIPT (\{.*\})", text).group(1))
ver = json.loads(re.search(r"CONTROL swapped\nRECEIPT \{.*\}\nCLAUDE_EXIT 0\nVERDICT (\{.*\})", text).group(1))
print("receipt", rec["hook_sha256"])
print("expected", ver["expected_hook_sha256"])
print("observed", ver["observed_hook_sha256"])
print("equal_receipt_observed", rec["hook_sha256"] == ver["observed_hook_sha256"])
print("equal_receipt_expected", rec["hook_sha256"] == ver["expected_hook_sha256"])
print("status", ver["terminal_status"], ver["reason"], "rejected", ver["rejected_receipts"])
'
