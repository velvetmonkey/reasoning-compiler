# Adjudicate artifact line 144 "The first forged receipt replayed an already accepted receipt." and the literal FORGERIES_ACCEPTED 0.
R=/mnt/scratch/tmp/rcrescore1117/scorer/mega-monkey
F=$R/packages/engine/scripts/hook-turn-forgery-control.ts
grep -n "await send(valid)\|{ ...valid }\|FORGERIES_ACCEPTED\|this.receipts.has(receipt.event_id)" $F $R/packages/engine/src/claude/hook-turn-supervisor.ts
export REPO=$R WORK=/mnt/scratch/tmp/rcrescore1117/scorer/out/replay-work
cd $WORK && node --experimental-strip-types --input-type=module <<'JS'
import { createConnection } from 'node:net'; import { pathToFileURL } from 'node:url';
const { HookTurnSupervisor } = await import(pathToFileURL(`${process.env.REPO}/packages/engine/src/claude/hook-turn-supervisor.ts`));
const s=await HookTurnSupervisor.start({scratchRoot:process.env.WORK, expectedHookScript:`${process.env.REPO}/packages/engine/scripts/pretool-receipt-hook.mjs`});
const accepted=[]; s.onReceipt=(r)=>accepted.push(r.event_id);
s.observeStreamLine(JSON.stringify({type:'assistant',message:{content:[{type:'tool_use',name:'Bash',id:'bash-from-independent-stream'}]}}));
const valid={turn_id:s.turnId,nonce:s.nonce,hook_event_name:'PreToolUse',hook_sha256:s.expectedHookSha256,event_id:'bash-from-independent-stream',decision:'allow'};
const send=(v)=>new Promise((res,rej)=>{const c=createConnection(s.socketPath);c.once('error',rej);c.once('connect',()=>c.end(JSON.stringify(v)));c.once('close',res);});
await send(valid); console.log('after initial external valid send, stored receipts:', accepted.length);
await send({...valid}); console.log('after FORGED 1 (duplicate of accepted), stored receipts:', accepted.length);
await send({...valid,event_id:'bash-stale-nonce',nonce:'stale-nonce'}); await send({...valid,event_id:'bash-absent-from-stream'});
const v=await s.finalise(); console.log('verdict', v.terminal_status, 'rejected', v.rejected_receipts, 'FORGERIES_ACCEPTED', 3-v.rejected_receipts);
JS
