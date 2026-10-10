#!/usr/bin/env python3
import json,os,pathlib,re,shutil,sys
import z3
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'scripts'))
from record_command import run,ROOT
from model import Rstar,R0
from verify import Checker
from parse_boogie import parse
PROJECT=ROOT/'work/CondTerm';BIN=PROJECT/'ice/popl16_artifact/Boogie/Binaries'

def main():
    results={};checker=Checker(ROOT/'logs/smt/end_to_end')
    modes=sys.argv[1:] or ['natural','fixed_R0','oracle_Rstar']
    for mode in modes:
        case=ROOT/'work/e2e'/mode
        if case.exists():shutil.rmtree(case)
        case.mkdir(parents=True,exist_ok=True)
        shutil.copytree(ROOT/'experiments/benchmarks',case/'benchmarks',dirs_exist_ok=True)
        for d in ('tmp','test'):(case/d).mkdir(exist_ok=True)
        env=dict(os.environ,PYTHONHASHSEED='0')
        for k in ('RSG_EXPERIMENT','RSG_ORDER','RSG_ATTRS','RSG_INJECT_ONCE','RSG_ORACLE','RSG_PROFILE'):env.pop(k,None)
        shutil.copytree(ROOT/('work/pristine-bin' if mode=='natural' else 'work/instrumented-bin'),BIN,dirs_exist_ok=True)
        if mode!='natural':
            marker=case/'injected.marker'
            if marker.exists():marker.unlink()
            env.update(RSG_INJECT_ONCE=str(marker),RSG_PROFILE='1',RSG_ATTRS='unary',RSG_ORACLE='1' if mode=='oracle_Rstar' else '0')
        cmd=[str(ROOT/'.venv/bin/python'),'-u','experiment/scripts/CondTerm.py','--name','Witness',
             '--ledir',str(case/'benchmarks/le'),'--nledir',str(case/'benchmarks/nle'),
             '--seed','888','--tmp',str(case/'tmp'),'--test',str(case/'test'),'--vars','p|x',
             '--conf',str(ROOT/'experiments/Config.xml')]
        proc=run('e2e/'+mode,cmd,cwd=PROJECT,timeout=240,env=env)
        stdout=(ROOT/proc['stdout']).read_text();stderr=(ROOT/proc['stderr']).read_text()
        rec={'process':proc,'mode':mode,'stdout_complete':True,'result':None,
             'initial_state_policy':'all integers in Boogie; arbitrary int32 scanf inputs in C',
             'oracle':mode=='oracle_Rstar','fixed_seed_injection':'first RSLearn call only' if mode!='natural' else None}
        match=re.search(r'\[Info\] Result: (\S+) \(([0-9.]+) s, Termination ([0-9.]+) s, NonTermination ([0-9.]+) s\)',stdout)
        if match:
            rec.update(result=match[1],reported_total_seconds=float(match[2]),reported_termination_seconds=float(match[3]),reported_nontermination_seconds=float(match[4]))
        its=re.search(r'\[Info\] Iteration times: (\d+)',stdout)
        if its:rec['iterations']=int(its[1])
        cond=re.search(r'\[Info\] Condition Result: (.*)',stdout)
        if cond:
            rec['condition']=cond[1]
            if cond[1]!='None':
                try:rec['condition_exactness']=checker.check(mode+'_condition_exact',z3.Xor(parse(cond[1]),z3.Not(Rstar)),'unsat')
                except Exception as e:rec['condition_parse_error']=str(e)
        rec['rslearn_invocations']=len(re.findall(r'\[Debug\] Boogie Cmd: .* /RSInfer\b',stdout))
        rec['ddlterm_invocations']=len(re.findall(r'\[Debug\] Boogie Cmd: (?!.* /RSInfer\b).*',stdout))
        rec['recurrent_sets']=[]
        for stage,formula in re.findall(r'\[INFO\] (Current RS|Generalized RS): (.*)',stdout):
            row={'stage':stage,'formula':formula}
            try:
                r=parse(formula);row['validation']=checker.validate(mode+'_rs_'+str(len(rec['recurrent_sets'])),r,seed=R0 if mode!='natural' and len(rec['recurrent_sets'])<2 else r)
                row['equiv_Rstar']=checker.check(mode+'_eqstar_'+str(len(rec['recurrent_sets'])),z3.Xor(r,Rstar))
            except Exception as e:row['parse_error']=str(e)
            rec['recurrent_sets'].append(row)
        results[mode]=rec
        (ROOT/'results/end_to_end.json').write_text(json.dumps(results,indent=2)+'\n')
        if proc['exit_code'] or 'Traceback' in stderr:break
    shutil.copytree(ROOT/'work/instrumented-bin',BIN,dirs_exist_ok=True)
    print(json.dumps(results,indent=2))

if __name__=='__main__':main()
