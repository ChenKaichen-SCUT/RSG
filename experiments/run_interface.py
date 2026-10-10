#!/usr/bin/env python3
"""Real official interface runs, controlled baselines and 30 repetitions."""
import json,os,pathlib,random,re,statistics,sys
import z3
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'scripts'))
from record_command import run,ROOT
from model import p,x,R0,Rstar
from verify import Checker
BIN=ROOT/'work/CondTerm/ice/popl16_artifact/Boogie/Binaries'

def parse_formula(s):
    return z3.parse_smt2_string('(assert '+s+')',decls={'p':p,'x':x})[0]

def official(label,reverse=False,default_attributes=False,seed_bpl=None):
    env=dict(os.environ,RSG_EXPERIMENT='direct',RSG_PROFILE='1',
             RSG_ORDER='reverse' if reverse else 'normal',RSG_ATTRS='default' if default_attributes else 'unary')
    for key in ('RSG_INJECT_ONCE','RSG_ORACLE'):env.pop(key,None)
    smt=ROOT/'logs'/f'{label}.smt2';smt.parent.mkdir(parents=True,exist_ok=True)
    cmd=['mono','Boogie.exe','/nologo','/noinfer','/contractInfer','/mlHoudini:dt_penalty',
         '/RSInfer','/RSGeneralize','/proverLog:'+str(smt),str(seed_bpl or ROOT/'experiments/witness.bpl')]
    process=run(label,cmd,cwd=BIN,timeout=60,env=env)
    stdout=(ROOT/process['stdout']).read_text()
    if process['exit_code'] or '[RSG_OUTPUT_SMT]' not in stdout or 'generalization vc is invalid' in stdout:
        raise RuntimeError('Official RSG failed; see '+process['stdout'])
    def line(key):return re.search(r'^\['+key+r'\] (.*)$',stdout,re.M).group(1)
    result={'method':label,'input_formula_smt2':line('RSG_INPUT_SMT'),'formula_smt2':line('RSG_OUTPUT_SMT'),
            'learner_attribute_table':line('RSG_ATTRIBUTES'),'candidate_attributes':['p','-p','x','-x'],
            'wall_seconds':float(line('RSG_WALL_SECONDS')),'solver_seconds':sum(float(s) for s in re.findall(r'^\[RSG_SOLVER_SECONDS\] (.*)$',stdout,re.M)),
            'smt_calls':len(re.findall(r'\(check-sat\b',smt.read_text())),
            'unsat_core_calls':smt.read_text().count('(get-unsat-core)'), 'process':process,
            'environment_overrides':{k:env[k] for k in ('RSG_EXPERIMENT','RSG_PROFILE','RSG_ORDER','RSG_ATTRS')}}
    return parse_formula(result['formula_smt2']),result

def python_method(method,label):
    proc=run(label,[str(ROOT/'.venv/bin/python'),str(ROOT/'experiments/run_python_method.py'),method,label.replace('/','_')],timeout=120)
    if proc['exit_code']:raise RuntimeError('Python baseline failed: '+label)
    metrics=json.loads((ROOT/'results/runs'/f'{label.replace("/","_")}.json').read_text())
    metrics['process']=proc
    return parse_formula(metrics['formula_smt2']),metrics

def stats(values):
    q1,_,q3=statistics.quantiles(values,n=4,method='inclusive');iqr=q3-q1
    return {'n':len(values),'median':statistics.median(values),'min':min(values),'max':max(values),
            'q1':q1,'q3':q3,'outliers_tukey':[v for v in values if v<q1-1.5*iqr or v>q3+1.5*iqr]}

