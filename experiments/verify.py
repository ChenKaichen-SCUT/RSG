#!/usr/bin/env python3
"""All semantic proofs use unbounded integer SMT, not bounded sampling."""
import json, pathlib, time
import z3
from model import p,x,pp,xp,G,T,R0,Rstar,prime,successor,candidate,display_states

ROOT=pathlib.Path(__file__).resolve().parents[1]

class Checker:
    def __init__(self, directory=None):
        self.queries=[]
        self.directory=pathlib.Path(directory) if directory else None
        if self.directory: self.directory.mkdir(parents=True,exist_ok=True)

    def check(self,name,formula,expected=None):
        s=z3.Solver();s.set(timeout=10000,random_seed=0);s.add(formula)
        before=time.perf_counter();r=s.check();elapsed=time.perf_counter()-before
        row={'name':name,'result':str(r),'expected':expected,'seconds':elapsed,
             'passed':str(r)==expected if expected else None}
        if r==z3.sat:
            m=s.model();row['counterexample_or_witness']={str(v):str(m.eval(v,model_completion=True)) for v in (p,x,pp,xp)}
        if r==z3.unknown:row['reason_unknown']=s.reason_unknown()
        if self.directory:
            path=self.directory/(f'{len(self.queries):04d}_{name}.smt2')
            path.write_text(s.to_smt2())
            row['query_file']=str(path.relative_to(ROOT))
        self.queries.append(row)
        return row

    def validate(self,name,r,seed=R0):
        checks=[self.check(name+'_nonempty',r,'sat'),
                self.check(name+'_seed',z3.And(seed,z3.Not(r)),'unsat'),
                self.check(name+'_guard',z3.And(r,z3.Not(G)),'unsat'),
                self.check(name+'_closure',z3.And(r,T,z3.Not(prime(r))),'unsat')]
        return {'formula_smt2':r.sexpr(),'valid':all(q['passed'] for q in checks),
                'checks':checks,'display_states':display_states(r)}

def main():
    c=Checker(ROOT/'logs/smt/independent')
    results={}
    results['R0']=c.validate('R0',R0)
    results['Rstar']=c.validate('Rstar',Rstar)
    results['Rstar_strict']=c.check('Rstar_strict',z3.And(Rstar,z3.Not(R0)),'sat')
    results['A']=c.validate('A',candidate(True,False))
    results['B']=c.validate('B',candidate(False,True))
    results['negative_tests']={
        'entire_guard':c.validate('bad_entire_guard',G),
        'missing_seed':c.validate('bad_missing_seed',z3.Or(z3.And(p==0,x==1),z3.And(p==1,x==3))),
        'broken_closure':c.validate('bad_broken_closure',candidate(True,False)),
        'outside_guard':c.validate('bad_outside_guard',z3.Or(R0,z3.And(p==2,x==0)))}
    results['exactness']=[
        c.check('guard_minus_Rstar_exactly_02',z3.Xor(z3.And(G,z3.Not(Rstar)),z3.And(p==0,x==2)),'unsat'),
        c.check('other_guard_states_exit_next',z3.And(G,z3.Not(Rstar),T,prime(G)),'unsat'),
        c.check('two_steps_identity',z3.Or(1-(1-p)!=p,4-(4-x)!=x),'unsat'),
        c.check('seed_cycle_00_to_14',z3.And(p==0,x==0,T,z3.Not(z3.And(pp==1,xp==4))),'unsat'),
        c.check('seed_cycle_14_to_00',z3.And(p==1,x==4,T,z3.Not(z3.And(pp==0,xp==0))),'unsat')]
    pa,xa=z3.Ints('p_alternative x_alternative')
    results['semantics']=[
        c.check('transition_deterministic',z3.And(T,z3.substitute(T,(pp,pa),(xp,xa)),z3.Or(pp!=pa,xp!=xa)),'unsat'),
        c.check('body_no_signed_int32_overflow',z3.And(G,z3.Or(1-p < -(2**31),1-p > 2**31-1,4-x < -(2**31),4-x > 2**31-1)),'unsat'),
        c.check('sequential_assignments_equal_parallel',z3.And(G,T,z3.Or(pp!=1-p,xp!=4-x)),'unsat')]
    results['solver_version']=z3.get_version_string()
    results['queries']=c.queries
    expected_ok=all(q['passed'] for q in c.queries if not q['name'].startswith(('A_','B_','bad_')))
    results['suite_passed']=bool(expected_ok and results['R0']['valid'] and results['Rstar']['valid']
        and not results['A']['valid'] and not results['B']['valid'] and all(not r['valid'] for r in results['negative_tests'].values()))
    (ROOT/'results/independent_smt.json').write_text(json.dumps(results,indent=2)+'\n')
    print(json.dumps(results,indent=2))
    return 0 if results['suite_passed'] else 1

if __name__=='__main__':raise SystemExit(main())
