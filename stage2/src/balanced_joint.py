"""Post-freeze pair-coverage repair, reported separately from frozen E-v1."""
import itertools,math
import z3
from algorithms import Budget,P,build_language,variants,finish

def joint_balanced(c):
 b=Budget();q=len(c.queries);languages=build_language(c);result=c.seed;trials=[];unknown=0
 per_term=max(1,min(16,P['method_candidate_budget']//max(1,len(languages))))
 pools=[list(itertools.islice(variants(l),per_term)) for l in languages]
 pairs=list(itertools.combinations(range(len(languages)),2))
 streams={pair:iter(itertools.product(pools[pair[0]],pools[pair[1]])) for pair in pairs}
 total=sum((math.prod(map(len,languages[i]))-1)*(math.prod(map(len,languages[j]))-1) for i,j in pairs)
 while streams and b.available() and z3.eq(result,c.seed):
  for (ia,ib),stream in list(streams.items()):
   if not b.available():break
   try:(ta,oa),(tb,ob)=next(stream)
   except StopIteration:del streams[(ia,ib)];continue
   b.candidates+=1;r=z3.Or([ta if j==ia else tb if j==ib else t for j,t in enumerate(c.terms)])
   vc,_=c.check('Ebalanced_vc_'+str(b.candidates),c.instance(r))
   strict,_=c.check('Ebalanced_strict_'+str(b.candidates),z3.And(r,z3.Not(c.seed)))
   unknown+=vc['result']=='unknown' or strict['result']=='unknown'
   trials.append({'terms':[ia,ib],'operations':[oa,ob],'formula':r.sexpr(),'validity':vc['result'],'strictness':strict['result']})
   if vc['result']=='unsat' and strict['result']=='sat':result=r;break
 complete=b.candidates==total
 status='expanded' if not z3.eq(result,c.seed) else ('complete_no_extension' if complete and not unknown else 'budget_no_extension')
 return finish(c,'E_balanced',result,status,b,q,{'full_language_total':total,'pool_per_term':per_term,'pool_sizes':list(map(len,pools)),
  'complete':complete,'unknown_candidates':unknown,'pair_count':len(pairs),'visited_pairs':len({tuple(r['terms']) for r in trials}),
  'policy':'Round robin across all automatically enumerated term pairs; identical pools, candidate count and time budget to E_joint2 v1. Post-freeze methodological repair, not an untouched holdout result.','trials':trials})
