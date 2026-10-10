#!/usr/bin/env python3
"""Extract this restricted straight-line loop and prove C/Boogie model agreement."""
import json,re
import z3
from model import p,x,pp,xp,G,T
from parse_boogie import parse
from verify import Checker,ROOT

def extract(path):
    source=path.read_text();start=source.index('while')
    opening=source.index('(',start);depth=1;i=opening+1
    while depth:
        if source[i]=='(':depth+=1
        elif source[i]==')':depth-=1
        i+=1
    guard=parse(source[opening+1:i-1])
    body=source[source.index('{',i)+1:source.index('}',i)]
    env={p:p,x:x};assignments=[]
    for lhs,rhs in re.findall(r'\b(p|x)\s*(?::=|=)\s*([^;]+);',body):
        variable={'p':p,'x':x}[lhs]
        val=z3.substitute(parse(rhs),*list(env.items()))
        env[variable]=val;assignments.append([lhs,rhs])
    assert len(assignments)==2,assignments
    return guard,z3.And(pp==env[p],xp==env[x]),assignments

def main():
    c=Checker(ROOT/'logs/smt/frontend');out={}
    for label,rel in [('C','experiments/witness.c'),('Boogie','experiments/witness.bpl'),
                      ('C_LE','experiments/benchmarks/le/Witness/Witness.c'),
                      ('C_NLE','experiments/benchmarks/nle/Witness/Witness.c'),
                      ('BPL_LE','experiments/benchmarks/le/Witness/Witness.bpl'),
                      ('BPL_NLE','experiments/benchmarks/nle/Witness/Witness.bpl')]:
        guard,transition,assignments=extract(ROOT/rel)
        out[label]={'file':rel,'assignments':assignments,'guard_smt2':guard.sexpr(),'transition_smt2':transition.sexpr(),
            'guard_equivalent':c.check(label+'_guard_equiv',z3.Xor(guard,G),'unsat'),
            'body_equivalent':c.check(label+'_transition_equiv',z3.Xor(transition,T),'unsat')}
    out['all_passed']=all(q['passed'] for q in c.queries)
    (ROOT/'results/frontend_equivalence.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(out,indent=2));assert out['all_passed']

if __name__=='__main__':main()
