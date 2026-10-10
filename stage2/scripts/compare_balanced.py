#!/usr/bin/env python3
import argparse,concurrent.futures,json,pathlib,sys,traceback
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import S,dump
from semantics import Context
from balanced_joint import joint_balanced

def compare(path):
 path=pathlib.Path(path);out=json.loads(path.read_text());key=out['instance']
 try:
  c=Context(S/'corpus'/key,log=S/'logs/balanced_comparison'/key);result=joint_balanced(c)
  out['methods']['E_balanced']=result
  new=z3.parse_smt2_string('(assert '+result['result_smt2']+')',decls=c.env)[0]
  for name,r in out['methods'].items():
   if name=='E_balanced' or 'result_smt2' not in r:continue
   old=z3.parse_smt2_string('(assert '+r['result_smt2']+')',decls=c.env)[0]
   out['pairwise'][name+'__E_balanced']=c.compare(old,new,name+'_Ebalanced')
  dump(path,out);print(key,result['status'],result['versus_official']['relation'],flush=True)
 except Exception as e:
  dump(S/'results/balanced_errors'/key/'error.json',{'error':str(e),'traceback':traceback.format_exc()});raise

if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('--workers',type=int,default=4);args=ap.parse_args()
 paths=[]
 for p in sorted((S/'results/comparison/primary').glob('*/call_*/comparison.json')):
  d=json.loads(p.read_text())
  if d.get('status')=='compared' and 'E_balanced' not in d['methods']:paths.append(p)
 with concurrent.futures.ProcessPoolExecutor(max_workers=args.workers) as pool:list(pool.map(compare,map(str,paths)))
