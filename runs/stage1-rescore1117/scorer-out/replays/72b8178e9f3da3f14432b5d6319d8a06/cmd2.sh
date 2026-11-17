python3 - <<'PY'
from pathlib import Path
import json
lines = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text().splitlines()
def objs(prefix):
    out = []
    for line in lines:
        s = line.strip()
        if s.startswith(prefix):
            out.append(json.loads(s[len(prefix):].strip()))
    return out
recs, forgs = objs("RECEIPT "), objs("FORGED ")
print("receipt_keys", [sorted(r.keys()) for r in recs])
print("forged_keys", [sorted(f.keys()) for f in forgs])
print("schema_equal", all(set(x.keys()) == set(recs[0].keys()) for x in recs + forgs))
# quoted matcher body: file lines 147-175 as printed inside the ts fence
body = "\n".join(lines[108:136])  # 0-based [108:136] is the printed matcher through observed_hook_sha256
print("nonce_in_ts_body", "nonce" in body)
print("route3b_claude", any("CLAUDE_EXIT" in lines[i] for i in range(140, 163)))
print("forgeries_accepted_line", [ln for ln in lines if ln.startswith("FORGERIES_ACCEPTED") or ln.startswith("COUNT of forged")])
PY