def main():
    c=Checker(ROOT/'logs/smt/interface');results={'configurations':{},'benchmark':{},'random_seed':20261010}
    def save(name,pair):
        r,rec=pair
        rec['validation']=c.validate(name,r)
        rec['equivalent_R0']=c.check(name+'_equiv_R0',z3.Xor(r,R0))
        rec['strict_over_R0']=c.check(name+'_strict_R0',z3.And(r,z3.Not(R0)))
        rec['equivalent_Rstar']=c.check(name+'_equiv_Rstar',z3.Xor(r,Rstar))
        if not rec['validation']['valid']:raise RuntimeError(name+' produced invalid set')
        results['configurations'][name]=rec
        (ROOT/'results/interface.json').write_text(json.dumps(results,indent=2)+'\n')
        return r
    save('A1',official('A1'))
    save('A2',official('A2',reverse=True))
    # Restart the real official context on every iteration to avoid persistent name tables.
    prev=R0;iterations=[]
    for i in range(10):
        seed_bpl=ROOT/'experiments'/f'A3_seed_{i}.bpl'
        if i==0:seed_bpl=None
        r,rec=official('A3_'+str(i),seed_bpl=seed_bpl)
        eq=c.check(f'A3_{i}_semantic_fixedpoint',z3.Xor(prev,r))
        iterations.append({'run':rec,'semantic_equivalence':eq})
        if eq['result']=='unknown':raise RuntimeError('UNKNOWN in fixedpoint check')
        if eq['result']=='unsat':break
        # Use complete returned Boogie DNF as next input, parsed by official Boogie.
        text=(ROOT/rec['process']['stdout']).read_text()
        formula=re.search(r'^\[INFO\] Generalized RS: (.*)$',text,re.M).group(1)
        (ROOT/'experiments'/f'A3_seed_{i+1}.bpl').write_text('function RSG_seed(p:int,x:int):bool { '+formula+' }\n'+(ROOT/'experiments/witness.bpl').read_text())
        prev=r
    rec=dict(rec);rec['iterations']=iterations;rec['safety_limit']=10;rec['fixedpoint_reached']=eq['result']=='unsat'
    save('A3',(r,rec))
    save('A5',official('A5',default_attributes=True))
    save('A4',python_method('A4','A4'))
    save('Joint-2-Selector',python_method('joint','Joint-2-Selector'))
    save('Closure-Repair',python_method('repair','Closure-Repair'))
    methods={'A1':lambda label:official(label),'A2':lambda label:official(label,reverse=True),
             'A5':lambda label:official(label,default_attributes=True),
             'Joint-2-Selector':lambda label:python_method('joint',label),
             'Closure-Repair':lambda label:python_method('repair',label)}
    results['benchmark_protocol']={'warmup_invocations':3,'measured_invocations':30,
        'order':'seeded shuffled round-robin','fresh_process_per_run':True,
        'official_wall':'Stopwatch around unmodified RSG, includes first-use JIT',
        'python_wall':'candidate construction plus all search checks; excludes output serialization',
        'solver_time':'official check/core round-trip; Python Solver.check only; not identical boundaries',
        'independent_validation':'outside algorithm timer','rss':'5ms sampled sum of process-tree RSS; GNU time max RSS also saved'}
    rng=random.Random(20261010)
    for warm in range(3):
        for name,fn in methods.items():fn(f'warmup/{name}_{warm}')
    raw={name:[] for name in methods}
    for i in range(30):
        order=list(methods);rng.shuffle(order)
        for name in order:
            r,rec=methods[name](f'benchmark/{name}_{i:02d}')
            validation=c.validate(f'bench_{name}_{i:02d}',r)
            if not validation['valid']:raise RuntimeError('Invalid repeated output')
            rec['validation']=validation;raw[name].append(rec)
        print('Completed measured round '+str(i+1),flush=True)
    for name,rows in raw.items():
        results['benchmark'][name]={'runs':rows,'wall_seconds':stats([r['wall_seconds'] for r in rows]),
            'solver_seconds':stats([r['solver_seconds'] for r in rows]),
            'process_wall_seconds':stats([r['process']['wall_seconds'] for r in rows]),
            'sampled_peak_tree_rss_kib':stats([r['process']['sampled_peak_tree_rss_kib'] for r in rows]),
            'smt_calls':stats([r['smt_calls'] for r in rows]),'unsat_core_calls':stats([r['unsat_core_calls'] for r in rows])}
    results['semantic_queries']=c.queries
    (ROOT/'results/interface.json').write_text(json.dumps(results,indent=2)+'\n')
    print('Interface experiments complete.',flush=True)

if __name__=='__main__':main()
