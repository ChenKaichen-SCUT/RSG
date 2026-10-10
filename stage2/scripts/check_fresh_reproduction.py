#!/usr/bin/env python3
"""Fresh native build plus frozen positive-case replay, after formal timing."""
import datetime,json,os,pathlib,shutil,subprocess,sys,time
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,PY,dump
tag=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
fresh=S/'work'/('fresh-reproduction-'+tag);stage=fresh/'stage2';stage.mkdir(parents=True)
for name in ('src','scripts','config'):shutil.copytree(S/name,stage/name)
instance='primary/TwoFloatInterv/call_001'
shutil.copytree(S/'corpus'/instance,stage/'corpus'/instance)
env=dict(os.environ,RSG_BASE_ROOT=os.environ.get('RSG_BASE_ROOT','/root/RSG'),RSG_PYTHON=str(PY))
steps=[]
for script,args in [('setup.py',[]),('replay_instance.py',[instance]),('compare_balanced.py',['--workers','1'])]:
 prefix=S/'logs/fresh_reproduction'/script;prefix.parent.mkdir(parents=True,exist_ok=True)
 start=time.monotonic();command=[str(PY),str(stage/'scripts'/script),*args]
 with open(str(prefix)+'.stdout','w') as out,open(str(prefix)+'.stderr','w') as err:
  p=subprocess.run(command,cwd=fresh,env=env,stdout=out,stderr=err)
 steps.append({'script':script,'command':command,'exit_code':p.returncode,'wall_seconds':time.monotonic()-start})
 if p.returncode:raise SystemExit('Fresh reproduction failed: '+script)
result=json.loads((stage/'results/comparison'/instance/'comparison.json').read_text())
assert result['status']=='compared'
assert all(m.get('validation',{}).get('valid') for m in result['methods'].values())
assert result['methods']['C_single']['versus_official']['relation']=='B_strictly_larger'
for name in ('logs','results','replay'):
 shutil.copytree(stage/name,S/name/'fresh_reproduction',dirs_exist_ok=True)
dump(S/'results/fresh_reproducibility.json',{'passed':True,'fresh_directory':str(fresh),'base_environment':env['RSG_BASE_ROOT'],
 'steps':steps,'instance':instance,'all_methods_valid':True,'C_strictly_larger_than_official':True,
 'scope':'New source copy and native build; frozen actual input replay and all seven methods, no RSLearn rerun. Reuses installed stage-1 runtime.'})
print('Fresh build and frozen positive-case replay passed.')
