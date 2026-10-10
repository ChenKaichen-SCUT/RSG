#!/usr/bin/env python3
"""Sequential paired randomized end-to-end trials with actual online methods."""
import argparse,concurrent.futures,json,pathlib,random,shutil,sys,threading,queue
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,PY,run,dump
import collect
P=json.loads((S/'config/protocol.json').read_text())
ap=argparse.ArgumentParser();ap.add_argument('--ids',nargs='+',required=True);ap.add_argument('--pilot',action='store_true');ap.add_argument('--workers',type=int,default=4);args=ap.parse_args()
rows={r['id']:r for r in json.loads((S/'config/manifest.json').read_text())['programs']}
projects=queue.Queue()
for i in range(args.workers):
 project=S/'work/e2e-workers'/str(i)
 for rel in ('src','experiment/scripts','ice/popl16_artifact/Boogie/Binaries'):
  shutil.copytree(S/'work/integrated'/rel,project/rel,dirs_exist_ok=True)
 projects.put(project)
rng=random.Random(P['e2e_if_natural_benefit']['order_seed']);records=[]
plans=[('pilot',1)] if args.pilot else [('warmup',P['e2e_if_natural_benefit']['warmup']),('measurement',P['e2e_if_natural_benefit']['repeats'])]
schedule=[]
for program in args.ids:
 for phase,count in plans:
  for i in range(count):
   order=['official','closure','joint'];rng.shuffle(order)
   for method in order:schedule.append({'program':program,'phase':phase,'round':i,'method':method})
label='e2e_pilot' if args.pilot else 'e2e'
dump(S/'config'/(label+'_schedule.json'),schedule)
dump(S/'config'/(label+'_execution.json'),{'workers':args.workers,'pairing':'Each worker executes one program/repetition block of three methods sequentially in frozen randomized order. Different blocks run concurrently; all warmup blocks finish before measurement blocks.','host_cpu_pinning':False})
def online(name,cmd,**kw):
 method=name.split('/')[-2]
 kw['env'].update(RSG_STAGE2_METHOD=method,RSG_STAGE2_PYTHON=str(PY),RSG_STAGE2_INTEGRATOR=str(S/'scripts/integrate.py'))
 return run(name,cmd,**kw)
collect.run=online
lock=threading.Lock()
def execute(trial,project):
 method=trial['method']
 runlabel=f"{label}/{trial['program']}/{trial['phase']}_{trial['round']:02d}/{method}"
 result=collect.collect(rows[trial['program']],project,label=runlabel,trace=True,seed=P['primary_seed'])
 traces=[json.loads((ROOT/p).read_text()) for p in result['rsg_traces']]
 integrations=[]
 for p in result['rsg_traces']:
  f=(ROOT/p).parent/'integration.json'
  if f.exists():integrations.append(json.loads(f.read_text()))
 if result['rsl_calls_without_trace']<0 or any(r['method']!=method for r in integrations) or (method=='official' and integrations):
  raise RuntimeError('Trial isolation/configuration integrity failure: '+runlabel)
 result.update(trial=trial,rsg_seconds=sum(t.get('rsg_seconds',0) for t in traces),
  rsg_native_smt_calls=sum(t.get('smt_calls',0) for t in traces),rsg_core_calls=sum(t.get('core_calls',0) for t in traces),
  rsg_solver_seconds=sum(t.get('solver_seconds',0) for t in traces)+sum(q['seconds'] for r in integrations for q in r['all_queries']),
  rsg_python_smt_calls=sum(len(r['all_queries']) for r in integrations),
  accepted_extensions=sum(t.get('accepted_extension',False) for t in traces),
  integration_errors=[t['integration_error'] for t in traces if 'integration_error' in t],
  solver_cost_scope='RSG checks only; termination-side total solver cost is not instrumented. Full process wall time includes all components.')
 with lock:
  records.append(result);dump(S/'results'/(label+'.json'),records)
 print(json.dumps({'trial':trial,'result':result['result'],'iterations':result.get('iterations'),'wall_seconds':result['process']['wall_seconds'],'accepted':result['accepted_extensions'],'errors':len(result['integration_errors'])}),flush=True)
def block(trials):
 project=projects.get()
 try:
  for trial in trials:execute(trial,project)
 finally:projects.put(project)
for phase,count in plans:
 blocks=[schedule[i:i+3] for i in range(0,len(schedule),3) if schedule[i]['phase']==phase]
 with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:list(pool.map(block,blocks))
