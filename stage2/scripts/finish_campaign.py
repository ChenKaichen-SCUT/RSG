#!/usr/bin/env python3
"""Finish the active collection, then run isolated evaluation and fixed trials."""
import argparse,datetime,json,pathlib,subprocess,sys,time
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,PY,dump
ap=argparse.ArgumentParser();ap.add_argument('--resume',action='store_true');options=ap.parse_args()
target=len(json.loads((S/'config/manifest.json').read_text())['programs']);started=time.monotonic()
while len(list((S/'results/collection/primary').glob('*.json')))<target:
 if time.monotonic()-started>1800:raise SystemExit('Collection did not finish in supervisor window; evidence preserved.')
 time.sleep(5)
selection=json.loads((S/'config/e2e_selection.json').read_text())
steps=[('final_validation',['validate_corpus.py']),('final_comparison',['compare.py','--resume']),
 ('final_balanced_comparison',['compare_balanced.py']),('corpus_audit',['audit_corpus.py']),
 ('replay_syntax',['check_replay_syntax.py']),('aggregate_before_e2e',['aggregate.py']),
 ('dependencies',['analyze_dependencies.py']),('exact_conditions',['prove_simple_conditions.py']),
 ('e2e_formal',['run_e2e.py','--ids',*selection['programs'],'--workers',str(selection['workers'])]),
 ('online_validation',['validate_online.py']),('e2e_analysis',['analyze_e2e.py']),('aggregate_final',['aggregate.py'])]
records=json.loads((S/'results/campaign_stages.json').read_text()) if options.resume else []
completed={r['stage'] for r in records if r['exit_code']==0}
for name,args in steps:
 if name in completed:continue
 if name=='e2e_formal' and options.resume:args=[*args,'--resume']
 prefix=S/'logs/campaign'/name;prefix.parent.mkdir(parents=True,exist_ok=True)
 cmd=[str(PY),str(S/'scripts'/args[0]),*args[1:]];start=time.monotonic()
 row={'stage':name,'command':cmd,'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat()}
 print('START',name,flush=True)
 with open(str(prefix)+'.stdout','w') as out,open(str(prefix)+'.stderr','w') as err:
  proc=subprocess.run(cmd,cwd=ROOT,stdout=out,stderr=err)
 row.update(exit_code=proc.returncode,wall_seconds=time.monotonic()-start);records.append(row)
 dump(S/'results/campaign_stages.json',records)
 print('END',name,proc.returncode,flush=True)
 if proc.returncode:raise SystemExit('Stage failed: '+name)
