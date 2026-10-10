import datetime,json,os,pathlib,signal,subprocess,time,sys
ROOT=pathlib.Path(__file__).resolve().parents[2];S=ROOT/'stage2'
PY=pathlib.Path(os.environ.get('RSG_PYTHON',str(ROOT/'.venv/bin/python') if (ROOT/'.venv/bin/python').exists() else sys.executable))
def dump(path,obj):
 path=pathlib.Path(path);path.parent.mkdir(parents=True,exist_ok=True);path.write_text(json.dumps(obj,indent=2,ensure_ascii=False)+'\n')
def run(name,cmd,cwd=None,env=None,timeout=300):
 base=S/'logs'/name;base.parent.mkdir(parents=True,exist_ok=True)
 record={'command':list(map(str,cmd)),'cwd':str(cwd or ROOT),'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
         'pid_namespace_isolation':True}
 start=time.perf_counter();peak=0
 with open(str(base)+'.stdout','w') as out,open(str(base)+'.stderr','w') as err:
  # Official CondTerm kills all mono/z3/c5 processes visible through ps -A.
  # A private PID namespace preserves that behavior within this run only.
  proc=subprocess.Popen(['/usr/bin/time','-v','-o',str(base)+'.time','unshare','--pid','--fork','--mount-proc',*record['command']],cwd=cwd or ROOT,env=env,stdout=out,stderr=err,start_new_session=True)
  while proc.poll() is None:
   pending=[proc.pid];rss=0
   while pending:
    pid=pending.pop()
    try:
     for ln in pathlib.Path(f'/proc/{pid}/status').read_text().splitlines():
      if ln.startswith('VmRSS:'):rss+=int(ln.split()[1])
     pending.extend(map(int,pathlib.Path(f'/proc/{pid}/task/{pid}/children').read_text().split()))
    except (OSError,ValueError):pass
   peak=max(peak,rss)
   if time.perf_counter()-start>timeout:
    os.killpg(proc.pid,signal.SIGKILL);proc.wait();record['timeout']=True;break
   time.sleep(.01)
  record['exit_code']=124 if record.get('timeout') else proc.returncode
 record.update(wall_seconds=time.perf_counter()-start,sampled_peak_tree_rss_kib=peak,rss_sampling_ms=10,
               stdout=str(base.relative_to(ROOT))+'.stdout',stderr=str(base.relative_to(ROOT))+'.stderr')
 dump(str(base)+'.json',record);return record
