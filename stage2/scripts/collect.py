#!/usr/bin/env python3
import argparse,concurrent.futures,json,os,pathlib,queue,re,shutil,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,PY,run,dump
P=json.loads((S/'config/protocol.json').read_text())

def worker_project(i,pristine=False):
 dst=S/'work'/('control' if pristine else 'workers')/str(i)
 if not dst.exists():
  base=pathlib.Path(os.environ.get('RSG_BASE_ROOT',ROOT))
  src=base/'original/CondTerm/CondTerm' if pristine else S/'work/traced'
  for rel in ('src','experiment/scripts','ice/popl16_artifact/Boogie/Binaries'):
   shutil.copytree(src/rel,dst/rel,dirs_exist_ok=True)
  if pristine:shutil.copytree(base/'work/pristine-bin',dst/'ice/popl16_artifact/Boogie/Binaries',dirs_exist_ok=True)
 return dst

def collect(row,project,label='primary',trace=True,seed=888):
 name=row['id'];tag=f'{label}/{name}';case=S/'work/runs'/label/name
 case.mkdir(parents=True,exist_ok=True)
 for kind in ('le','nle'):
  dst=case/'benchmarks'/kind/name;dst.mkdir(parents=True,exist_ok=True)
  for ext in ('c','bpl'):
   shutil.copy2(ROOT/row['files'][kind+'.'+ext]['path'],dst/(name+'.'+ext))
 for d in ('tmp','test'):(case/d).mkdir(exist_ok=True)
 config=(ROOT/'original/CondTerm/CondTerm/experiment/scripts/Config.xml').read_text()
 config=config.replace('<Tmp>/tmpfs</Tmp>',f'<Tmp>{case}</Tmp>').replace('<Log_Dir>/log</Log_Dir>',f'<Log_Dir>{case}</Log_Dir>')
 (case/'Config.xml').write_text(config)
 corpus=S/'corpus'/label/name;corpus.mkdir(parents=True,exist_ok=True)
 env={k:v for k,v in os.environ.items() if not k.startswith(('RSG_STAGE2','RSG_EXPERIMENT','RSG_INJECT','RSG_ORACLE','RSG_PROFILE'))}
 env.update(PYTHONHASHSEED='0',PATH=str(PY.parent)+':'+env['PATH'])
 if trace:env.update(RSG_STAGE2_ROOT=str(corpus),RSG_STAGE2_PROGRAM=name,RSG_STAGE2_SEED=str(seed))
 cmd=[PY,'-u','experiment/scripts/CondTerm.py','--name',name,'--ledir',case/'benchmarks/le','--nledir',case/'benchmarks/nle',
      '--vars','|'.join(row['variables']) or '|','--seed',str(seed),'--tmp',case/'tmp','--test',case/'test','--conf',case/'Config.xml']
 rec=run('collection/'+tag,cmd,cwd=project,env=env,timeout=P['program_wall_limit_seconds'])
 stdout=(ROOT/rec['stdout']).read_text(errors='replace');stderr=(ROOT/rec['stderr']).read_text(errors='replace')
 match=re.search(r'\[Info\] Result: (\S+) \(([0-9.]+) s, Termination ([0-9.]+) s, NonTermination ([0-9.]+) s\)',stdout)
 result={'program':name,'category':row['category'],'split':row['split'],'seed':seed,'data_sharing':True,'trace':trace,'process':rec,
         'status':'timeout' if rec['exit_code']==124 else 'failed','result':None,'condition':None}
 if match:result.update(status='completed' if rec['exit_code']==0 else 'failed',result=match[1],reported_total_seconds=float(match[2]))
 for key,pattern in [('iterations',r'\[Info\] Iteration times: (\d+)'),('condition',r'\[Info\] Condition Result: (.*)')]:
  m=re.search(pattern,stdout)
  if m:result[key]=int(m[1]) if key=='iterations' else m[1]
 result['rslearn_invocations']=len(re.findall(r'\[Debug\] Boogie Cmd: .* /RSInfer\b',stdout))
 result['termination_boogie_invocations']=len(re.findall(r'\[Debug\] Boogie Cmd: (?!.* /RSInfer\b).*',stdout))
 result['rsg_traces']=[str(p.relative_to(ROOT)) for p in sorted(corpus.glob('call_*/trace.json'))]
 result['rsl_calls_without_trace']=result['rslearn_invocations']-len(result['rsg_traces'])
 if 'Traceback' in stderr:result['python_error_tail']=stderr[-3000:]
 dump(S/'results/collection'/label/(name+'.json'),result)
 print(json.dumps({k:result[k] for k in ('program','status','result','iterations','rslearn_invocations') if k in result})+' traces='+str(len(result['rsg_traces'])),flush=True)
 return result

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--split',choices=['smoke','holdout','all'],default='smoke');ap.add_argument('--ids',nargs='*');ap.add_argument('--pristine',action='store_true');ap.add_argument('--witness',action='store_true');ap.add_argument('--label',default='primary');ap.add_argument('--seed',type=int,default=888);args=ap.parse_args()
 rows=json.loads((S/'config/manifest.json').read_text())['programs']
 if args.witness:
  rows=[{'id':'Witness','variables':['p','x'],'category':'synthetic-control','split':'control','files':{k+'.'+e:{'path':f'experiments/benchmarks/{k}/Witness/Witness.{e}'} for k in ('le','nle') for e in ('bpl','c')}}]
 else:rows=[r for r in rows if not r['missing'] and (args.split=='all' or r['split']==args.split) and (not args.ids or r['id'] in args.ids)]
 slots=queue.Queue()
 for i in range(min(P['collection_workers'],len(rows))):slots.put(worker_project(i,args.pristine))
 def execute(row):
  p=slots.get()
  try:return collect(row,p,label=args.label,trace=not args.pristine,seed=args.seed)
  finally:slots.put(p)
 with concurrent.futures.ThreadPoolExecutor(max_workers=P['collection_workers']) as pool:list(pool.map(execute,rows))
if __name__=='__main__':main()
