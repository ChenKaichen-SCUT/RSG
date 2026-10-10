#!/usr/bin/env python3
"""Download the exact URL and checksum discovered in Zenodo record metadata."""
import concurrent.futures, hashlib, json, pathlib, subprocess, time
ROOT=pathlib.Path(__file__).resolve().parents[1]
META=json.loads((ROOT/'sources/zenodo_metadata.json').read_text())
ITEM=next(iter(META['files']['entries'].values()))
URL=META['links']['self_html']+'/files/'+ITEM['key']
SIZE=ITEM['size']; CHUNK=8*1024*1024
PARTS=ROOT/'sources/artifact_parts'; PARTS.mkdir(exist_ok=True)
LOG=ROOT/'logs/download_parts'; LOG.mkdir(exist_ok=True)

def download(i):
    start=i*CHUNK;end=min(SIZE,(i+1)*CHUNK)-1
    path=PARTS/f'{i:03d}.part';base=LOG/f'{i:03d}'
    if path.exists() and path.stat().st_size==end-start+1:
        return {'part':i,'cached':True,'bytes':path.stat().st_size}
    records=[]
    for attempt in range(4):
        existing=path.stat().st_size if path.exists() else 0
        actual_start=start+existing
        target=pathlib.Path(str(path)+'.tail') if existing else path
        cmd=['curl','-L','--fail','--connect-timeout','20','--max-time','600',
             '-r',f'{actual_start}-{end}','-D',str(base)+'.headers','-o',str(target),URL]
        before=time.perf_counter()
        with open(str(base)+'.stdout','a') as out,open(str(base)+'.stderr','a') as err:
            r=subprocess.run(cmd,stdout=out,stderr=err)
        headers=pathlib.Path(str(base)+'.headers').read_text()
        pathlib.Path(str(base)+'.headers').write_text(''.join(line for line in headers.splitlines(keepends=True) if not line.lower().startswith('set-cookie:')))
        range_ok=f'content-range: bytes {actual_start}-{end}/{SIZE}' in headers.lower()
        if existing and target.exists() and range_ok:
            with path.open('ab') as out:out.write(target.read_bytes())
            target.unlink()
        ok=(r.returncode==0 and path.stat().st_size==end-start+1 and range_ok)
        row={'part':i,'attempt':attempt,'command':cmd,'exit_code':r.returncode,
             'seconds':time.perf_counter()-before,'valid_range':ok}
        records.append(row)
        pathlib.Path(str(base)+'.json').write_text(json.dumps(records,indent=2))
        if ok:
            print(json.dumps(row),flush=True);return row
        time.sleep(2+attempt*2)
    raise RuntimeError(f'Part {i} failed: see {base}')

def main():
    before=time.perf_counter()
    existing=ROOT/'sources'/ITEM['key']
    if existing.exists() and existing.stat().st_size==SIZE:
        md5=hashlib.md5();sha=hashlib.sha256()
        with existing.open('rb') as f:
            for data in iter(lambda:f.read(1024*1024),b''):md5.update(data);sha.update(data)
        if 'md5:'+md5.hexdigest()==ITEM['checksum']:
            result={'source_url':URL,'record_id':META['id'],'artifact_version':META['ui']['version'],
                    'publication_date':META['metadata']['publication_date'],'size_bytes':SIZE,
                    'expected_size':SIZE,'expected_checksum':ITEM['checksum'],'md5':md5.hexdigest(),
                    'sha256':sha.hexdigest(),'seconds':time.perf_counter()-before,'cached':True,'verified':True}
            (ROOT/'results/download_manifest.json').write_text(json.dumps(result,indent=2)+'\n')
            print(json.dumps(result,indent=2));return
    with concurrent.futures.ThreadPoolExecutor(max_workers=32) as pool:
        rows=list(pool.map(download,range((SIZE+CHUNK-1)//CHUNK)))
    out=ROOT/'sources'/ITEM['key'];md5=hashlib.md5();sha=hashlib.sha256()
    with out.open('wb') as f:
        for i in range(len(rows)):
            data=(PARTS/f'{i:03d}.part').read_bytes();f.write(data);md5.update(data);sha.update(data)
    result={'source_url':URL,'record_id':META['id'],'artifact_version':META['ui']['version'],
            'publication_date':META['metadata']['publication_date'],'size_bytes':out.stat().st_size,
            'expected_size':SIZE,'expected_checksum':ITEM['checksum'],'md5':md5.hexdigest(),
            'sha256':sha.hexdigest(),'seconds':time.perf_counter()-before,'parts':rows}
    result['verified']=result['size_bytes']==SIZE and 'md5:'+result['md5']==ITEM['checksum']
    (ROOT/'results/download_manifest.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2),flush=True)
    assert result['verified'],'Artifact integrity mismatch'

if __name__=='__main__':main()
