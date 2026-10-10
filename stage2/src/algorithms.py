"""Bounded baselines on the same frozen syntax and actual official VC."""
import itertools,json,math,os,pathlib,time
import z3
from common import ROOT,S,PY,run,dump
from semantics import Context,from_ast
P=json.loads((S/'config/protocol.json').read_text())

class Budget:
 def __init__(self):self.start=time.perf_counter();self.candidates=0;self.limit=P['method_candidate_budget']
 def available(self):return self.candidates<self.limit and time.perf_counter()-self.start<P['method_wall_budget_seconds']

def atoms_of(term):return list(term.children()) if z3.is_and(term) else [term]
def alternatives(atom):
 out=[atom]
 if z3.is_le(atom) or z3.is_lt(atom) or z3.is_ge(atom) or z3.is_gt(atom):
  lhs,rhs=atom.children();integer=lhs.sort()==z3.IntSort()
  if z3.is_ge(atom) or z3.is_gt(atom):lhs,rhs=rhs,lhs
  strict=z3.is_lt(atom) or z3.is_gt(atom)
  # Preserve the complete original attribute expression, including mixed terms.
  for d in P['distances'][1:]:out.append(lhs < rhs+d if strict else lhs <= rhs+d)
 return out[:2]+[z3.BoolVal(True)]+out[2:]

def build_language(c):
 return [[alternatives(a) for a in atoms_of(t)] for t in c.terms]

def variants(language):
 """Every tuple is a simultaneous per-predicate choice within exactly one term.
 Order by edited predicates, then option indices; exhaustive if not budget-cut.
 """
 n=len(language)
 # Interleave attributes before trying larger distances, so a bounded pair pool
 # does not accidentally search only the first one or two predicates.
 for choice in range(1,max(map(len,language),default=1)):
  for i in range(n):
   if choice<len(language[i]):
    indices=[0]*n;indices[i]=choice
    yield z3.And([opts[j] for opts,j in zip(language,indices)]),{'positions':[i],'choices':[choice]}
 for width in range(2,n+1):
  for positions in itertools.combinations(range(n),width):
   for chosen in itertools.product(*[range(1,len(language[i])) for i in positions]):
    indices=[0]*n
    for i,j in zip(positions,chosen):indices[i]=j
    yield z3.And([opts[j] for opts,j in zip(language,indices)]),{'positions':list(positions),'choices':list(chosen)}

def round_robin_variants(languages):
 streams={i:iter(variants(lang)) for i,lang in enumerate(languages)}
 while streams:
  for i in list(streams):
   try:r,op=next(streams[i]);yield i,r,op
   except StopIteration:del streams[i]

def finish(c,method,result,status,budget,startq,details):
 timed=time.perf_counter()-budget.start;search_queries=c.queries[startq:]
 validation=c.validate(result,method+'_final')
 if not validation['valid']:
  details['rejected_result_smt2']=result.sexpr();details['rejected_validation']=validation
  result=c.seed;status='validation_failed';validation=c.validate(result,method+'_safe_fallback')
 comparison=c.compare(c.seed,result,method+'_vs_seed')
 versus_official=c.compare(c.official,result,method+'_vs_official')
 return {'method':method,'status':status,'result_smt2':result.sexpr(),'validation':validation,'comparison':comparison,
         'versus_official':versus_official,'algorithm_seconds':timed,'search_smt_calls':len(search_queries),
         'search_solver_seconds':sum(q['seconds'] for q in search_queries),'candidate_count':budget.candidates,
         'queries':c.queries[startq:],'details':details}

def single(c):
 b=Budget();q=len(c.queries);languages=build_language(c);total=sum(math.prod(map(len,l))-1 for l in languages)
 trials=[];result=c.seed;unknown=0;exhausted=False
 it=iter(round_robin_variants(languages))
 while b.available():
  try:i,term,op=next(it)
  except StopIteration:exhausted=True;break
  b.candidates+=1;r=z3.Or([term if j==i else t for j,t in enumerate(c.terms)])
  # All operations are weakenings by construction. Explicit inclusion is also rechecked at the end.
  valid,_=c.check('C_vc_'+str(b.candidates),c.instance(r))
  strict,_=c.check('C_strict_'+str(b.candidates),z3.And(r,z3.Not(c.seed)))
  unknown+=valid['result']=='unknown' or strict['result']=='unknown'
  trials.append({'term':i,'operation':op,'formula':r.sexpr(),'validity':valid['result'],'strictness':strict['result']})
  if valid['result']=='unsat' and strict['result']=='sat':result=r;break
 complete=exhausted or b.candidates==total
 status='expanded' if not z3.eq(result,c.seed) else ('complete_no_extension' if complete and not unknown else 'budget_no_extension')
 return finish(c,'C_single',result,status,b,q,{'language_total':total,'complete':complete,'unknown_candidates':unknown,'trials':trials})

