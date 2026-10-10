#!/usr/bin/env python3
import ast,hashlib,json,pathlib,random
ROOT=pathlib.Path(__file__).resolve().parents[2];S=ROOT/'stage2'
base=ROOT/'original/CondTerm/CondTerm'
tree=ast.parse((base/'experiment/scripts/DataInfo.py').read_text(encoding='utf-8-sig'))
rows=[]
for node in tree.body:
 if isinstance(node,ast.Assign) and isinstance(node.targets[0],ast.Name) and node.targets[0].id in ('TaskInfo_Nonterm','TaskInfo_Term'):
  category='nonterm' if node.targets[0].id=='TaskInfo_Nonterm' else 'term'
  for t in node.value.elts:
   name=ast.literal_eval(t.elts[0]);variables=ast.literal_eval(t.elts[1]);files={};missing=[]
   for kind,suffix in [('nle',''),('le','-Lexicographic')]:
    for ext in ('c','bpl'):
     p=base/f'experiment/condterm-benchmarks-Instrumented{suffix}'/name/(name+'.'+ext)
     if p.exists():files[kind+'.'+ext]={'path':str(p.relative_to(ROOT)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
     else:missing.append(str(p.relative_to(ROOT)))
   bpl=base/files['nle.bpl']['path'].split('CondTerm/CondTerm/',1)[1] if 'nle.bpl' in files else None
   text=bpl.read_text() if bpl else ''
   rows.append({'id':name,'category':category,'variables':variables,'files':files,'missing':missing,
                'while_count':text.count('while ('),'split':'holdout'})
rng=random.Random(20261010)
for cat in ('term','nonterm'):
 eligible=sorted([r for r in rows if r['category']==cat and not r['missing']],key=lambda r:r['id'])
 rng.shuffle(eligible)
 for r in eligible[:12]:r['split']='smoke'
res={'base_commit':'769bca6','program_count':len(rows),'programs':rows}
(S/'config/manifest.json').write_text(json.dumps(res,indent=2)+'\n')
print(json.dumps({'programs':len(rows),'categories':{c:sum(r['category']==c for r in rows) for c in ('term','nonterm')},'missing':sum(bool(r['missing']) for r in rows),'smoke':[r['id'] for r in rows if r['split']=='smoke']},indent=2))
