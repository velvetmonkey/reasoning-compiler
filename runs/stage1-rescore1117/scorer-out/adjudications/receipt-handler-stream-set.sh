# Adjudicate artifact line 83 "The receipt handler cannot add a Bash identifier to that stream set."
R=/mnt/scratch/tmp/rcrescore1117/scorer/mega-monkey
F=$R/packages/engine/src/claude/hook-turn-supervisor.ts
echo "writers of bashEventIds:"; grep -n "bashEventIds.add\|bashEventIds =\|bashEventIds.set" $F
echo "observeBlock definition:"; sed -n '/private observeBlock/,/^  }/p' $F
echo "readReceipt writes only receipts map:"; sed -n '/private readReceipt/,/^  }/p' $F | grep -n "bashEventIds\|receipts.set" 
# Behavioural check: a receipt for an id not in the stream does not enter bash_event_ids
export REPO=$R WORK=/mnt/scratch/tmp/rcrescore1117/scorer/out/replay-work
cd $WORK && node --experimental-strip-types --input-type=module <<'JS'
import { createConnection } from 'node:net'; import { pathToFileURL } from 'node:url';
const { HookTurnSupervisor } = await import(pathToFileURL(`${process.env.REPO}/packages/engine/src/claude/hook-turn-supervisor.ts`));
const s=await HookTurnSupervisor.start({scratchRoot:process.env.WORK, expectedHookScript:`${process.env.REPO}/packages/engine/scripts/pretool-receipt-hook.mjs`});
s.observeStreamLine(JSON.stringify({type:'assistant',message:{content:[{type:'tool_use',name:'Bash',id:'b1'}]}}));
const r={turn_id:s.turnId,nonce:s.nonce,hook_event_name:'PreToolUse',hook_sha256:s.expectedHookSha256,event_id:'not-in-stream',decision:'allow'};
await new Promise((res,rej)=>{const c=createConnection(s.socketPath);c.once('error',rej);c.once('connect',()=>c.end(JSON.stringify(r)));c.once('close',res);});
const v=await s.finalise(); console.log('bash_event_ids', JSON.stringify(v.bash_event_ids), 'rejected', v.rejected_receipts, v.terminal_status);
JS
