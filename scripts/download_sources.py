#!/usr/bin/env python3
"""Fetch authoritative metadata and paper before any artifact extraction."""
import datetime,hashlib,json,pathlib,time,urllib.request
from html.parser import HTMLParser
ROOT=pathlib.Path(__file__).resolve().parents[1]

class RecordParser(HTMLParser):
    record=None
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        if attrs.get('id')=='recordVersions':self.record=json.loads(attrs['data-record'])

def main():
    rows=[]
    for name,url in [('project.html','https://thufv.github.io/research/icse26'),
                     ('icse26.pdf','https://feihe.github.io/materials/icse26.pdf'),
                     ('zenodo.html','https://zenodo.org/records/16891885')]:
        path=ROOT/'sources'/name
        if path.exists():continue
        before=time.perf_counter()
        with urllib.request.urlopen(url,timeout=90) as resp:
            data=resp.read();headers={k:v for k,v in resp.headers.items() if k.lower()!='set-cookie'};final=resp.url
        path.write_bytes(data)
        rows.append({'url':url,'final_url':final,'file':name,'size_bytes':len(data),
                     'sha256':hashlib.sha256(data).hexdigest(),'headers':headers,
                     'seconds':time.perf_counter()-before})
    metadata=ROOT/'sources/zenodo_metadata.json'
    if not metadata.exists():
        p=RecordParser();p.feed((ROOT/'sources/zenodo.html').read_text())
        assert p.record and p.record['id']=='16891885'
        metadata.write_text(json.dumps(p.record,indent=2)+'\n')
    if rows:
        (ROOT/'logs/source_downloads.json').write_text(json.dumps(rows,indent=2)+'\n')
    print(json.dumps(rows,indent=2))

if __name__=='__main__':main()
