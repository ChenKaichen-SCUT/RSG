#!/usr/bin/env python3
"""Render formulas and full summary statistics directly from measured records."""
import json,pathlib
ROOT=pathlib.Path(__file__).resolve().parents[1]

def main():
    data=json.loads((ROOT/'results/interface.json').read_text())
    out=['# 公式与数值附录\n',
         '此文件由 `scripts/make_numeric_appendix.py` 从首批实际 JSON 生成；全部原始运行见 `results/interface.json`，不删除异常值。\n']
    for name,rec in data['benchmark'].items():
        out+=['## '+name+'：30 次统计\n',
              '| 指标 | 中位数 | 最小值 | 最大值 | Q1 | Q3 | Tukey 异常值（全部保留） |\n',
              '|---|---:|---:|---:|---:|---:|---|\n']
        for k,label,factor in [('wall_seconds','算法 ms',1000),('solver_seconds','求解 ms',1000),
                               ('process_wall_seconds','外部进程 ms',1000),('sampled_peak_tree_rss_kib','树 RSS KiB',1),
                               ('smt_calls','SMT 次数',1),('unsat_core_calls','core 次数',1)]:
            s=rec[k];values=[f'{s[t]*factor:.6f}' for t in ('median','min','max','q1','q3')]
            outliers=', '.join(f'{v*factor:.6f}' for v in s['outliers_tukey']) or '无'
            out.append('| '+label+' | '+' | '.join(values)+' | '+outliers+' |\n')
        out.append('\n')
    out.append('## 各配置完整输入与输出\n')
    for name,rec in data['configurations'].items():
        out+=['### '+name+'\n','冻结输入：\n\n```smt2\n'+rec.get('input_formula_smt2',
               '(or (and (= p 0) (= x 0)) (and (= p 1) (= x 4)))')+'\n```\n',
               '实际输出：\n\n```smt2\n'+rec['formula_smt2']+'\n```\n']
        if 'learner_attribute_table' in rec:out.append('实际 learner 属性表：`'+rec['learner_attribute_table']+'`。\n')
        out.append('输出有效性：`'+str(rec['validation']['valid'])+'`；与 R0 的 XOR：`'+
                   rec['equivalent_R0']['result']+'`；与 R* 的 XOR：`'+rec['equivalent_Rstar']['result']+'`。\n\n')
    out.append('## 完整端到端条件与种子\n')
    e2e=json.loads((ROOT/'results/end_to_end.json').read_text())
    for name,rec in e2e.items():
        out+=['### '+name+'\n']
        if rec.get('condition'):
            out+=['实际终止条件（`ne` 为不等于）：\n\n```text\n'+rec['condition']+'\n```\n',
                  '与 `Not(Rstar)` 的 XOR：`'+rec['condition_exactness']['result']+'`。\n\n']
        for r in rec.get('recurrent_sets',[]):
            out+=['阶段 '+str(r.get('iteration','standalone'))+' / '+r['stage']+'：\n\n```text\n'+r['formula']+'\n```\n']
    (ROOT/'reports/numeric_appendix.md').write_text('\n'.join(out))

if __name__=='__main__':main()
