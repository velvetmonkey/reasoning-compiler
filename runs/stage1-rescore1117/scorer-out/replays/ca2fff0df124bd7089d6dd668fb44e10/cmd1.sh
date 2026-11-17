python3 - <<'PY'
from pathlib import Path
import json, re
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
stale = json.loads(re.search(
    r'FORGED ({[^\n]*bash-stale-nonce[^\n]*})', text).group(1))
block = re.search(
    r'FORGERIES_TRIED 3\nFORGERIES_ACCEPTED 0\nVERDICT ({.*})', text).group(1)
verdict = json.loads(block)
matcher = re.search(r"```ts\n147.*?```", text, re.S).group(0)
print("stale.event_id =", stale["event_id"])
print("stale.nonce =", stale["nonce"])
print("verdict.bash_event_ids =", verdict["bash_event_ids"])
print("stale event in stream set =", stale["event_id"] in verdict["bash_event_ids"])
print("matcher contains 'nonce' =", "nonce" in matcher.lower())
print("rejected_receipts =", verdict["rejected_receipts"])
PY
