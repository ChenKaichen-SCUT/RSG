#!/usr/bin/env python3
import json,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import S,dump
from formula_parser import parse
from semantics import Context
checks=[]
for p in sorted((S/'results/collection/natural_pristine_controls').glob('*.json')):
 pre=json.loads(p.read_text());post=json.loads((S/'results/collection/primary'/p.name).read_text())
 c=Context(S/'corpus/primary'/p.stem/'call_000',log=S/'logs/natural_control_validation'/p.stem)
 equivalence=c.check('final_condition_equivalence',z3.Xor(parse(pre['condition'],c.env),parse(post['condition'],c.env)),'unsat')[0]
 row={'program':p.stem,'condition_equivalence':equivalence,
  'pristine':{k:pre[k] for k in ('result','iterations','rslearn_invocations','condition')},
  'traced':{k:post[k] for k in ('result','iterations','rslearn_invocations','condition')}}
 row['passed']=equivalence['passed'] and all(pre[k]==post[k] for k in ('result','iterations','rslearn_invocations'))
 checks.append(row)
dump(S/'results/natural_tracing_controls.json',{'passed':all(r['passed'] for r in checks) and len(checks)==3,'programs':checks})
assert all(r['passed'] for r in checks) and len(checks)==3
print('Three natural program tracing controls passed.')
