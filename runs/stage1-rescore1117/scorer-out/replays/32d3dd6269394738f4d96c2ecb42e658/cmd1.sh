python3 - <<'PY'
import json, re, pathlib, hashlib
p = pathlib.Path("/mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md")
t = p.read_text()
print("sha256", hashlib.sha256(p.read_bytes()).hexdigest())
print("bytes", p.stat().st_size)
print("nonce_values", re.findall(r'"nonce":"([^"]*)"', t))
print("matcher_mentions_nonce", "nonce" in re.findall(r"```ts\n(.*?)```", t, re.S)[1])
objs = []
for i, line in enumerate(t.splitlines(), 1):
    s = line.strip()
    for prefix in ("RECEIPT ", "FORGED ", "VERDICT "):
        if s.startswith(prefix):
            objs.append((i, prefix.strip(), json.loads(s[len(prefix):])))
v3b = [o for o in objs if o[1] == "VERDICT" and o[2].get("bash_event_ids") == ["bash-from-independent-stream"]][0][2]
forged = [o[2] for o in objs if o[1] == "FORGED"]
print("3b_status", v3b["terminal_status"], "rejected", v3b["rejected_receipts"], "receipts", v3b["receipt_event_ids"])
print("forged_ids", [f["event_id"] for f in forged])
print("forged1_id_equals_accepted", forged[0]["event_id"] == v3b["receipt_event_ids"][0])
print("all_forged_expected_sha", all(f["hook_sha256"] == v3b["expected_hook_sha256"] for f in forged))
print("receipt_line_for_3b_turn", any(o[1] == "RECEIPT" and o[2].get("turn_id") == v3b["turn_id"] for o in objs))
print("verdicts_with_nonce_key", [o[0] for o in objs if o[1] == "VERDICT" and "nonce" in o[2]])
PY
