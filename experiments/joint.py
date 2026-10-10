"""Two tiny experimental baselines. These are NOT CondTerm RSG or MaxSAT."""
import itertools,time
import z3
from model import p,x,G,T,R0,Rstar,prime,candidate
from verify import Checker

def joint_two_selector(checker=None):
    """Search all four fully instantiated selector assignments, including failures."""
    c=checker or Checker();start=time.perf_counter();tested=[];best=R0
    for s1,s2 in itertools.product((False,True),repeat=2):
        r=candidate(s1,s2)
        # Seed nonemptiness was proved once. Check the three required obligations.
        qs=[c.check(f'joint_{int(s1)}{int(s2)}_seed',z3.And(R0,z3.Not(r)),'unsat'),
            c.check(f'joint_{int(s1)}{int(s2)}_guard',z3.And(r,z3.Not(G)),'unsat'),
            c.check(f'joint_{int(s1)}{int(s2)}_closure',z3.And(r,T,z3.Not(prime(r))),'unsat')]
        valid=all(q['passed'] for q in qs)
        tested.append({'selectors':[s1,s2],'formula':r.sexpr(),'valid':valid,'checks':qs})
        # Four candidate templates form a Boolean lattice ordered by selector count.
        if valid and (s1 or s2):best=r
    return best,{'method':'Joint-2-Selector','wall_seconds':time.perf_counter()-start,
                 'smt_calls':len(c.queries),'solver_seconds':sum(q['seconds'] for q in c.queries),
                 'unsat_core_calls':0,'candidates':tested}

def finite_region_closure_repair(checker=None):
    """Enumerate the five states of G; delete states whose successors leave the set.

    Region completeness is independently proved by unbounded SMT. Candidate search
    itself uses ordinary sets and requires no optimizer. Validation costs included.
    """
    c=checker or Checker();start=time.perf_counter()
    states={(a,b) for a in (0,1) for b in range(5)
            if (a==0 and 0<=b<=2) or (a==1 and 3<=b<=4)}
    initial=z3.Or([z3.And(p==a,x==b) for a,b in sorted(states)])
    region=c.check('repair_region_exact',z3.Xor(G,initial),'unsat')
    if not region['passed']:raise RuntimeError('Finite region was not proved complete')
    rounds=[]
    while True:
        bad={s for s in states if (1-s[0],4-s[1]) not in states}
        rounds.append({'states':sorted(states),'removed':sorted(bad)})
        if not bad:break
        states-=bad
    r=z3.Or([z3.And(p==a,x==b) for a,b in sorted(states)])
    validation=c.validate('repair_output',r)
    return r,{'method':'Finite-Region-Closure-Repair','rounds':rounds,
              'validation':validation,'wall_seconds':time.perf_counter()-start,
              'smt_calls':len(c.queries),'solver_seconds':sum(q['seconds'] for q in c.queries),
              'unsat_core_calls':0}

def exhaustive_single_term(checker=None):
    """A stronger axis-separable language than the official fixed-distance language.

    Each conjunction of predicates over {p,-p,x,-x}, even with digging holes,
    denotes a Cartesian product P x X. Any valid candidate is contained in G,
    hence P subset {0,1}, X subset {0,1,2,3,4}; both projections must contain
    the frozen seed coordinate. Thus 2*16=32 candidates per disjunct suffice.
    This finite representation is exhaustive over the entire integer domain:
    values outside these projections violate G and cannot be part of any
    valid generalized term. The search is labelled controlled, not official.
    """
    c=checker or Checker();start=time.perf_counter();rows=[];strict=[]
    terms=[z3.And(p==0,x==0),z3.And(p==1,x==4)]
    for i,(sp,sx) in enumerate(((0,0),(1,4))):
        other_x=[b for b in range(5) if b!=sx]
        for p_mask in (0,1):
            ps=[sp]+([1-sp] if p_mask else [])
            for mask in range(16):
                xs=[sx]+[b for j,b in enumerate(other_x) if mask&(1<<j)]
                term=z3.And(z3.Or([p==a for a in ps]),z3.Or([x==b for b in xs]))
                r=z3.Or(term,terms[1-i]);name=f'A4_{i}_{p_mask}_{mask}'
                qguard=c.check(name+'_guard',z3.And(r,z3.Not(G)),'unsat')
                qclosure=c.check(name+'_closure',z3.And(r,T,z3.Not(prime(r))),'unsat')
                qseed=c.check(name+'_seed',z3.And(R0,z3.Not(r)),'unsat')
                valid=all(q['passed'] for q in (qguard,qclosure,qseed))
                qstrict=c.check(name+'_strict',z3.And(r,z3.Not(R0)))
                row={'term':i,'p_values':ps,'x_values':xs,'formula':r.sexpr(),
                     'valid':valid,'strict':qstrict['result']=='sat',
                     'checks':[qguard,qclosure,qseed,qstrict]}
                rows.append(row)
                if valid and row['strict']:strict.append(row)
    return R0,{'method':'A4 exhaustive axis-separable single-term search (controlled)',
               'candidates':rows,'strict_valid_candidates':strict,
               'wall_seconds':time.perf_counter()-start,'smt_calls':len(c.queries),
               'solver_seconds':sum(q['seconds'] for q in c.queries),'unsat_core_calls':0,
               'language_relation':'superset of all weakenings expressible with frozen unary attributes, including non-convex digging'}
