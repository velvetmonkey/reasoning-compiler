# Adjudicate NOVEL claim: hook_sha256 is self-reported by the hook; supervisor compares the field, does not hash the executing script.
R=/mnt/scratch/tmp/rcrescore1117/scorer/mega-monkey
grep -n "createHash\|readFile\|hook_sha256" $R/packages/engine/scripts/pretool-receipt-hook.mjs
echo ---
grep -n "createHash\|expectedHookSha256 =\|hook_sha256 !==" $R/packages/engine/src/claude/hook-turn-supervisor.ts
