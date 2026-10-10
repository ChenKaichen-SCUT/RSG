#!/usr/bin/env python3
"""Program-denominator summaries and conservative hard-case classification."""
import collections,json,pathlib,statistics,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S,dump

def read(p):return json.loads(p.read_text())
def expanded(r,field='comparison'):
 return r.get('validation',{}).get('valid',False) and r.get(field,{}).get('relation')=='B_strictly_larger'
def summary(split='all'):
 manifest=read(S/'config/manifest.json')['programs']
 ids={r['id'] for r in manifest if split=='all' or r['split']==split}
 runs=[read(p) for p in sorted((S/'results/collection/primary').glob('*.json')) if p.stem in ids]
 validations=[read(p) for p in sorted((S/'results/validation/primary').glob('*/call_*/validation.json')) if p.parent.parent.name in ids]
 cases=[read(p) for p in sorted((S/'results/comparison/primary').glob('*/call_*/comparison.json')) if p.parent.parent.name in ids]
 valid=[v for v in validations if v['status']=='validated'];methods={};hard=[]
 for name in ('A_official','B_repeat','C_single','D_finite','D_symbolic','E_joint2'):
  pairs=[(c['instance'],c.get('methods',{}).get(name)) for c in cases];pairs=[(k,r) for k,r in pairs if r]
  rs=[r for _,r in pairs];ts=[r['algorithm_seconds'] for r in rs if 'algorithm_seconds' in r]
  methods[name]={'instances':len(rs),'statuses':dict(collections.Counter(r['status'] for r in rs)),
   'expanded_seed_instances':sum(expanded(r) for r in rs),'expanded_seed_programs':sorted({k.split('/')[1] for k,r in pairs if expanded(r)}),
   'strictly_larger_than_official_instances':sum(expanded(r,'versus_official') for r in rs),
   'strictly_larger_than_official_programs':sorted({k.split('/')[1] for k,r in pairs if expanded(r,'versus_official')}),
   'versus_official_relations':dict(collections.Counter(r.get('versus_official',{}).get('relation','self' if name=='A_official' else 'missing') for r in rs)),
   'search_unknown_queries':sum(q['result']=='unknown' for r in rs for q in r.get('queries',[])),
   'final_invalid_results':sum(not r.get('validation',{}).get('valid',False) for r in rs),
   'algorithm_seconds_median':statistics.median(ts) if ts else None,'algorithm_seconds_sum':sum(ts),
   'algorithm_seconds_min':min(ts) if ts else None,'algorithm_seconds_max':max(ts) if ts else None,
   'search_smt_calls_sum':sum(r.get('search_smt_calls',0) for r in rs),
   'search_solver_seconds_sum':sum(r.get('search_solver_seconds',0) for r in rs),
   'complete_no_extension_instances':sum(r['status']=='complete_no_extension' for r in rs)}
 for c in cases:
  ms=c.get('methods',{});a=ms.get('A_official',{});b=ms.get('B_repeat',{});single=ms.get('C_single',{})
  closure=any(expanded(ms.get(n,{}),'versus_official') for n in ('D_finite','D_symbolic'))
  joint=expanded(ms.get('E_joint2',{}),'versus_official')
  official_stuck=a.get('comparison',{}).get('relation')=='equal'
  single_complete=single.get('status')=='complete_no_extension'
  repeat_stuck=b.get('status')=='semantic_fixpoint' and b.get('versus_official',{}).get('relation')=='equal'
  types=[]
  if official_stuck and expanded(single):types.append('Type I')
  if official_stuck and single_complete and repeat_stuck and closure:types.append('Type II (fixed language)')
  if official_stuck and single_complete and repeat_stuck and joint and not closure:types.append('Type III (closure resource/representation relative)')
  if not types and (closure or joint):types.append('positive_signal_without_single_term_impossibility')
  if not types and expanded(single,'versus_official'):types.append('single_term_improvement_over_official')
  if not types and expanded(b,'versus_official'):types.append('official_gap_solved_by_repeated_RSG')
  if types:
   key=c['instance'];directory=S/'corpus'/key;trace=read(directory/'trace.json')
   hard.append({'instance':key,'types':types,'program':key.split('/')[1],
      'input_ast':trace['input_ast'],'input_boogie':trace['input_boogie'],'official_boogie':trace['output_boogie'],
      'dnf_terms':len(trace['dnf']),'atoms':sum(map(len,trace['dnf'])),'single_complete':single_complete,'repeat_fixpoint_equal_official':repeat_stuck,
      'methods':{n:{k:r.get(k) for k in ('status','result_smt2','validation','comparison','versus_official','algorithm_seconds','candidate_count','search_smt_calls')} for n,r in ms.items()},
      'full_comparison':'stage2/results/comparison/'+key+'/comparison.json',
      'replay_command':'.venv/bin/python stage2/scripts/replay_instance.py '+key})
 return {'split':split,'manifest_programs':len(ids),'attempted_programs':len(runs),
  'missing_programs':sorted(ids-{r['program'] for r in runs}),'process_statuses':dict(collections.Counter(r['status'] for r in runs)),
  'tool_results':dict(collections.Counter(str(r['result']) for r in runs)),
  'programs_triggering_rsg':sum(bool(r['rsg_traces']) for r in runs),'programs_without_rsg':sum(not r['rsg_traces'] for r in runs),
  'rslearn_invocations':sum(r['rslearn_invocations'] for r in runs),'rsg_calls':sum(len(r['rsg_traces']) for r in runs),
  'rslearn_calls_without_rsg_trace':sum(r['rsl_calls_without_trace'] for r in runs),
  'validation_statuses':dict(collections.Counter(r['status'] for r in validations)),
  'empty_seed_inputs':sum(r.get('seed_nonempty',{}).get('result')=='unsat' for r in validations),
  'nonempty_validation_failures':sum(r['status']=='validation_failed' and r.get('seed_nonempty',{}).get('result')!='unsat' for r in validations),
  'valid_multiterm_inputs':sum(r['dnf_terms']>=2 for r in valid),'valid_singleterm_inputs':sum(r['dnf_terms']==1 for r in valid),
  'dnf_term_counts':dict(collections.Counter(r['dnf_terms'] for r in valid)),
  'official_did_not_expand':sum(r['official_comparison']['relation']=='equal' for r in valid),
  'compared_instances':sum(c.get('status')=='compared' for c in cases),'methods':methods,'hard_cases':hard,
  'proved_coordination_programs':sorted({h['program'] for h in hard if any(t.startswith(('Type II','Type III')) for t in h['types'])}),
  'failures':[{'program':r['program'],'status':r['status'],'result':r['result'],'error':r.get('python_error_tail'),'log':r['process']['stderr']} for r in runs if r['status']!='completed' or r['result'] in ('Unknown','Timeout')]}

if __name__=='__main__':
 out={s:summary(s) for s in ('all','smoke','holdout')}
 dump(S/'results/summary.json',out);dump(S/'results/hard_cases.json',out['all']['hard_cases'])
 a=out['all'];print(json.dumps({k:v for k,v in a.items() if k not in ('methods','failures','hard_cases')},indent=2))
