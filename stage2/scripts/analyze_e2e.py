#!/usr/bin/env python3
"""Keep every trial, paired uncertainty, and entry-semantics condition checks."""
import argparse,collections,json,pathlib,random,re,statistics,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import ROOT,S,dump
from semantics import Context
from condition_parser import parse

def entry_state(program,env,manifest):
 text=(ROOT/manifest[program]['files']['nle.bpl']['path']).read_text()
 text=re.sub(r'/\*.*?\*/|//[^\n]*','',text,flags=re.S)
 prefix=re.split(r'\bwhile\b',text,1)[0];prefix=re.split(r'procedure\s+main\s*\([^)]*\)\s*\{',prefix,1)[1]
 state=dict(env);assumptions=[]
 for statement in prefix.split(';'):
  statement=statement.strip()
  if not statement or statement.startswith('var '):continue
  if statement.startswith('havoc '):
   for name in statement[6:].split(','):
    name=name.strip();state[name]=z3.Const(name+'__entry',env[name].sort() if name in env else z3.IntSort())
   continue
  if statement.startswith('assume(') or statement.startswith('assume ('):
   if '%M:' in statement:continue # Artifact termination-instrumentation slot, not source semantics.
   assumptions.append(parse(statement[statement.index('(')+1:-1],state));continue
  match=re.fullmatch(r'(\w+)\s*:=\s*(.*)',statement,flags=re.S)
  if match:state[match[1]]=parse(match[2],state);continue
  raise ValueError('Entry parser unsupported statement: '+statement)
 return state,z3.And(assumptions)

def quantile(xs,p):
 xs=sorted(xs);position=(len(xs)-1)*p;i=int(position);j=min(i+1,len(xs)-1)
 return xs[i]+(xs[j]-xs[i])*(position-i)
def distribution(xs):
 return {'n':len(xs),'median':statistics.median(xs),'q1':quantile(xs,.25),'q3':quantile(xs,.75),'min':min(xs),'max':max(xs)} if xs else None
def paired_ci(diffs):
 rng=random.Random(20261010);medians=[statistics.median(rng.choices(diffs,k=len(diffs))) for _ in range(10000)]
 return {'median_difference_seconds':statistics.median(diffs),'bootstrap_95_percent_CI':[quantile(medians,.025),quantile(medians,.975)],'bootstrap_resamples':10000,'differences':diffs,'direction':'method minus official; positive means slower'}

ap=argparse.ArgumentParser();ap.add_argument('--pilot',action='store_true');args=ap.parse_args()
label='e2e_pilot' if args.pilot else 'e2e';runs=json.loads((S/'results'/(label+'.json')).read_text())
manifest={r['id']:r for r in json.loads((S/'config/manifest.json').read_text())['programs']};programs={};condition_checks=[]
for program in sorted({r['program'] for r in runs}):
 all_trials=[r for r in runs if r['program']==program];measured=[r for r in all_trials if r['trial']['phase'] in ('measurement','pilot')]
 c=Context(S/'corpus/primary'/program/'call_000',log=S/'logs'/label/'condition_validation'/program)
 try:state,assumptions=entry_state(program,c.env,manifest);entry_error=None
 except Exception as e:state=None;entry_error=str(e)
 methods={}
 for method in ('official','closure','joint'):
  rs=[r for r in measured if r['trial']['method']==method]
  methods[method]={'runs':len(rs),'tool_results':dict(collections.Counter(str(r['result']) for r in rs)),
   'statuses':dict(collections.Counter(r['status'] for r in rs)),'successes':sum(r['result']=='Cond-Termination' and r['status']=='completed' for r in rs),
   'wall_seconds':distribution([r['process']['wall_seconds'] for r in rs]),
   'iterations':distribution([r['iterations'] for r in rs if 'iterations' in r]),
   'rsl_calls':distribution([r['rslearn_invocations'] for r in rs]),'termination_boogie_calls':distribution([r['termination_boogie_invocations'] for r in rs]),
   'rsg_seconds':distribution([r['rsg_seconds'] for r in rs]),'rsg_solver_seconds':distribution([r['rsg_solver_seconds'] for r in rs]),
   'rsg_smt_calls':distribution([r['rsg_native_smt_calls']+r['rsg_python_smt_calls'] for r in rs]),
   'peak_tree_rss_kib':distribution([r['process']['sampled_peak_tree_rss_kib'] for r in rs]),
   'accepted_extensions':sum(r['accepted_extensions'] for r in rs),'integration_errors':sum(len(r['integration_errors']) for r in rs),
   'conditions':list(dict.fromkeys(r['condition'] for r in rs))}
 pairs={}
 for method in ('closure','joint'):
  diffs=[]
  for r in measured:
   if r['trial']['method']!=method:continue
   b=next((b for b in measured if b['trial']['method']=='official' and b['trial']['round']==r['trial']['round']),None)
   if not b:continue
   diffs.append(r['process']['wall_seconds']-b['process']['wall_seconds'])
   check={'program':program,'round':r['trial']['round'],'method':method,'baseline_result':b['result'],'method_result':r['result']}
   if state is not None and b['condition'] is not None and r['condition'] is not None:
    try:
     left=z3.substitute(parse(b['condition'],c.env),*[(v,state[k]) for k,v in c.env.items()])
     right=z3.substitute(parse(r['condition'],c.env),*[(v,state[k]) for k,v in c.env.items()])
     eq,_=c.check('condition_'+method+'_'+str(r['trial']['round']),z3.And(assumptions,z3.Xor(left,right)),'unsat')
     check.update(entry_equivalence=eq)
    except Exception as e:check.update(status='unsupported',error=str(e))
   else:check.update(status='no_final_condition_or_unsupported_entry',error=entry_error)
   condition_checks.append(check)
  pairs[method]=paired_ci(diffs) if diffs else None
 # Independently known exact conditions for two simple programs, at the real entry.
 exact_checks=[]
 if state is not None and program in ('AlternDivWidening','Ex06'):
  t=state['t'];exact=z3.And(t>=-5,t<=5) if program=='AlternDivWidening' else z3.Or(t < -5,t > 5)
  for i,r in enumerate(measured):
   if r['condition'] is None:continue
   formula=z3.substitute(parse(r['condition'],c.env),*[(v,state[k]) for k,v in c.env.items()])
   test,_=c.check('exact_'+str(i),z3.And(assumptions,z3.Xor(formula,exact)),'unsat')
   exact_checks.append({'trial':r['trial'],'check':test})
 programs[program]={'warmup_runs':sum(r['trial']['phase']=='warmup' for r in all_trials),'methods':methods,'paired_wall_differences':pairs,
  'entry_state':{k:str(v) for k,v in state.items()} if state else None,'entry_error':entry_error,'exact_condition_checks':exact_checks}
dump(S/'results'/(label+'_analysis.json'),{'programs':programs,'condition_checks':condition_checks,
 'timing_scope':'Full process wall time, includes failed and unknown runs, startup, tracing, search, serialization and all official stages. Independent paired blocks run concurrently under the worker limit in e2e_execution.json; no isolated-host speed claim.',
 'solver_scope':'RSG native and Python checks only; termination-side solver total unavailable, not replaced by zero.'})
print('Analyzed',len(runs),'trials across',len(programs),'programs.')
