#!/usr/bin/env python3
import json,re,pathlib
import z3
from verify import Checker,ROOT
from parse_boogie import parse
from model import R0,Rstar

def main():
    data=json.loads((ROOT/'results/end_to_end.json').read_text())
    c=Checker(ROOT/'logs/smt/e2e_reanalysis')
    for mode in ('natural','fixed_R0','oracle_Rstar'):
        rec=data[mode]
        log=(ROOT/rec['process']['stdout']).read_text()
        if rec.get('condition') and rec['condition']!='None':
            rec['condition_exactness']=c.check(mode+'_termination_condition_exact',z3.Xor(parse(rec['condition']),z3.Not(Rstar)),'unsat')
            rec.pop('condition_parse_error',None)
        blocks=re.split(r'(?=\[Debug\] Boogie Cmd: .* /RSInfer\b)',log)[1:]
        rec['recurrent_sets']=[]
        for i,block in enumerate(blocks):
            guesses=re.findall(r'\[Info\] Guess Rec #\d+: (.*)',block)
            generalized=re.search(r'\[Debug\]get generalized recurrent set: (.*)',block)
            seed=parse(guesses[-1]) if guesses else R0
            entries=[('learned_seed' if guesses else 'injected_seed',seed,guesses[-1] if guesses else str(R0))]
            if generalized:entries.append(('generalized',parse(generalized[1]),generalized[1]))
            for stage,r,text in entries:
                tag=mode+'_'+str(i)+'_'+stage
                validation=c.validate(tag,r,seed=seed)
                rec['recurrent_sets'].append({'iteration':i+1,'stage':stage,'formula':text,'formula_smt2':r.sexpr(),
                    'validation':validation,'equivalent_R0':c.check(tag+'_eq0',z3.Xor(r,R0)),
                    'equivalent_Rstar':c.check(tag+'_eqstar',z3.Xor(r,Rstar))})
        rec['reported_rslearn_prover_seconds']=[float(v) for v in re.findall(r'\[Info\] => Prover Time: ([\d.]+)',log)]
        rec['reported_c5_learner_seconds']=[float(v) for v in re.findall(r'\[Info\] => Learner Time: ([\d.]+)',log)]
        rec['solver_timing_limitation']='Official displayed prover times are rounded and omit RSG; full process time is measured externally.'
    log=(ROOT/'logs/original_witness_rslearn.stdout').read_text()
    data['standalone_without_data_sharing']={'source':'logs/original_witness_rslearn.stdout','recurrent_sets':[]}
    for stage,formula in re.findall(r'\[INFO\] (Current RS|Generalized RS): (.*)',log):
        r=parse(formula);tag='standalone_'+str(len(data['standalone_without_data_sharing']['recurrent_sets']))
        data['standalone_without_data_sharing']['recurrent_sets'].append({'stage':stage,'formula':formula,'formula_smt2':r.sexpr(),
            'validation':c.validate(tag,r,seed=r),'equivalent_Rstar':c.check(tag+'_eqstar',z3.Xor(r,Rstar),'unsat')})
    (ROOT/'results/end_to_end.json').write_text(json.dumps(data,indent=2)+'\n')
    assert all(data[m]['condition_exactness']['passed'] for m in ('natural','fixed_R0','oracle_Rstar'))
    assert all(r['validation']['valid'] for m in data.values() for r in m.get('recurrent_sets',[]))
    print('All complete pipeline outputs and recovered recurrent sets independently verified.')

if __name__=='__main__':main()
