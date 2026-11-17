python3 - <<'PY'
from pathlib import Path
import hashlib
p = Path("/mnt/scratch/tmp/rcrescore1117/scorer")
frozen = (p/"corpus/A1/FROZEN_SHA").read_text().strip()
text = (p/"corpus/A1/hookcanary-report.md").read_text()
print("frozen", frozen)
print("pushed_in_report", frozen in text)
print("report_sha256", hashlib.sha256(text.encode()).hexdigest())
print("files", sorted(str(x.relative_to(p)) for x in p.rglob("*") if x.is_file()))
PY
