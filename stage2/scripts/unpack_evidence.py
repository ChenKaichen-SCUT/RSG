#!/usr/bin/env python3
import hashlib,json,pathlib,shutil,tarfile,tempfile
ROOT=pathlib.Path(__file__).resolve().parents[2]
manifest=json.loads((ROOT/'stage2/evidence/manifest.json').read_text())
with tempfile.TemporaryFile() as stream:
 for r in manifest['parts']:
  p=ROOT/r['path']
  if hashlib.sha256(p.read_bytes()).hexdigest()!=r['sha256']:raise SystemExit('Archive checksum mismatch: '+r['path'])
  with p.open('rb') as source:shutil.copyfileobj(source,stream)
 stream.seek(0)
 with tarfile.open(fileobj=stream,mode='r:gz') as tar:
  for member in tar.getmembers():
   dest=(ROOT/member.name).resolve()
   if ROOT not in dest.parents or not member.isfile():raise SystemExit('Unexpected archive member: '+member.name)
  tar.extractall(ROOT)
for r in manifest['files']:
 p=ROOT/r['path']
 if p.stat().st_size!=r['bytes'] or hashlib.sha256(p.read_bytes()).hexdigest()!=r['sha256']:raise SystemExit('Raw checksum mismatch: '+r['path'])
print('Verified and unpacked',manifest['raw_file_count'],'raw evidence files.')
