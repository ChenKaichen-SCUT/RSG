#!/usr/bin/env python3
"""Use the artifact's template preprocessor and unchanged baseline binary."""
import os,sys,types
from record_command import ROOT,run

def main():
    project=ROOT/'work/CondTerm';os.chdir(project)
    sys.path.insert(0,str(project/'src'))
    from RSLearner.RSLearner import RSLearner
    original=project/'experiment/condterm-benchmarks-Instrumented/WhileTrue/WhileTrue.bpl'
    tmp=ROOT/'work/smoke/rsl';tmp.mkdir(parents=True,exist_ok=True)
    learner=RSLearner(types.SimpleNamespace(SMTFile=None),['t'],str(original),str(tmp),
                      'WhileTrue',rsGeneralize=True,dataSharePara={'DataSaving':False})
    learner.GenerateRSLBplFile()
    env={k:v for k,v in os.environ.items() if not k.startswith('RSG_')}
    flags=['mono','Boogie.exe','/nologo','/noinfer','/contractInfer','/mlHoudini:dt_penalty',
           '/RSInfer','/trace','/printAssignment','/RSGeneralize']
    for name,bpl in [('official_smoke',learner.fileName),
                     ('original_witness_rslearn',str(ROOT/'experiments/witness.bpl'))]:
        cmd=flags+['/proverLog:'+str(ROOT/'logs'/f'{name}.smt2'),bpl]
        rec=run(name,cmd,cwd=ROOT/'work/pristine-bin',timeout=90,env=env)
        output=(ROOT/rec['stdout']).read_text()
        if rec['exit_code'] or '1 verified, 0 errors' not in output:
            raise RuntimeError('Official smoke/standalone failed: '+name)

if __name__=='__main__':main()
