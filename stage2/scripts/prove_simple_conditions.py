#!/usr/bin/env python3
"""Independent unbounded integer certificates for two simple e2e programs."""
import pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import S,dump
from semantics import Context
rows=[]
c=Context(S/'corpus/primary/AlternDivWidening/call_000',log=S/'logs/exact_conditions/AlternDivWidening')
t,w=c.env['t'],c.env['w'];tp=z3.If(t < -w,-(t-1),z3.If(t>w,-(t+1),0));wp=w+1
r=z3.And(w>=0,z3.Or(t < -w,t>w));rp=z3.And(wp>=0,z3.Or(tp < -wp,tp>wp))
checks=[c.check('nonterm_guard',z3.And(r,t==0),'unsat')[0],c.check('nonterm_closure',z3.And(r,z3.Not(rp)),'unsat')[0],
 c.check('term_one_step',z3.And(w==5,t>=-5,t<=5,t!=0,tp!=0),'unsat')[0],
 c.check('entry_partition',z3.Xor(z3.substitute(r,(w,z3.IntVal(5))),z3.Not(z3.And(t>=-5,t<=5))),'unsat')[0]]
rows.append({'program':'AlternDivWidening','exact_entry_termination':'-5 <= t && t <= 5; initial w := 5','nontermination_set':r.sexpr(),'transition_t':tp.sexpr(),'transition_w':wp.sexpr(),'checks':checks,'native_vc_check':c.check('native_recurrent_set',c.instance(r),'unsat')[0]})
c=Context(S/'corpus/primary/Ex06/call_000',log=S/'logs/exact_conditions/Ex06');t=c.env['t'];intermediate=z3.If(t>0,t-1,t);tp=z3.If(intermediate<0,intermediate+1,intermediate);g=z3.And(t>=-5,t<=5)
checks=[c.check('guard_closed',z3.And(g,z3.Not(z3.And(tp>=-5,tp<=5))),'unsat')[0],c.check('native_guard_recurrent',c.instance(g),'unsat')[0]]
rows.append({'program':'Ex06','exact_entry_termination':'t < -5 || t > 5; otherwise the guard is a closed set, including fixed point 0','transition_t':tp.sexpr(),'checks':checks})
assert all(q['passed'] for r in rows for q in r['checks']) and all(r.get('native_vc_check',{'passed':True})['passed'] for r in rows)
dump(S/'results/exact_e2e_conditions.json',rows);print('Two exact entry-condition certificates passed.')
