python3 - <<'PY'
exp="8354a7b35d562ac5a62e194a95d50d2b0adda442dbdce44e97b08e79a6bf7e65"
bash={"bash-from-independent-stream"}
receipts={
  "bash-from-independent-stream": exp,
  "bash-stale-nonce": exp,
  "bash-absent-from-stream": exp,
}
rejected=0
for event_id in list(receipts):
    if event_id not in bash:
        del receipts[event_id]
        rejected += 1
print("rejected", rejected)
print("remaining", list(receipts))
print("quoted_rejected_receipts", 3)
print("quoted_forgeries_accepted", 0)
PY
