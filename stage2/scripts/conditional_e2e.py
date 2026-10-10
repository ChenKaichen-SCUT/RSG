#!/usr/bin/env python3
import json,pathlib,subprocess,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S,PY,dump
summary=json.loads((S/'results/summary.json').read_text())['all']
benefit=any(summary['methods'][m]['strictly_larger_than_official_instances'] for m in ('D_finite','D_symbolic','E_joint2'))
if not benefit:
 dump(S/'results/e2e_decision.json',{'status':'skipped_no_verified_natural_benefit'});raise SystemExit(0)
selection=json.loads((S/'config/e2e_selection.json').read_text())
subprocess.run([str(PY),str(S/'scripts/build_integration.py')],check=True)
subprocess.run([str(PY),str(S/'scripts/run_e2e.py'),'--ids',*selection['programs'],'--workers',str(selection['workers'])],check=True)
for name in ('validate_online.py','analyze_e2e.py','prove_simple_conditions.py'):
 subprocess.run([str(PY),str(S/'scripts'/name)],check=True)
