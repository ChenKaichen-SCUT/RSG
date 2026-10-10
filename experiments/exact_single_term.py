#!/usr/bin/env python3
"""Exhaust all official output boundary choices; exact guard pruning for boxes."""
import csv,gzip,itertools,json,time
import z3
from model import p,x,R0,G,T,prime
from verify import Checker,ROOT

def main():
    start=time.perf_counter();c=Checker(ROOT/'logs/smt/A4_exact')
    distances=[0,1,2,4,6,8,10,20,50]
    choices=distances+[None] # None deletes the predicate: an even stronger upper bound.
    terms=[z3.And(p==0,x==0),z3.And(p==1,x==4)]
    survivors=[];total=pruned=0;certificates=[]
    with gzip.open(ROOT/'logs/A4_exact_candidates.csv.gz','wt') as f:
        w=csv.writer(f);w.writerow(['term','dp_upper','dp_lower','dx_upper','dx_lower','verdict'])
        for i,(sp,sx,glo,ghi) in enumerate(((0,0,0,2),(1,4,3,4))):
            # A containing Cartesian box with any relaxed phase bound includes one
            # of the first two witnesses. Excess x bounds include the last two.
            for j,(a,b) in enumerate(((sp-1,sx),(sp+1,sx),(sp,glo-1),(sp,ghi+1))):
                certificates.append(c.check(f'prune_witness_{i}_{j}',z3.And(p==a,x==b,G),'unsat'))
            for du,dl,xu,xl in itertools.product(choices,repeat=4):
                total+=1
                guard_ok=(du==0 and dl==0 and xu is not None and xl is not None and sx+xu<=ghi and sx-xl>=glo)
                if not guard_ok:
                    pruned+=1;w.writerow([i,du,dl,xu,xl,'guard_counterexample_exists']);continue
                term=z3.And(p<=sp+du,-p<=-sp+dl,x<=sx+xu,-x<=-sx+xl)
                r=z3.Or(term,terms[1-i]);tag=f'A4_exact_{i}_{xu}_{xl}'
                validation=c.validate(tag,r)
                strict=c.check(tag+'_strict',z3.And(r,z3.Not(R0)))
                survivors.append({'term':i,'distances':[du,dl,xu,xl],'formula_smt2':r.sexpr(),
                                  'validation':validation,'strict':strict})
                w.writerow([i,du,dl,xu,xl,'valid' if validation['valid'] else 'closure_rejected'])
    res={'method':'A4 exhaustive official boundaries plus predicate elimination',
         'distances':distances,'total_candidates':total,'guard_pruned':pruned,
         'guard_pruning':'Exact Cartesian-box argument with SMT-verified boundary witnesses; no sampled state search.',
         'guard_certificates':certificates,'survivors':survivors,'queries':c.queries,
         'smt_calls':len(c.queries),'unsat_core_calls':0,'wall_seconds':time.perf_counter()-start,
         'solver_seconds':sum(q['seconds'] for q in c.queries),
         'strict_valid_candidates':sum(r['validation']['valid'] and r['strict']['result']=='sat' for r in survivors)}
    (ROOT/'results/exact_single_term.json').write_text(json.dumps(res,indent=2)+'\n')
    print(json.dumps(res,indent=2))
    assert res['strict_valid_candidates']==0 and all(q['passed'] for q in certificates)

if __name__=='__main__':main()
