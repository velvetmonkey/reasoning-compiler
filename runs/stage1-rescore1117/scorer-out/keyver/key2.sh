export REPO=/mnt/scratch/tmp/rcrescore1117/scorer/mega-monkey
python3 <<'PY'
import os, subprocess
from pathlib import Path
r=Path(os.environ['REPO'])
def git(*args):
    return subprocess.check_output(['git','-C',str(r),*args],text=True)
assert git('rev-parse','HEAD').strip()=='f23d8af4a67dc916fbd0b5606606b9c72e0ef036'
assert git('diff','--exit-code','HEAD')==''
control=git('show','HEAD:packages/engine/scripts/hook-turn-control.ts')
assert "const expectedHook = join(scriptDirectory, 'pretool-receipt-hook.mjs');" in control
assert 'expectedHookScript: expectedHook' in control
assert 'let registeredHook = expectedHook' in control
paths=git('grep','-l','HookTurnSupervisor','HEAD','--','packages').splitlines()
expected=['packages/engine/scripts/hook-turn-control.ts','packages/engine/scripts/hook-turn-forgery-control.ts','packages/engine/src/__tests__/hook-turn-supervisor.test.ts','packages/engine/src/claude/hook-turn-supervisor.ts']
assert sorted(p.removeprefix('HEAD:') for p in paths)==sorted(expected),paths
artifact=Path('corpus/A1/hookcanary-report.md').read_text()
assert 'The live `block-dangerous-git.sh` does not send this receipt format' in artifact
assert 'The controls did not test a receipt from the live destructive-git guard.' in artifact
assert 'FORGERIES_ACCEPTED 0' in artifact
assert '"terminal_status":"accepted"' in artifact.split('## ROUTE 3b')[1].split('## ROUTE 1a')[0]
print('G1.3 CONFIRMED SCOPE GAP: expected/registered hook is pretool-receipt-hook.mjs; frozen repository has no production supervisor integration')
print('HookTurnSupervisor references:')
print('\n'.join(expected))
print('Artifact confirms: controls did not test the live guard; live guard receipt-format limitation is admitted')
print('G1.1 artifact corroboration: ROUTE 3b contains both FORGERIES_ACCEPTED 0 and terminal_status accepted')
PY
