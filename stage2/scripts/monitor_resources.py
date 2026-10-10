#!/usr/bin/env python3
"""Low-overhead host utilization audit, beginning when explicitly launched."""
import argparse,datetime,json,pathlib,time
ap=argparse.ArgumentParser();ap.add_argument('--pid',type=int,required=True);ap.add_argument('--output',type=pathlib.Path,required=True);a=ap.parse_args()
def cpu():return list(map(int,pathlib.Path('/proc/stat').read_text().splitlines()[0].split()[1:9]))
a.output.parent.mkdir(parents=True,exist_ok=True);previous=cpu()
with a.output.open('w') as f:
 while pathlib.Path(f'/proc/{a.pid}').exists():
  time.sleep(5);current=cpu();delta=[x-y for x,y in zip(current,previous)];previous=current
  mem={r.split(':')[0]:int(r.split()[1]) for r in pathlib.Path('/proc/meminfo').read_text().splitlines()}
  row={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'cpu_busy_percent':100*(sum(delta)-delta[3]-delta[4])/max(1,sum(delta)),
       'memory_total_kib':mem['MemTotal'],'memory_available_kib':mem['MemAvailable'],'loadavg':pathlib.Path('/proc/loadavg').read_text().strip()}
  f.write(json.dumps(row)+'\n');f.flush()
