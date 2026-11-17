awk 'NR>=44 && NR<=56 || NR>=263 && NR<=265 {print NR ":" $0}' /mnt/scratch/tmp/rcrescore1117/scorer/corpus/A1/hookcanary-report.md
