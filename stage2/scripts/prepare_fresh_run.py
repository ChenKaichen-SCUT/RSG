#!/usr/bin/env python3
"""Move prior stage-2 outputs aside before an intentionally fresh full rerun."""
import datetime,pathlib,shutil,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S
backup=S/'work/previous-runs'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S.%fZ')
for relative in ('corpus','logs','results','replay','work/runs'):
 source=S/relative
 if source.exists():
  target=backup/relative;target.parent.mkdir(parents=True,exist_ok=True);shutil.move(source,target)
for name in ('corpus','logs','results','replay'):(S/name).mkdir(exist_ok=True)
print('Prior stage2 outputs preserved in',backup)
