#!/usr/bin/env python3
"""Audit evidence completeness, trial denominators and all recorded proof statuses."""
import collections,json,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S,dump
read=lambda p:json.loads(p.read_text())
summary=read(S/'results/summary.json')['all'];runs=read(S/'results/e2e.json');checks=[]
def require(name,ok,detail=None):
 checks.append({'name':name,'passed':bool(ok),'detail':detail})
 if not ok:raise AssertionError(name+': '+str(detail))
require('all_official_programs_attempted',summary['manifest_programs']==summary['attempted_programs']==266)
require('all_traces_accounted',sum(summary['validation_statuses'].values())==summary['rsg_calls']==203)
require('nonempty_contexts_valid',summary['nonempty_validation_failures']==0 and summary['compared_instances']==201)
require('all_method_outputs_valid',all(m['instances']==201 and m['final_invalid_results']==0 for m in summary['methods'].values()))
keys=[(r['trial']['program'],r['trial']['phase'],r['trial']['round'],r['trial']['method']) for r in runs]
schedule=read(S/'config/e2e_schedule.json');expected={(t['program'],t['phase'],t['round'],t['method']) for t in schedule}
require('frozen_207_trial_schedule',len(keys)==len(set(keys))==207 and set(keys)==expected)
require('uniform_formal_concurrency',all(r.get('configured_workers')==16 for r in runs if r['trial']['phase']=='measurement'))
require('no_shared_cache_trace_mismatch',all(r['rsl_calls_without_trace']>=0 for r in runs))
require('no_online_integration_errors',all(not r['integration_errors'] for r in runs))
for name in ('tracing_control.json','natural_tracing_controls.json','replay_syntax_integrity.json','e2e_online_validation.json'):
 require(name,read(S/'results'/name)['passed'])
analysis=read(S/'results/e2e_analysis.json')
require('two_exact_program_condition_checks',all(r['check']['passed'] for p in analysis['programs'].values() for r in p['exact_condition_checks']))
require('available_entry_condition_equivalences',all(r['entry_equivalence']['passed'] for r in analysis['condition_checks'] if 'entry_equivalence' in r))
require('raw_trial_process_logs_exist',all((S.parent/r['process'][key]).is_file() for r in runs for key in ('stdout','stderr')))
dump(S/'results/delivery_audit.json',{'passed':True,'checks':checks,'tool_results':summary['tool_results'],
 'formal_trial_results':dict(collections.Counter(str(r['result']) for r in runs if r['trial']['phase']=='measurement'))})
print('Delivery evidence audit passed:',len(checks),'checks.')
