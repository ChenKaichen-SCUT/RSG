#!/usr/bin/env python3
"""Losslessly archive all raw stage-2 evidence, with Git-sized parts and hashes."""
import gzip,hashlib,json,pathlib,tarfile,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,dump
evidence=S/'evidence';evidence.mkdir(exist_ok=True)
archive=evidence/'stage2-raw.tar.gz'
files=[]
for directory in ('corpus','logs','replay','results'):
 for p in sorted((S/directory).rglob('*')):
  if p.is_file():files.append(p)
manifest=[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files]
with tarfile.open(archive,'w:gz',compresslevel=6) as tar:
 for p in files:tar.add(p,arcname=str(p.relative_to(ROOT)),recursive=False)
parts=[];limit=64*1024*1024
if archive.stat().st_size>limit:
 with archive.open('rb') as source:
  i=0
  while True:
   block=source.read(limit)
   if not block:break
   p=evidence/f'stage2-raw.tar.gz.part{i:03d}';p.write_bytes(block);parts.append(p);i+=1
 archive.unlink()
else:parts=[archive]
dump(evidence/'manifest.json',{'format':'ordered parts concatenate into gzip tar; paths are relative to repository root',
 'parts':[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in parts],
 'raw_file_count':len(files),'raw_bytes':sum(r['bytes'] for r in manifest),'files':manifest})
index=[]
for p in sorted((S/'corpus').glob('*/*/call_*/trace.json')):
 d=json.loads(p.read_text());index.append({'instance':str(p.parent.relative_to(S/'corpus')),
  **{k:d.get(k) for k in ('variables','input_ast','output_ast','input_boogie','output_boogie','dnf','distances','rsg_seconds','smt_calls','core_calls')},
  'proof_context_path':str((p.parent/'context.smt2').relative_to(ROOT)),'raw_prover_path':str((p.parent/'prover.smt2').relative_to(ROOT))})
dump(S/'results/corpus_index.json',index)
print(json.dumps({'raw_files':len(files),'raw_bytes':sum(r['bytes'] for r in manifest),'archive_bytes':sum(p.stat().st_size for p in parts),'parts':len(parts)}))
