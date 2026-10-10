#!/usr/bin/env python3
"""Assemble public source/evidence without archives, build outputs or HTTP cookies.

Run after syncing server evidence to logs/server/ in the staging workspace.
The target is an existing clone; its .git directory is never changed here.
"""
import argparse,hashlib,json,pathlib,re,shutil
ROOT=pathlib.Path(__file__).resolve().parents[1]

def main():
    ap=argparse.ArgumentParser();ap.add_argument('target');args=ap.parse_args()
    target=pathlib.Path(args.target).resolve();target.mkdir(parents=True,exist_ok=True)
    if target==ROOT:raise ValueError('Choose a separate submission clone')
    ignored=shutil.ignore_patterns('__pycache__','*.pyc','.git')
    for name in ('experiments','scripts','results','reports','patches','reproduction-check'):
        shutil.copytree(ROOT/name,target/name,dirs_exist_ok=True,ignore=ignored)
    for name in ('README.md','.gitignore','.gitattributes','指引.txt'):shutil.copy2(ROOT/name,target/name)
    formal=ROOT/'logs/server';assert formal.is_dir(),'Sync formal server logs first'
    shutil.copytree(formal,target/'logs',dirs_exist_ok=True,ignore=ignored)
    prep=target/'logs/preparation';prep.mkdir(parents=True,exist_ok=True)
    for p in (ROOT/'logs').iterdir():
        if p.is_file():shutil.copy2(p,prep/p.name)
    (target/'sources').mkdir(exist_ok=True)
    for name in ('icse26.pdf','icse26.txt','project.html','zenodo_metadata.json'):
        shutil.copy2(ROOT/'sources'/name,target/'sources'/name)
    manifest={};skipped=[]
    for p in sorted((ROOT/'original/CondTerm').rglob('*')):
        if not p.is_file() or '.git' in p.parts:continue
        rel=p.relative_to(ROOT);data=p.read_bytes()
        # Text source snapshot; the complete artifact is independently pinned.
        if b'\0' in data or p.suffix.lower() in ('.dll','.exe','.pdb','.o','.zip','.rar','.pyc','.suo'):
            skipped.append(str(rel));continue
        dst=target/rel;dst.parent.mkdir(parents=True,exist_ok=True);dst.write_bytes(data)
        manifest[str(rel)]={'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
    (target/'results/published_source_manifest.json').write_text(json.dumps({
        'scope':'Byte-identical text files from the verified pristine artifact; full artifact restored by setup.sh.',
        'files':manifest,'skipped_from_local_snapshot':skipped},indent=2)+'\n')
    redactions=[]
    def clean(node):
        if isinstance(node,dict):return {k:clean(v) for k,v in node.items() if k.lower()!='set-cookie'}
        if isinstance(node,list):return [clean(v) for v in node]
        return node
    for base in (target/'logs',target/'reproduction-check/logs'):
        for p in base.rglob('*'):
            if not p.is_file() or p.suffix in ('.gz',):continue
            raw=p.read_bytes()
            if b'set-cookie' not in raw.lower():continue
            s=raw.decode('utf-8')
            if p.suffix=='.json':
                new=json.dumps(clean(json.loads(s)),indent=2)+'\n'
            else:
                new=''.join(line for line in s.splitlines(keepends=True)
                            if not re.match(r'^\s*(?:"?set-cookie"?\s*:)',line,re.I))
            if new!=s:
                p.write_text(new);redactions.append(str(p.relative_to(target)))
    (target/'results/publication_redactions.json').write_text(json.dumps({
        'redaction':'Anonymous HTTP Set-Cookie headers removed; experimental numbers/stdout unchanged.',
        'files':redactions},indent=2)+'\n')
    print(json.dumps({'source_files':len(manifest),'skipped_binary_files':len(skipped),
                      'cookie_redacted_files':len(redactions)},indent=2))

if __name__=='__main__':main()
