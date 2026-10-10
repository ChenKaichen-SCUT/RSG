#!/usr/bin/env python3
"""Verify native replay preserved every original AST operator and operand order."""
import json,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S,dump
def shape(a):
 if isinstance(a,list):return list(map(shape,a))
 if isinstance(a,dict):return {k:shape(v) for k,v in a.items() if k!='sort'}
 return a
rows=[]
for p in sorted((S/'results/comparison/primary').glob('*/call_*/comparison.json')):
 d=json.loads(p.read_text());source=S/'corpus'/d['instance']/'trace.json'
 original=json.loads(source.read_text())['input_ast']
 iterations=d.get('methods',{}).get('B_repeat',{}).get('details',{}).get('iterations',[])
 previous=original
 for i,r in enumerate(iterations):
  if 'trace' not in r:continue
  replay=r['trace'];passed=shape(previous)==shape(replay['input_ast'])
  rows.append({'instance':d['instance'],'iteration':i,'exact_ast_shape_equal':passed})
  previous=replay['output_ast']
dump(S/'results/replay_syntax_integrity.json',{'passed':bool(rows) and all(r['exact_ast_shape_equal'] for r in rows),'checks':rows,
 'ignored_metadata':'sort only: native type inference may populate initially null parent sort; no Boolean/arithmetic structure ignored'})
assert rows and all(r['exact_ast_shape_equal'] for r in rows)
print('Native frozen AST replay checks passed:',len(rows))
