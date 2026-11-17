export REPO=/mnt/scratch/tmp/rcrescore1117/scorer/mega-monkey
export WORK=/mnt/scratch/tmp/rcrescore1117/scorer/out/replay-work
mkdir -p "$WORK"
node --experimental-strip-types --input-type=module <<'JS'
import assert from 'node:assert/strict';
import { execFileSync, spawn } from 'node:child_process';
import { readFile, writeFile, mkdtemp } from 'node:fs/promises';
import { createHash } from 'node:crypto';
import { createConnection } from 'node:net';
import { pathToFileURL } from 'node:url';
const repo = process.env.REPO;
assert.equal(execFileSync('git', ['-C', repo, 'rev-parse', 'HEAD'], {encoding:'utf8'}).trim(), 'f23d8af4a67dc916fbd0b5606606b9c72e0ef036');
execFileSync('git', ['-C', repo, 'diff', '--exit-code', 'HEAD']);
const { HookTurnSupervisor } = await import(pathToFileURL(`${repo}/packages/engine/src/claude/hook-turn-supervisor.ts`));
const hook = `${repo}/packages/engine/scripts/pretool-receipt-hook.mjs`;
const source = await readFile(`${repo}/packages/engine/scripts/hook-turn-forgery-control.ts`, 'utf8');
assert(source.indexOf('await send(valid)') < source.indexOf('const forged:'));
assert(!/\bspawn\s*\(|\bexecFile\s*\(/.test(source));
const start = () => HookTurnSupervisor.start({scratchRoot:process.env.WORK, expectedHookScript:hook});
function observe(s, ids) {
  s.observeStreamLine(JSON.stringify({type:'assistant',message:{content:ids.map(id=>({type:'tool_use',name:'Bash',id}))}}));
}
function receipt(s, id) {
  return {turn_id:s.turnId,nonce:s.nonce,hook_event_name:'PreToolUse',hook_sha256:s.expectedHookSha256,event_id:id,decision:'allow'};
}
async function send(s, value) {
  await new Promise((resolve,reject)=>{
    const c=createConnection(s.socketPath);
    c.once('error',reject);
    c.once('connect',()=>c.end(JSON.stringify(value)));
    c.once('close',resolve);
  });
}
// Same sequence as the frozen forgery control; no hook or Claude child exists.
{
  const s=await start(); observe(s,['bash-from-independent-stream']);
  const valid=receipt(s,'bash-from-independent-stream'); await send(s,valid);
  const forged=[{...valid},{...valid,event_id:'bash-stale-nonce',nonce:'stale-nonce'},{...valid,event_id:'bash-absent-from-stream'}];
  for(const r of forged) await send(s,r);
  const v=await s.finalise();
  assert.equal(v.terminal_status,'accepted'); assert.equal(v.rejected_receipts,3);
  assert.deepEqual(v.receipt_event_ids,['bash-from-independent-stream']);
  console.log('G1.1 REFUTED: no hook process; initial external receipt accepted; FORGERIES_TRIED 3; FORGERIES_ACCEPTED 0; terminal_status accepted; rejected_receipts 3');
}
{
  const s=await start(); observe(s,['bash-one']); const v=await s.finalise();
  assert.equal(v.terminal_status,'failed'); assert.equal(v.reason,'HOOK_MISSING_PRE_TOOL_USE');
  console.log('T1 TRUE: one Bash, no receipt => failed HOOK_MISSING_PRE_TOOL_USE');
}
{
  const s=await start(); observe(s,['bash-one','bash-two']); await send(s,receipt(s,'bash-one')); const v=await s.finalise();
  assert.equal(v.terminal_status,'failed'); assert.equal(v.reason,'HOOK_MISSING_PRE_TOOL_USE'); assert.equal(v.event_id,'bash-two');
  console.log('T2 TRUE: two Bash ids, one receipt => failed HOOK_MISSING_PRE_TOOL_USE event_id bash-two');
}
{
  const dir=await mkdtemp(`${process.env.WORK}/digest-`);
  const altered=`${dir}/pretool-receipt-hook.mjs`;
  const bytes=await readFile(hook); await writeFile(altered,Buffer.concat([bytes,Buffer.from('\n// Re-registration isolated digest control.\n')]));
  const hash=createHash('sha256').update(await readFile(altered)).digest('hex');
  const s=await start(); observe(s,['bash-one']); assert.notEqual(hash,s.expectedHookSha256);
  const child=spawn(process.execPath,[altered],{env:s.childEnvironment({}),stdio:['pipe','ignore','pipe']});
  let stderr=''; child.stderr.on('data',b=>stderr+=b);
  child.stdin.end(JSON.stringify({hook_event_name:'PreToolUse',tool_use_id:'bash-one'}));
  const code=await new Promise((resolve,reject)=>{child.once('error',reject);child.once('close',resolve);});
  assert.equal(code,0,stderr); const v=await s.finalise();
  assert.equal(v.terminal_status,'failed'); assert.equal(v.reason,'HOOK_SHA256_MISMATCH'); assert.equal(v.observed_hook_sha256,hash);
  console.log('T3 TRUE: byte-different receipt hook hashes itself => failed HOOK_SHA256_MISMATCH');
}
{
  const s=await start(); const v=await s.finalise(); assert.equal(v.terminal_status,'not_applicable');
  console.log('T4 TRUE: no Bash => not_applicable, not accepted');
}
JS
