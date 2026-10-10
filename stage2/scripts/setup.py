#!/usr/bin/env python3
"""Build stage 2 in its own directory; never rewrites stage 1 sources/results."""
import os,pathlib,shutil,subprocess,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,PY,run,dump
base=pathlib.Path(os.environ.get('RSG_BASE_ROOT',ROOT));official=base/'original/CondTerm/CondTerm'
if not (base/'work/pristine-bin/z3.exe').exists():
 raise SystemExit('First run the documented stage-1 setup/build in this clone, or set RSG_BASE_ROOT to an already built clone.')
dst=S/'work/traced'
for rel in ('src','experiment/scripts','ice'):
 shutil.copytree(official/rel,dst/rel,dirs_exist_ok=True,ignore=shutil.ignore_patterns('.git'))
for d in ('patches','results','logs'):(S/d).mkdir(exist_ok=True)
subprocess.run([str(PY),str(S/'scripts/instrument.py'),str(official),str(dst)],check=True)
r=run('setup/build',['xbuild','/t:Rebuild','/p:Configuration=Release','/p:LangVersion=Experimental','NewBoogie.sln'],cwd=dst/'ice/popl16_artifact/Boogie/Source',timeout=300)
if r['exit_code']:raise SystemExit('Native build failed; inspect '+r['stderr'])
binary=dst/'ice/popl16_artifact/Boogie/Binaries'
for name in ('z3.exe','c5.0.dt','c5.0.dt_penalty','c5.0.dt_entropy','c5.0.dt_entropy_penalty'):
 p=base/'work/pristine-bin'/name
 if p.exists():shutil.copy2(p,binary/name)
for p in (base/'work/pristine-bin').glob('c5.0.*'):shutil.copy2(p,binary/p.name)
# Rebuilding updates existing worker binaries, but refuses to delete run evidence.
for directory in (S/'work/workers').glob('*'):
 shutil.copytree(binary,directory/'ice/popl16_artifact/Boogie/Binaries',dirs_exist_ok=True)
dump(S/'results/stage2_setup.json',{'base_root':str(base),'official':str(official),'traced':str(dst),'build':r})
print('Stage 2 native tracing/replay ready.')
