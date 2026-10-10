# CondTerm RSG 协调泛化复现实验

按 [指引.txt](指引.txt)，在专用 Ubuntu 22.04 服务器上下载、构建并运行 ICSE 2026 官方 CondTerm Artifact，审计真实 RSG 入口，测试固定种子的双项协调泛化。**最终判断：PARTIAL。**

- 真实官方 RSG 在固定 unary R0 上，单遍、换序、重复到不动点均不扩大集合；默认属性表也不改变冻结输入结果。
- 20,000 个边界/删除组合及更强的 64 个 unary 投影候选，均找不到单项严格扩展。
- `Joint-2-Selector` 枚举四个完整候选，得到 R*；覆盖状态 2→4，全整数 SMT 证明正确。
- 30 次测量：官方 RSG 中位数 **49.514 ms / 4 次 SMT**，联合搜索 **77.964 ms / 12 次 SMT**；简单闭包修复 **33.152 ms / 5 次 SMT**，同样得到 R*。
- 完整自然流程、首次固定 R0 均 3 轮，oracle R* 为 2 轮；三者最终条件均精确。oracle 时间不是实际联合算法加速证据。

本例表明固定表示下存在协调泛化差别，同时说明该有限实例无需 MaxSAT。独立 RSLearn 不使用数据共享时能够直接学到 R*；不能将本例推广成整个 CondTerm 的系统性缺陷。

| 内容 | 入口 |
|---|---|
| 中文正式报告，逐条回答十个问题 | [experiment_report.md](reports/experiment_report.md) |
| 真实函数、行号、调用链和论文对应 | [source_audit.md](reports/source_audit.md) |
| 来源校验、环境、失败记录和复现步骤 | [reproducibility.md](reports/reproducibility.md) |
| 完整公式、统计范围和异常值 | [numeric_appendix.md](reports/numeric_appendix.md) |
| 全部结构化结果 | [results/results.json](results/results.json) |
| 官方源码快照 / 实验补丁 | [original/CondTerm](original/CondTerm/) / [rsg_experiment.patch](patches/rsg_experiment.patch) |
| 首批命令、stdout、stderr、SMT | [logs](logs/) |
| 独立目录一键重跑 | [reproduction-check](reproduction-check/) |

Ubuntu 22.04 x86_64 复现：

```bash
git clone https://github.com/ChenKaichen-SCUT/RSG.git
cd RSG
bash scripts/setup.sh
bash scripts/build.sh
bash scripts/run_experiment.sh
```

脚本会写入当前目录 results/logs，保留提交数据请使用新的 clone。需 root/sudo 安装系统依赖，Python 安装于 `.venv`。完整官方 RAR 按校验和下载，未将 339 MB 二进制发行包和 venv 提交到 Git。服务器 `/root/RSG` 保留完整 Artifact、原始源码、工作副本、二进制及运行数据。公开源码快照保留原声明，精确来源见报告。
