#!/usr/bin/env python3
"""Run an argv command, retaining stdout/stderr, elapsed time and GNU time RSS."""
import argparse, datetime, json, pathlib, subprocess, time,os,signal

ROOT = pathlib.Path(__file__).resolve().parents[1]

def run(name, argv, cwd=None, timeout=None, env=None):
    base = ROOT / 'logs' / name
    base.parent.mkdir(parents=True, exist_ok=True)
    record = dict(command=argv, cwd=str(cwd or ROOT),
                  started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
    start = time.perf_counter()
    with open(str(base)+'.stdout', 'w') as out, open(str(base)+'.stderr', 'w') as err:
        try:
            p = subprocess.Popen(['/usr/bin/time','-v','-o',str(base)+'.time',*argv],
                                 cwd=cwd or ROOT, stdout=out, stderr=err,
                                 env=env,start_new_session=True)
            peak_tree=0
            while p.poll() is None:
                pending=[p.pid];rss=0
                while pending:
                    pid=pending.pop()
                    try:
                        status=pathlib.Path(f'/proc/{pid}/status').read_text()
                        for line in status.splitlines():
                            if line.startswith('VmRSS:'):rss+=int(line.split()[1])
                        pending.extend(int(s) for s in pathlib.Path(f'/proc/{pid}/task/{pid}/children').read_text().split())
                    except (OSError,ValueError):pass
                peak_tree=max(peak_tree,rss)
                if timeout and time.perf_counter()-start > timeout:
                    os.killpg(p.pid,signal.SIGKILL);p.wait()
                    raise subprocess.TimeoutExpired(argv,timeout)
                time.sleep(0.005)
            record['sampled_peak_tree_rss_kib']=peak_tree
            record['rss_sampling_interval_seconds']=0.005
            record['exit_code'] = p.returncode
        except subprocess.TimeoutExpired:
            record.update(exit_code=124, timed_out=True)
        except OSError as exc:
            record.update(exit_code=127, error=str(exc))
    record['wall_seconds'] = time.perf_counter()-start
    record['stdout'] = str(base.relative_to(ROOT))+'.stdout'
    record['stderr'] = str(base.relative_to(ROOT))+'.stderr'
    tf = pathlib.Path(str(base)+'.time')
    if tf.exists():
        for line in tf.read_text().splitlines():
            if 'Maximum resident set size' in line:
                record['peak_rss_kib'] = int(line.rsplit(':',1)[1].strip())
    pathlib.Path(str(base)+'.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record), flush=True)
    return record

if __name__ == '__main__':
    ap=argparse.ArgumentParser(); ap.add_argument('--name',required=True)
    ap.add_argument('--cwd'); ap.add_argument('--timeout',type=float)
    ap.add_argument('command',nargs=argparse.REMAINDER); args=ap.parse_args()
    command=args.command[1:] if args.command[:1]==['--'] else args.command
    raise SystemExit(run(args.name,command,args.cwd,args.timeout)['exit_code'])
