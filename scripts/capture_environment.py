#!/usr/bin/env python3
import datetime,json,pathlib,platform,subprocess,os
ROOT=pathlib.Path(__file__).resolve().parents[1]
cmds={'os':['cat','/etc/os-release'],'cpu':['lscpu'],'memory':['free','-h'],
      'disk':['df','-h',str(ROOT)],'gcc':['gcc','--version'],'g++':['g++','--version'],
      'clang':['clang','--version'],'python':['python3','--version'],'docker':['docker','--version'],
      'git':['git','--version'],'mono':['mono','--version'],'msbuild':['msbuild','-version'],
      'xbuild':['xbuild','/version'],'z3':['z3','--version'],'cvc5':['cvc5','--version'],
      'packages':['dpkg-query','-W'],'pip':[str(ROOT/'.venv/bin/pip'),'freeze']}
out={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
     'platform':platform.platform(),'hostname':platform.node(),'commands':{}}
for name,cmd in cmds.items():
    try:
        r=subprocess.run(cmd,capture_output=True,text=True,timeout=30)
        out['commands'][name]={'command':cmd,'stdout':r.stdout,'stderr':r.stderr,'exit_code':r.returncode}
    except Exception as e:out['commands'][name]={'command':cmd,'error':str(e)}
(ROOT/'results/environment.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
