python3 - <<'PY'
from pathlib import Path
import re, json
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
receipts = [json.loads(m.group(1)) for m in re.finditer(r'RECEIPT (\{.*\})', text)]
verdicts = [json.loads(m.group(1)) for m in re.finditer(r'VERDICT (\{.*\})', text)]
swapped_r = next(r for r in receipts if r["hook_sha256"].startswith("c47dff"))
swapped_v = next(v for v in verdicts if v.get("reason")=="HOOK_SHA256_MISMATCH")
print(swapped_r["hook_sha256"])
print(swapped_v["expected_hook_sha256"])
print(swapped_r["hook_sha256"] == swapped_v["expected_hook_sha256"])
print(swapped_v["terminal_status"], swapped_v["reason"])
print("matcher_compares_receipt_field",
      "receipt.hook_sha256 !== this.expectedHookSha256" in text)
PY
