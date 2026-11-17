# Adjudicate: does Route 3b's stale-nonce forgery exercise the nonce check, and is it confounded by its absent event id?
export REPO=/mnt/scratch/tmp/rcrescore1117/scorer/mega-monkey
export WORK=/mnt/scratch/tmp/rcrescore1117/scorer/out/replay-work
grep -n "receipt.nonce !== this.nonce" $REPO/packages/engine/src/claude/hook-turn-supervisor.ts
cd $WORK && node --experimental-strip-types --input-type=module <<'JS'
import { createConnection } from 'node:net';
import { pathToFileURL } from 'node:url';
const repo=process.env.REPO;
const { HookTurnSupervisor } = await import(pathToFileURL(`${repo}/packages/engine/src/claude/hook-turn-supervisor.ts`));
const hook=`${repo}/packages/engine/scripts/pretool-receipt-hook.mjs`;
const start=()=>HookTurnSupervisor.start({scratchRoot:process.env.WORK, expectedHookScript:hook});
const obs=(s,id)=>s.observeStreamLine(JSON.stringify({type:'assistant',message:{content:[{type:'tool_use',name:'Bash',id}]}}));
const rc=(s,id,extra={})=>({turn_id:s.turnId,nonce:s.nonce,hook_event_name:'PreToolUse',hook_sha256:s.expectedHookSha256,event_id:id,decision:'allow',...extra});
const send=(s,v)=>new Promise((res,rej)=>{const c=createConnection(s.socketPath);c.once('error',rej);c.once('connect',()=>c.end(JSON.stringify(v)));c.once('close',res);});
// A: stale nonce on an IN-stream id, no other receipt -> nonce check alone decides
{const s=await start(); obs(s,'b1'); await send(s,rc(s,'b1',{nonce:'stale-nonce'})); const v=await s.finalise(); console.log('A stale nonce, in-stream id:', v.terminal_status, v.reason, 'rejected', v.rejected_receipts);}
// B: valid nonce, absent id -> rejected anyway by stream filter (confound)
{const s=await start(); obs(s,'b1'); await send(s,rc(s,'b1')); await send(s,rc(s,'bash-stale-nonce')); const v=await s.finalise(); console.log('B valid nonce, absent id:', v.terminal_status, 'rejected', v.rejected_receipts);}
// C: exact 3b shape for forgery 2 (stale nonce + absent id)
{const s=await start(); obs(s,'b1'); await send(s,rc(s,'b1')); await send(s,rc(s,'bash-stale-nonce',{nonce:'stale-nonce'})); const v=await s.finalise(); console.log('C stale nonce + absent id:', v.terminal_status, 'rejected', v.rejected_receipts);}
JS