def joint(c):
 b=Budget();q=len(c.queries);languages=build_language(c);result=c.seed;trials=[];unknown=0
 # Generate automatically for every term; allocate a bounded variant pool evenly.
 per_term=max(1,min(16,P['method_candidate_budget']//max(1,len(languages))))
 pools=[list(itertools.islice(variants(l),per_term)) for l in languages]
 total=sum((math.prod(map(len,languages[i]))-1)*(math.prod(map(len,languages[j]))-1) for i,j in itertools.combinations(range(len(languages)),2))
 stop=False
 for ia,ib in itertools.combinations(range(len(languages)),2):
  for (ta,oa),(tb,ob) in itertools.product(pools[ia],pools[ib]):
   if not b.available():stop=True;break
   b.candidates+=1;r=z3.Or([ta if j==ia else tb if j==ib else t for j,t in enumerate(c.terms)])
   vc,model=c.check('E_vc_'+str(b.candidates),c.instance(r))
   strict,_=c.check('E_strict_'+str(b.candidates),z3.And(r,z3.Not(c.seed)))
   unknown+=vc['result']=='unknown' or strict['result']=='unknown'
   trials.append({'terms':[ia,ib],'operations':[oa,ob],'formula':r.sexpr(),'validity':vc['result'],'strictness':strict['result']})
   if vc['result']=='unsat' and strict['result']=='sat':result=r;stop=True;break
  if stop:break
 complete=b.candidates==total
 status='expanded' if not z3.eq(result,c.seed) else ('complete_no_extension' if complete and not unknown else 'budget_no_extension')
 return finish(c,'E_joint2',result,status,b,q,{'full_language_total':total,'pool_per_term':per_term,'pool_sizes':list(map(len,pools)),
      'complete':complete,'unknown_candidates':unknown,'policy':'automatic pairs; all complete assignments validated; successors may be covered by any other selected term, never declared negative merely for leaving one term','trials':trials})

def symbolic_closure(c):
 b=Budget();q=len(c.queries);result=c.seed;rounds=[]
 if not c.supports_polarity:return finish(c,'D_symbolic',result,'unsupported',b,q,{'reason':'quantified candidate context'})
 regions=[];provenance=[]
 for i,r,op in itertools.islice(round_robin_variants(build_language(c)),P['symbolic_region_limit']):
  regions.append(r);provenance.append({'term':i,'operation':op})
 complete=False;unknown=False
 while b.available():
  union=z3.Or([c.seed]+regions);remove=[];checks=[]
  for i,r in enumerate(regions):
   if not b.available():break
   b.candidates+=1
   query,model=c.check('D_region_'+str(b.candidates),c.polarized(r,union))
   checks.append({'region':i,'result':query['result']})
   if query['result']=='sat':remove.append(i)
   if query['result']=='unknown':unknown=True
  rounds.append({'region_count':len(regions),'removed':remove,'checks':checks})
  if not remove:
   complete=len(checks)==len(regions) and not unknown
   final=c.validate(union,'D_union')
   if final['valid']:result=union
   break
  regions=[r for i,r in enumerate(regions) if i not in remove]
 status='symbolic_fixpoint' if complete else 'budget_or_unknown'
 return finish(c,'D_symbolic',result,status,b,q,{'region_language':'seed plus up to 64 weakenings of original mixed-attribute terms; overlapping symbolic regions, no integer-range truncation',
      'initial_regions':provenance,'rounds':rounds,'remaining_regions':[r.sexpr() for r in regions],
      'closure_complete_for_retained_regions':complete,'global_optimality_claim':False})

def boogie(e):
 if z3.is_true(e):return 'true'
 if z3.is_false(e):return 'false'
 if z3.is_int_value(e):return str(e.as_long())
 if z3.is_rational_value(e):return '('+str(e.numerator_as_long())+'.0 / '+str(e.denominator_as_long())+'.0)'
 if z3.is_const(e):return str(e.decl().name())
 k=e.decl().kind();args=[boogie(a) for a in e.children()]
 if k==z3.Z3_OP_NOT:return '!('+args[0]+')'
 if k==z3.Z3_OP_UMINUS:return '-('+args[0]+')'
 ops={z3.Z3_OP_AND:'&&',z3.Z3_OP_OR:'||',z3.Z3_OP_ADD:'+',z3.Z3_OP_SUB:'-',z3.Z3_OP_MUL:'*',z3.Z3_OP_LE:'<=',z3.Z3_OP_LT:'<',z3.Z3_OP_GE:'>=',z3.Z3_OP_GT:'>',z3.Z3_OP_EQ:'==',z3.Z3_OP_DISTINCT:'!=',z3.Z3_OP_IDIV:'div',z3.Z3_OP_MOD:'mod',z3.Z3_OP_DIV:'/'}
 if k not in ops:raise ValueError('Unsupported Boogie emission '+str(e.decl()))
 return '('+(' '+ops[k]+' ').join(args)+')'

def repeat_official(c,key,project):
 b=Budget();q=len(c.queries);current=c.seed;current_ast=c.trace['input_ast'];rows=[];status='iteration_limit'
 for i in range(P['repeat_official_limit']):
  if not b.available():status='budget';break
  directory=S/'replay'/key/f'iteration_{i}';directory.mkdir(parents=True,exist_ok=True)
  (directory/'input.bpl').write_text((c.directory/'input.bpl').read_text())
  dump(directory/'seed_ast.json',current_ast)
  env=dict(os.environ,RSG_STAGE2_DIR=str(directory),RSG_STAGE2_REPLAY='1',RSG_STAGE2_SEED_AST=str(directory/'seed_ast.json'))
  for k in ('RSG_STAGE2_ROOT','RSG_EXPERIMENT','RSG_INJECT_ONCE','RSG_ORACLE'):env.pop(k,None)
  cmd=['mono','Boogie.exe','/nologo','/noinfer','/contractInfer','/mlHoudini:dt_penalty','/RSInfer','/RSGeneralize',
       '/proverLog:'+str(directory/'prover.smt2'),str(directory/'input.bpl')]
  remaining=max(.001,P['method_wall_budget_seconds']-(time.perf_counter()-b.start))
  proc=run('replay/'+key+f'/{i}',cmd,cwd=project/'ice/popl16_artifact/Boogie/Binaries',env=env,timeout=remaining)
  b.candidates+=1
  if proc['exit_code'] or not (directory/'trace.json').exists():
   status='replay_timeout' if proc['exit_code']==124 else 'replay_failed';rows.append({'process':proc});break
  trace=json.loads((directory/'trace.json').read_text());r=from_ast(trace['output_ast'],c.env)
  valid=c.validate(r,'B_iteration_'+str(i));eq=c.compare(current,r,'B_change_'+str(i))
  rows.append({'process':proc,'trace':trace,'validation':valid,'change':eq})
  if not valid['valid']:status='validation_failed';break
  current=r;current_ast=trace['output_ast']
  if eq['relation']=='equal':status='semantic_fixpoint';break
  if eq['relation']!='B_strictly_larger':status='nonmonotone_or_unknown';break
 return finish(c,'B_repeat',current,status,b,q,{'iterations':rows,'limit':P['repeat_official_limit'],'native_rsg_seconds':sum(r.get('trace',{}).get('rsg_seconds',0) for r in rows),'native_smt_calls':sum(r.get('trace',{}).get('smt_calls',0) for r in rows)})

def finite_closure(c):
 from formula_parser import parse
 b=Budget();q=len(c.queries);states=[];result=c.seed;details={}
 try:
  text=(c.directory/'input.bpl').read_text();a=text.index('while');a=text.index('(',a);depth=1;j=a+1
  while depth:
   if text[j]=='(':depth+=1
   elif text[j]==')':depth-=1
   j+=1
  guard=parse(text[a+1:j-1],c.env);details['guard_smt2']=guard.sexpr()
 except Exception as e:return finish(c,'D_finite',result,'unsupported',b,q,{'reason':str(e)})
 while b.available() and len(states)<=P['finite_state_limit']:
  excluded=z3.Or([z3.And([v==n for v,n in zip(c.vars,values)]) for values in states])
  b.candidates+=1;r,model=c.check('Dfinite_enum_'+str(len(states)),z3.And(guard,z3.Not(excluded)))
  if r['result']=='unknown':return finish(c,'D_finite',result,'unknown',b,q,details)
  if r['result']=='unsat':break
  states.append([model.eval(v,model_completion=True) for v in c.vars])
 else:
  details.update(enumerated=len(states),reason='No finite completeness proof within state/time budget; not an infinite-domain truncation result')
  return finish(c,'D_finite',result,'state_or_time_limit',b,q,details)
 exact=z3.Or([z3.And([v==n for v,n in zip(c.vars,values)]) for values in states])
 cert,_=c.check('Dfinite_guard_exact',z3.Xor(guard,exact),'unsat');details.update(state_count=len(states),guard_completeness=cert)
 if not cert['passed'] or not c.supports_polarity:return finish(c,'D_finite',result,'unsupported',b,q,details)
 regions=[z3.And([v==n for v,n in zip(c.vars,values)]) for values in states];rounds=[]
 while b.available():
  union=z3.Or(regions);bad=[];unknown=False
  for i,region in enumerate(regions):
   if not b.available():unknown=True;break
   b.candidates+=1;r,_=c.check('Dfinite_step_'+str(b.candidates),c.polarized(region,union))
   if r['result']=='sat':bad.append(i)
   if r['result']=='unknown':unknown=True
  rounds.append({'states':len(regions),'removed':bad})
  if not bad:
   if not unknown:result=union
   details['rounds']=rounds
   return finish(c,'D_finite',result,'exact_fixpoint' if not unknown else 'budget_or_unknown',b,q,details)
  regions=[r for i,r in enumerate(regions) if i not in bad]
 details['rounds']=rounds
 return finish(c,'D_finite',result,'budget',b,q,details)
