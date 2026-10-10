#!/usr/bin/env python3
"""Check the actual C# returned AST, beyond the Python-selected expression."""
import argparse,json,pathlib,sys,traceback
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import S,dump
from semantics import Context,from_ast
ap=argparse.ArgumentParser();ap.add_argument('--label',default='e2e');args=ap.parse_args();records=[]
for p in sorted((S/'corpus'/args.label).rglob('trace.json')):
 trace=json.loads(p.read_text())
 if 'returned_ast' not in trace:continue
 key=str(p.parent.relative_to(S/'corpus'));row={'instance':key}
 try:
  c=Context(p.parent,log=S/'logs/online_validation'/key);actual=from_ast(trace['returned_ast'],c.env)
  validation=c.validate(actual,'native_actual_return');expected=c.official
  if trace.get('accepted_extension'):
   data=json.loads((p.parent/'integration.json').read_text());expected=z3.parse_smt2_string('(assert '+data['returned_smt2']+')',decls=c.env)[0]
  equivalence=c.check('python_native_boundary_equivalence',z3.Xor(actual,expected),'unsat')[0]
  row.update(validation=validation,equivalence=equivalence,passed=validation['valid'] and equivalence['passed'])
 except Exception as e:row.update(passed=False,error=str(e),traceback=traceback.format_exc())
 records.append(row)
dump(S/'results'/(args.label+'_online_validation.json'),{'passed':bool(records) and all(r['passed'] for r in records),'checks':records})
assert records and all(r['passed'] for r in records)
print('Actual native return AST checks passed:',len(records))
