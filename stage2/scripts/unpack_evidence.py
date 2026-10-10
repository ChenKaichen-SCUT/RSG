#!/usr/bin/env python3
import argparse,gzip,hashlib,json,pathlib,shutil,tarfile,tempfile
ROOT=pathlib.Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser();ap.add_argument('--verify-only',action='store_true');args=ap.parse_args()
manifest=json.loads((ROOT/'stage2/evidence/manifest.json').read_text())
expected={r['path']:r for r in manifest['files']};seen=set()
with tempfile.TemporaryFile() as stream:
 for r in manifest['parts']:
  p=ROOT/r['path']
  h=hashlib.sha256();count=0
  with p.open('rb') as source:
   for block in iter(lambda:source.read(4*1024*1024),b''):
    count+=len(block);h.update(block);stream.write(block)
  if count!=r['bytes'] or h.hexdigest()!=r['sha256']:raise SystemExit('Archive checksum mismatch: '+r['path'])
 stream.seek(0)
 # GzipFile handles concatenated members; tarfile's raw streaming zlib adapter
 # does not restart its decoder at each parallel-compression member boundary.
 with gzip.GzipFile(fileobj=stream,mode='rb') as decoded, tarfile.open(fileobj=decoded,mode='r|') as tar:
  for member in tar:
   name=pathlib.PurePosixPath(member.name)
   if name.is_absolute() or '..' in name.parts or not member.isfile() or member.name not in expected or member.name in seen:
    raise SystemExit('Unexpected archive member: '+member.name)
   r=expected[member.name];h=hashlib.sha256();count=0;target=None
   if not args.verify_only:
    dest=(ROOT/member.name).resolve()
    if ROOT not in dest.parents:raise SystemExit('Archive path escapes through a symbolic link: '+member.name)
    dest.parent.mkdir(parents=True,exist_ok=True);target=dest.open('wb')
   try:
    with tar.extractfile(member) as source:
     for block in iter(lambda:source.read(4*1024*1024),b''):
      count+=len(block);h.update(block)
      if target:target.write(block)
   finally:
    if target:target.close()
   if count!=r['bytes'] or h.hexdigest()!=r['sha256']:raise SystemExit('Raw checksum mismatch: '+member.name)
   seen.add(member.name)
if seen!=set(expected) or len(seen)!=manifest['raw_file_count']:raise SystemExit('Missing raw evidence files')
print('Verified'+(' without extracting' if args.verify_only else ' and unpacked'),len(seen),'raw evidence files.')
