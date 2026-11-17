awk '/^## ROUTE 2a/{on=1} /^## ROUTE 3a/{on=0} on{print}' /mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md | grep -E 'bash_event_ids|receipt_event_ids'
