#!/usr/bin/env python3
"""Losslessly archive all raw stage-2 evidence, with Git-sized parts and hashes."""
import collections,concurrent.futures,gzip,hashlib,json,os,pathlib,tarfile,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S,dump
evidence=S/'evidence';evidence.mkdir(exist_ok=True)
archive=evidence/'stage2-raw.tar.gz'
files=[]
for directory in ('corpus','logs','replay','results'):
 for p in sorted((S/directory).rglob('*')):
  if p.is_file():files.append(p)
def sha256(path):
 h=hashlib.sha256()
 with path.open('rb') as f:
  for block in iter(lambda:f.read(4*1024*1024),b''):h.update(block)
 return h.hexdigest()
manifest=[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha256(p)} for p in files]
class ParallelGzip:
 """Concatenated standard gzip members; bounded queue, no extra package needed."""
 def __init__(self,path,workers):
  self.file=path.open('wb');self.pool=concurrent.futures.ThreadPoolExecutor(max_workers=workers)
  self.pending=collections.deque();self.buffer=bytearray();self.limit=workers*2
 def submit(self,block):
  self.pending.append(self.pool.submit(gzip.compress,block,compresslevel=6,mtime=0))
  if len(self.pending)>=self.limit:self.file.write(self.pending.popleft().result())
 def write(self,data):
  self.buffer.extend(data)
  while len(self.buffer)>=8*1024*1024:
   self.submit(bytes(self.buffer[:8*1024*1024]));del self.buffer[:8*1024*1024]
  return len(data)
 def close(self):
  if self.buffer:self.submit(bytes(self.buffer));self.buffer.clear()
  while self.pending:self.file.write(self.pending.popleft().result())
  self.pool.shutdown();self.file.close()
writer=ParallelGzip(archive,min(16,os.cpu_count() or 1))
try:
 with tarfile.open(fileobj=writer,mode='w|') as tar:
  for p in files:tar.add(p,arcname=str(p.relative_to(ROOT)),recursive=False)
finally:writer.close()
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
 'compression':'Up to 16 parallel gzip workers; concatenated standard gzip members, transparently decoded by Python gzip/tarfile.',
 'parts':[{'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha256(p)} for p in parts],
 'raw_file_count':len(files),'raw_bytes':sum(r['bytes'] for r in manifest),'files':manifest})
index=[]
for p in sorted((S/'corpus').rglob('trace.json')):
 key=str(p.parent.relative_to(S/'corpus'))
 try:d=json.loads(p.read_text())
 except (ValueError,UnicodeError) as error:
  index.append({'instance':key,'index_status':'unparseable_preserved_raw_trace','error':str(error)});continue
 invocation=p.parent/'invocation.json'
 try:metadata=json.loads(invocation.read_text()) if invocation.exists() else None
 except (ValueError,UnicodeError) as error:metadata={'index_error':str(error)}
 index.append({'instance':key,
  **{k:d.get(k) for k in ('variables','input_ast','output_ast','input_boogie','output_boogie','dnf','attributes','context_bindings','distances','rsg_seconds','smt_calls','core_calls')},
  'invocation':metadata,
  'proof_context_path':str((p.parent/'context.smt2').relative_to(ROOT)),'raw_prover_path':str((p.parent/'prover.smt2').relative_to(ROOT))})
dump(S/'results/corpus_index.json',index)
print(json.dumps({'raw_files':len(files),'raw_bytes':sum(r['bytes'] for r in manifest),'archive_bytes':sum(p.stat().st_size for p in parts),'parts':len(parts)}))
