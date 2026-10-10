#!/usr/bin/env python3
import json,pathlib,re,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,dump
from semantics import Context
sys.path.insert(0,str(ROOT/'experiments'))
from model import R0,Rstar,candidate,G
from parse_boogie import parse
import z3
c=Context(S/'corpus/trace_control_v2/Witness/call_000',log=S/'logs/control_verification')
checks=[]
checks.append(c.check('natural_seed_equals_R0',z3.Xor(c.seed,R0),'unsat')[0])
checks.append(c.check('official_equals_R0',z3.Xor(c.official,R0),'unsat')[0])
for name,r,status in [('R0',R0,'unsat'),('Rstar',Rstar,'unsat'),('A',candidate(True,False),'sat'),('B',candidate(False,True),'sat'),('guard',G,'sat'),('true',z3.BoolVal(True),'sat')]:
 checks.append(c.check('native_context_'+name,c.instance(r),status)[0])
pre=json.loads((S/'results/collection/pristine_control/Witness.json').read_text())
post=json.loads((S/'results/collection/trace_control_v2/Witness.json').read_text())
checks.append(c.check('final_condition_equivalence',z3.Xor(parse(pre['condition']),parse(post['condition'])),'unsat')[0])
checks.append(c.check('final_condition_exact',z3.Xor(parse(post['condition']),z3.Not(Rstar)),'unsat')[0])
check={'passed':all(r['passed'] for r in checks),'checks':checks,'pristine_iterations':pre['iterations'],'traced_iterations':post['iterations'],
       'pristine_rsl_calls':pre['rslearn_invocations'],'traced_rsl_calls':post['rslearn_invocations'],
       'trace_initial_bug':'AST parent nodes may have no inferred Type; initial pilot threw after RSG, fixed with nullable metadata. Failed pilot retained under trace_control.',
       'parser_compatibility':'Legacy :lblpos/:lblneg annotations structurally erased; treating them as arbitrary label applications was rejected by negative/control tests.'}
assert check['passed'] and pre['iterations']==post['iterations'] and pre['rslearn_invocations']==post['rslearn_invocations']
dump(S/'results/tracing_control.json',check)
print('Tracing control and adversarial native VC tests passed.')
