#!/usr/bin/env python3
import json,os,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,PY,run,dump
script="import os,json,subprocess; print(json.dumps({'pid':os.getpid(),'namespace':os.readlink('/proc/self/ns/pid'),'visible_processes':subprocess.check_output(['ps','-A','-o','pid,comm'],text=True)}))"
r=run('isolation/probe',[PY,'-c',script],timeout=10)
if r['exit_code']:
 dump(S/'results/pid_isolation.json',{'passed':False,'process':r})
 raise SystemExit('PID/mount namespace unavailable; inspect '+r['stderr']+'. Do not run concurrent official CondTerm without isolation.')
child=json.loads((ROOT/r['stdout']).read_text());parent=os.readlink('/proc/self/ns/pid')
result={'passed':r['exit_code']==0 and child['pid']==1 and child['namespace']!=parent,'parent_namespace':parent,'child':child,'process':r,
 'reason':'Official CondTerm.py kill_related_process calls kill_by_name using ps -A at lines 453/525/610. Private PID and /proc namespaces isolate those official cleanup calls without modifying algorithm or cleanup semantics.'}
dump(S/'results/pid_isolation.json',result);assert result['passed'];print('PID namespace and private /proc verified.')
