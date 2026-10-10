#!/usr/bin/env python3
"""Build an unmodified baseline, smoke-test it, then build the opt-in hook."""
import pathlib,shutil,subprocess,sys
from record_command import ROOT,run

PROJECT=ROOT/'work/CondTerm'
SOURCE=PROJECT/'ice/popl16_artifact/Boogie/Source'
BIN=PROJECT/'ice/popl16_artifact/Boogie/Binaries'
C50=PROJECT/'ice/popl16_artifact/C50'

def checked(name,cmd,cwd=None):
    rec=run(name,cmd,cwd=cwd)
    if rec['exit_code']:raise RuntimeError('Failed: '+name+'; see '+rec['stderr'])

def save_bin(name):
    target=ROOT/'work'/name
    if target.exists():shutil.rmtree(target)
    shutil.copytree(BIN,target)

def main():
    # Restore all official inputs, including project files and helpers.
    checked('build/restore',['rsync','-a',str(ROOT/'original/CondTerm/CondTerm')+'/',str(PROJECT)+'/'])
    build=['xbuild','/t:Rebuild','/p:Configuration=Release','/p:LangVersion=Experimental','NewBoogie.sln']
    checked('build/pristine_boogie',build,SOURCE)
    checked('build/c50_clean',['make','clean'],C50)
    checked('build/c50',['make','all'],C50)
    for path in C50.glob('c5.0.*'):
        if path.is_file():shutil.copy2(path,BIN/path.name)
    solver=ROOT/'.venv/bin/z3'
    version=subprocess.check_output([str(solver),'--version'],text=True).strip()
    if not version.startswith('Z3 version 4.8.9 '):raise RuntimeError('Expected Z3 4.8.9: '+version)
    shutil.copy2(solver,BIN/'z3.exe');(BIN/'z3.exe').chmod(0o755)
    save_bin('pristine-bin')
    checked('build/smoke_suite',[sys.executable,str(ROOT/'scripts/smoke_test.py')])
    checked('build/hook',[sys.executable,str(ROOT/'scripts/add_experiment_hook.py')])
    checked('build/instrumented_boogie',build,SOURCE)
    save_bin('instrumented-bin')
    print('Pristine and instrumented builds ready; official RSG body unchanged.')

if __name__=='__main__':main()
