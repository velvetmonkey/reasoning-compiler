python3 - <<'PY'
from pathlib import Path
import re, json
text = Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md").read_text()
sec = re.search(r"## ROUTE 3b\n(.*?)(?=\n## )", text, re.S).group(1)
fence = re.search(r"```text\n(.*?)```", sec, re.S).group(1)
forged, verdict = [], None
for line in fence.splitlines():
    if line.startswith("FORGED "):
        forged.append(json.loads(line.split(" ", 1)[1]))
    elif line.startswith("VERDICT "):
        verdict = json.loads(line.split(" ", 1)[1])
matcher = re.search(r"```ts\n(.*?)```", text, re.S)
# second ts fence is the matcher at printed source line 147
blocks = re.findall(r"```ts\n(.*?)```", text, re.S)
matcher = blocks[1]
print("forged_event_ids", [f["event_id"] for f in forged])
print("forged_nonces", [f["nonce"] for f in forged])
print("verdict_status", verdict["terminal_status"])
print("bash_event_ids", verdict["bash_event_ids"])
print("receipt_event_ids", verdict["receipt_event_ids"])
print("rejected_receipts", verdict["rejected_receipts"])
print("first_forged_id_in_receipts", forged[0]["event_id"] in verdict["receipt_event_ids"])
print("stale_event_in_stream", forged[1]["event_id"] in verdict["bash_event_ids"])
print("matcher_contains_nonce", "nonce" in matcher)
print("fence_has_RECEIPT_line", any(l.startswith("RECEIPT ") for l in fence.splitlines()))
PY
