#!/usr/bin/env python3
import argparse,concurrent.futures,json,os,pathlib,shutil,sys,traceback
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,dump
from semantics import Context
from algorithms import single,joint,symbolic_closure,finite_closure,repeat_official

def compare(path):
 path=pathlib.Path(path);key=str(path.parent.relative_to(S/'corpus'));out={'instance':key,'methods':{}}
 try:
  rec=json.loads((S/'results/validation'/key/'validation.json').read_text())
  if rec['status']!='validated':out.update(status='not_validated',reason=rec.get('error',rec['status']));dump(S/'results/comparison'/key/'comparison.json',out);return out
  c=Context(path.parent,log=S/'logs/comparison'/key)
  out['methods']['A_official']={'result_smt2':c.official.sexpr(),'status':'actual_natural_trace','validation':rec['official'],
      'comparison':rec['official_comparison'],'algorithm_seconds':c.trace['rsg_seconds'],'search_smt_calls':c.trace['smt_calls'],
      'search_solver_seconds':c.trace['solver_seconds'],'core_calls':c.trace['core_calls']}
  # Each process uses its own native replay cwd to avoid C5/output-file collisions.
  native=S/'work/replay-workers'/str(os.getpid())
  if not native.exists():shutil.copytree(S/'work/traced/ice/popl16_artifact/Boogie/Binaries',native/'ice/popl16_artifact/Boogie/Binaries')
  for name,fn in [('B_repeat',lambda:repeat_official(c,key,native)),('C_single',lambda:single(c)),
                  ('D_finite',lambda:finite_closure(c)),('D_symbolic',lambda:symbolic_closure(c)),('E_joint2',lambda:joint(c))]:
   try:out['methods'][name]=fn()
   except Exception as e:out['methods'][name]={'status':'implementation_error_or_unsupported','error':str(e),'traceback':traceback.format_exc()}
   dump(S/'results/comparison'/key/'comparison.json',out)
  out['status']='compared';out['pairwise']={}
  import z3
  forms={}
  for name,r in out['methods'].items():
   if 'result_smt2' in r:forms[name]=z3.parse_smt2_string('(assert '+r['result_smt2']+')',decls=c.env)[0]
  import itertools
  for a,b in itertools.combinations(forms,2):out['pairwise'][a+'__'+b]=c.compare(forms[a],forms[b],a+'_'+b)
 except Exception as e:out.update(status='error',error=str(e),traceback=traceback.format_exc())
 dump(S/'results/comparison'/key/'comparison.json',out)
 print(key,{n:r.get('status') for n,r in out['methods'].items()},flush=True);return out
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('--label',default='primary');ap.add_argument('--workers',type=int,default=4);ap.add_argument('--resume',action='store_true');args=ap.parse_args()
 paths=sorted((S/'corpus'/args.label).glob('*/call_*/trace.json'))
 if args.resume:
  def complete(p):
   f=S/'results/comparison'/p.parent.relative_to(S/'corpus')/'comparison.json'
   return f.exists() and json.loads(f.read_text()).get('status')=='compared'
  paths=[p for p in paths if not complete(p)]
 with concurrent.futures.ProcessPoolExecutor(max_workers=args.workers) as pool:list(pool.map(compare,map(str,paths)))
