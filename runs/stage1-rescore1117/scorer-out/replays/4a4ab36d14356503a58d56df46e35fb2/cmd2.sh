python3 - <<'PY'
from pathlib import Path
t = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
print("field_compare", t.count("hook_sha256 !== this.expectedHookSha256"))
print("createHash", t.count("createHash"))
print("readFile", t.count("readFile"))
print("sha256sum", t.count("sha256sum"))
print("observed_c47d", "c47dff1434bfe0699b6442d885fb68b7716559fa7d00d1a4f3cfcb11a03e33a6" in t)
print("expected_8354", t.count("8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65"))
PY
