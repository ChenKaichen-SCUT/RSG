#!/usr/bin/env python3
"""Assemble actual run records and fail if required evidence is missing/UNKNOWN."""
import datetime,json,pathlib
ROOT=pathlib.Path(__file__).resolve().parents[1]

def read(name):return json.loads((ROOT/'results'/f'{name}.json').read_text())

def main():
    data={k:read(k) for k in ('download_manifest','pristine_manifest','environment',
          'hook_integrity','independent_smt','frontend_equivalence','interface',
          'exact_single_term','end_to_end')}
    unknown=[]
    def visit(node,path):
        if isinstance(node,dict):
            if node.get('result') in ('unknown','UNKNOWN'):unknown.append(path)
            for k,v in node.items():visit(v,path+'/'+k)
        elif isinstance(node,list):
            for i,v in enumerate(node):visit(v,path+'/'+str(i))
    visit(data,'')
    assert not unknown,unknown
    assert data['download_manifest']['verified']
    assert data['hook_integrity']['body_unchanged']
    assert data['independent_smt']['suite_passed']
    assert data['frontend_equivalence']['all_passed']
    cfg=data['interface']['configurations'];bench=data['interface']['benchmark']
    assert all(r['validation']['valid'] for r in cfg.values())
    for name,r in bench.items():
        assert len(r['runs'])>=30 and all(t['validation']['valid'] for t in r['runs'])
    e2e=data['end_to_end']
    assert all(e2e[m]['process']['exit_code']==0 and e2e[m]['condition_exactness']['passed']
               for m in ('natural','fixed_R0','oracle_Rstar'))
    official_expand=any(cfg[n]['strict_over_R0']['result']=='sat' for n in ('A1','A2','A3','A5'))
    a=bench['A1']['wall_seconds']['median'];b=bench['Joint-2-Selector']['wall_seconds']['median']
    summary={'verdict':'NO-GO' if official_expand else 'PARTIAL',
        'scope':'One synthetic deterministic integer loop; oracle is not an integrated joint implementation.',
        'official_strict_expansion':official_expand,
        'joint_is_Rstar':cfg['Joint-2-Selector']['equivalent_Rstar']['result']=='unsat',
        'repair_is_Rstar':cfg['Closure-Repair']['equivalent_Rstar']['result']=='unsat',
        'A4_exact_strict_candidates':data['exact_single_term']['strict_valid_candidates'],
        'display_state_counts':{n:len(r['validation']['display_states']) for n,r in cfg.items()},
        'joint_minus_A1_median_seconds':b-a,'joint_over_A1_median_ratio':b/a,
        'unknown_queries':unknown,'checks_passed':True}
    data.update(schema_version=1,assembled_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),summary=summary)
    (ROOT/'results/results.json').write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n')
    print(json.dumps(summary,indent=2,ensure_ascii=False))

if __name__=='__main__':main()
