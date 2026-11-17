awk '/FORGERIES_TRIED 3/{a=1} a && /FORGERIES_ACCEPTED|VERDICT/{print}' /mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md
