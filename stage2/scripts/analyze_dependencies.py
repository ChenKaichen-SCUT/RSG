#!/usr/bin/env python3
"""Diagnostic countermodels with alternative coverage sets, never forced edges."""
import json,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import S,dump
from semantics import Context,walk
cases=json.loads((S/'results/hard_cases.json').read_text());records=[];seen=set()
for case in cases:
 if case['program'] in seen:continue
 p=S/'results/comparison'/case['instance']/'comparison.json';d=json.loads(p.read_text())
 method=d['methods'].get('D_symbolic',{})
 if method.get('versus_official',{}).get('relation')!='B_strictly_larger':continue
 seen.add(case['program']);c=Context(S/'corpus'/case['instance'],log=S/'logs/dependencies'/case['instance'])
 regions=[z3.parse_smt2_string('(assert '+r+')',decls=c.env)[0] for r in method['details']['remaining_regions']]
 negative_apps={e.arg(0).sexpr():e.arg(0) for e in walk(c.nnf) if z3.is_not(e) and z3.is_app(e.arg(0)) and e.arg(0).decl()==c.fun}
 observations=[]
 for i,r in enumerate(regions[:8]):
  query,model=c.check('region_requires_coverage_'+str(i),c.polarized(z3.And(r,z3.Not(c.seed)),c.seed))
  row={'source_region':i,'query':query,'coverage_alternatives':[]}
  if model is not None:
   for app in negative_apps.values():
    bindings=list(zip(c.vars,app.children()));in_seed=model.eval(z3.substitute(c.seed,*bindings),model_completion=True)
    if z3.is_true(in_seed):continue
    covers=[j for j,region in enumerate(regions) if z3.is_true(model.eval(z3.substitute(region,*bindings),model_completion=True))]
    row['coverage_alternatives'].append({'native_negative_candidate_application':app.sexpr(),
      'state':{str(v):str(model.eval(a,model_completion=True)) for v,a in bindings},'covering_regions':covers})
  observations.append(row)
 records.append({'instance':case['instance'],'regions':[r.sexpr() for r in regions],'observations':observations,
  'interpretation':'One countermodel may admit several covering regions. These are witnessed coverage alternatives, not universally mandatory dependencies or a proof of minimum joint width.',
  'proved_minimum_width':'>1 within the fixed candidate language' if case['single_complete'] and case['repeat_fixpoint_equal_official'] else 'not established'})
dump(S/'results/dependency_observations.json',records)
print('Dependency observations for',len(records),'distinct programs.')
