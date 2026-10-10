#!/usr/bin/env python3
"""Audit every invocation, including no-RSG calls and interrupted attempts."""
import collections,json,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S,dump
rows=[]
for directory in sorted((S/'corpus/primary').glob('*/call_*')):
 invocation=json.loads((directory/'invocation.json').read_text())
 stdout=(directory/'native.stdout').read_text(errors='replace') if (directory/'native.stdout').exists() else ''
 markers=stdout.count('[INFO] Current RS:');trace=(directory/'trace.json').exists()
 rows.append({'instance':str(directory.relative_to(S/'corpus')),'outer_iteration':invocation['outer_iteration'],
  'serial':invocation['serial'],'seed':invocation['seed'],'data_sharing':invocation['data_sharing'],
  'rsg_enabled':'/RSGeneralize' in invocation['command'],'natural_seed_announcements':markers,'complete_trace':trace,
  'status':'complete_trace' if trace else 'seed_announced_without_trace' if markers else 'rsl_without_rsg_seed_announcement'})
counts=collections.Counter(r['status'] for r in rows)
dump(S/'results/corpus_audit.json',{'rslearn_invocation_directories':len(rows),'counts':dict(counts),'calls':rows,
 'entry_evidence':'Official LearnInv prints [INFO] Current RS immediately before the enabled modifiedGeneralizeRS_2 call. Cross-check this marker with every completed structured trace; do not equate every RSLearn invocation to an RSG call.'})
print(dict(counts))
