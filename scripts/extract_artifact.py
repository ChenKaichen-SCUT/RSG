#!/usr/bin/env python3
import hashlib,json,pathlib,subprocess,time
from record_command import run,ROOT

def main():
    artifact=ROOT/'sources/CondTerm-Artifact.rar'
    meta=json.loads((ROOT/'sources/zenodo_metadata.json').read_text())
    item=next(iter(meta['files']['entries'].values()))
    md5=hashlib.md5()
    with artifact.open('rb') as f:
        for block in iter(lambda:f.read(1024*1024),b''):md5.update(block)
    assert artifact.stat().st_size==item['size'] and 'md5:'+md5.hexdigest()==item['checksum']
    assert run('artifact_crc',['unrar','t','-idq',str(artifact)])['exit_code']==0
    assert run('artifact_extract',['unrar','x','-o-','-idq',str(artifact),str(ROOT/'original')+'/'])['exit_code']==0
    base=ROOT/'original/CondTerm'
    data={'git_head':subprocess.check_output(['git','-C',str(base),'rev-parse','HEAD'],text=True).strip(),
          'git_status':subprocess.check_output(['git','-C',str(base),'status','--porcelain'],text=True),
          'files':{}}
    for path in sorted(base.rglob('*')):
        if path.is_file() and '.git' not in path.parts:
            data['files'][str(path.relative_to(base))]={'bytes':path.stat().st_size,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()}
    (ROOT/'results/pristine_manifest.json').write_text(json.dumps(data,indent=2)+'\n')
    work=ROOT/'work/CondTerm';work.mkdir(parents=True,exist_ok=True)
    assert run('working_copy',['rsync','-a','--exclude=.git',str(base/'CondTerm')+'/',str(work)+'/'])['exit_code']==0
    print(json.dumps({'git_head':data['git_head'],'file_count':len(data['files']),'git_status':data['git_status'][:3000]},indent=2))

if __name__=='__main__':main()
