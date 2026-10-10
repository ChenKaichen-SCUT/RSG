#!/usr/bin/env python3
"""Actual online symbolic closure / automatic pair search on the current seed."""
import json,pathlib,sys,time
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import S,dump
from semantics import Context,from_ast
from algorithms import symbolic_closure,finite_closure,joint
from formula_parser import parse

def syntactically_bounded_guard(c):
 """A conservative dispatch hint; finite_closure still proves enumeration exact.
 Every integer variable needs a direct lower and upper bound in every disjunct.
 """
 try:
  text=(c.directory/'input.bpl').read_text();a=text.index('while');a=text.index('(',a);i=a+1;depth=1
  while depth:
   if text[i]=='(':depth+=1
   elif text[i]==')':depth-=1
   i+=1
  guard=parse(text[a+1:i-1],c.env)
  def bounds(e):
   if z3.is_and(e):return set().union(*(bounds(x) for x in e.children()))
   if z3.is_or(e):
    children=[bounds(x) for x in e.children()]
    return set.intersection(*children) if children else set()
   if e.num_args()!=2:return set()
   left,right=e.children();kind=e.decl().kind();reverse=False
   if not z3.is_const(left) or str(left) not in c.env:left,right=right,left;reverse=True
   if not z3.is_const(left) or str(left) not in c.env or not z3.is_int_value(z3.simplify(right)):return set()
   if kind==z3.Z3_OP_EQ:return {(str(left),'lower'),(str(left),'upper')}
   upper=kind in (z3.Z3_OP_LE,z3.Z3_OP_LT);lower=kind in (z3.Z3_OP_GE,z3.Z3_OP_GT)
   if not (upper or lower):return set()
   return {(str(left),'lower' if (upper if reverse else lower) else 'upper')}
  proved=bounds(guard)
  return all(v.sort()==z3.BoolSort() or {(str(v),'lower'),(str(v),'upper')}<=proved for v in c.vars)
 except (ValueError,IndexError,KeyError):return False

def ast(e):
 if z3.is_true(e) or z3.is_false(e):return {'kind':'literal','sort':'bool','value':'true' if z3.is_true(e) else 'false'}
 if (z3.is_and(e) or z3.is_or(e)) and e.num_args()==0:return {'kind':'literal','sort':'bool','value':'true' if z3.is_and(e) else 'false'}
 if z3.is_int_value(e):return {'kind':'literal','sort':'int','value':str(e.as_long())}
 if z3.is_const(e):return {'kind':'identifier','name':str(e.decl().name()),'sort':str(e.sort()).lower()}
 if z3.is_eq(e) and e.arg(0).sort()==z3.IntSort():
  left,right=[ast(a) for a in e.children()]
  return {'kind':'application','op':'&&','args':[
    {'kind':'application','op':'<=','args':[left,right],'sort':'bool'},
    {'kind':'application','op':'>=','args':[left,right],'sort':'bool'}],'sort':'bool'}
 if z3.is_not(e):
  child=e.arg(0);op={z3.Z3_OP_LE:'>',z3.Z3_OP_LT:'>=',z3.Z3_OP_GE:'<',z3.Z3_OP_GT:'<=',z3.Z3_OP_EQ:'!=',z3.Z3_OP_DISTINCT:'=='}.get(child.decl().kind())
  if op:return {'kind':'application','op':op,'args':[ast(a) for a in child.children()],'sort':'bool'}
 ops={z3.Z3_OP_AND:'&&',z3.Z3_OP_OR:'||',z3.Z3_OP_NOT:'!',z3.Z3_OP_UMINUS:'-',z3.Z3_OP_ADD:'+',z3.Z3_OP_SUB:'-',z3.Z3_OP_MUL:'*',z3.Z3_OP_LE:'<=',z3.Z3_OP_LT:'<',z3.Z3_OP_GE:'>=',z3.Z3_OP_GT:'>',z3.Z3_OP_EQ:'==',z3.Z3_OP_DISTINCT:'!=',z3.Z3_OP_IDIV:'div',z3.Z3_OP_MOD:'mod'}
 op=ops[e.decl().kind()];args=[ast(a) for a in e.children()]
 if op in ('&&','||') and len(args)==1:return args[0]
 if len(args)>2:
  result=args[0]
  for a in args[1:]:result={'kind':'application','op':op,'args':[result,a],'sort':None}
  return result
 return {'kind':'application','op':op,'args':args,'sort':None}

def integrate(directory,method):
 directory=pathlib.Path(directory);start=time.perf_counter();c=Context(directory,log=directory/'integration_queries')
 if z3.is_false(z3.simplify(c.seed)):
  validation=c.validate(c.official,'empty_seed_official_return')
  dump(directory/'integration.json',{'method':method,'status':'empty_seed_official_fallback','accepted_extension':False,
    'returned_ast':ast(c.official),'returned_smt2':c.official.sexpr(),'validation':validation,
    'algorithm':{'status':'empty_seed_no_search'},'all_queries':c.queries,'python_total_seconds':time.perf_counter()-start})
  return
 backend=('finite' if syntactically_bounded_guard(c) else 'symbolic') if method=='closure' else 'joint'
 result={'finite':finite_closure,'symbolic':symbolic_closure,'joint':joint}[backend](c)
 proposed=z3.parse_smt2_string('(assert '+result['result_smt2']+')',decls=c.env)[0]
 accepted=result['validation']['valid'] and result['versus_official']['relation']=='B_strictly_larger'
 chosen=z3.simplify(proposed if accepted else c.official)
 # The official Python frontend expects a DNF of relational atoms. Compact
 # redundant union regions with proof, then emit complemented relations instead
 # of Z3's !(x <= k) spelling. These costs are charged to the integrated run.
 def disjuncts(e):
  return [x for a in e.children() for x in disjuncts(a)] if z3.is_or(e) else [e]
 terms=disjuncts(chosen);deadline=time.perf_counter()+2.;removed=0;i=0
 while i<len(terms) and time.perf_counter()<deadline:
  other=terms[:i]+terms[i+1:]
  proof,_=c.check('serialization_redundant_'+str(i)+'_'+str(removed),z3.And(terms[i],z3.Not(z3.Or(other))))
  if proof['result']=='unsat':terms=other;removed+=1
  else:i+=1
 compact=z3.simplify(z3.Or(terms));emitted=ast(compact);actual=from_ast(emitted,c.env)
 equivalence=c.check('serialization_equivalence',z3.Xor(chosen,actual),'unsat')[0]
 if not equivalence['passed']:raise ValueError('Serialized expression equivalence not proved')
 chosen=actual
 # Independent checking also covers the exact expression sent across the boundary.
 validation=c.validate(chosen,'integrated_return')
 versus=c.compare(c.official,chosen,'integrated_return_vs_official')
 if not validation['valid'] or versus['relation'] not in ('equal','B_strictly_larger'):
  accepted=False;chosen=c.official
 out={'method':method,'backend':backend,'status':'accepted_extension' if accepted else 'official_fallback','accepted_extension':accepted,
      'returned_ast':ast(chosen),'returned_smt2':chosen.sexpr(),'validation':validation,'versus_official':versus,
      'serialization':{'removed_terms':removed,'remaining_terms':len(terms),'equivalence':equivalence,'compaction_budget_seconds':2},
      'algorithm':result,'all_queries':c.queries,'python_total_seconds':time.perf_counter()-start}
 dump(directory/'integration.json',out)
if __name__=='__main__':
 if len(sys.argv)!=3 or sys.argv[2] not in ('closure','joint'):raise SystemExit('Expected: directory closure|joint')
 integrate(*sys.argv[1:])
