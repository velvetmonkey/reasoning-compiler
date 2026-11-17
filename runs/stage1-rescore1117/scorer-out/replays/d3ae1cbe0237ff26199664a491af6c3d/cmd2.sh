python3 -c '
import json
from pathlib import Path
lines = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text().splitlines()
receipt = json.loads(lines[53][lines[53].find("{"):])
verdict = json.loads(lines[55][lines[55].find("{"):])
print(receipt["hook_sha256"])
print(verdict["observed_hook_sha256"])
print(verdict["expected_hook_sha256"])
print(receipt["hook_sha256"] == verdict["observed_hook_sha256"])
print(verdict["terminal_status"], verdict["reason"])
'
