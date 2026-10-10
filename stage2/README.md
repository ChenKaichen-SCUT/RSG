# 第二阶段：自然 RSG 语料与算法比较

基于第一阶段提交 `769bca6`，独立分支 `stage2/natural-rsg-20261010`。第一阶段代码、结果和提交不覆盖。任务原文见 `instructions.txt`；中文研究报告见 `../reports/stage2_natural_rsg_report.md`。

## 实验定义

- `config/manifest.json`：官方 266 个程序的实际输入、哈希，以及固定的 24/242 开发/留出划分。
- `config/protocol.json`：种子 888、正常 DataSaving、每程序 300 秒、4 个采集工作进程、每方法 20 秒与 256 候选、每条 SMT 查询 2 秒。
- `config/implementation_freeze.json`：调试后冻结的实现哈希；修复过程及其与留出结果的关系见 `development_log.md`。
- `src/Stage2Trace.cs`：原始 AST 和实际官方 VC 采集、AST 原样重放。官方 RSG 方法体保持不变。
- `src/semantics.py`：使用完整官方 VC 的无界整数验证、严格集合包含比较、结构化移除 SMT 无语义标签。
- `src/algorithms.py`：A 官方观测、B 官方重复、C 完整/带预算单项搜索、D 精确有限闭包和受限符号闭包、E 自动双项搜索。没有实现完整 MaxSAT。

20 秒是候选边界处检查的软墙钟预算；单条 SMT 查询最多 2 秒，末次候选及独立最终复核可能使总时间超过 20 秒。B 的原生子进程只获得剩余墙钟预算。所有未知和超时均不能作为有效候选。

## 运行环境与进程隔离

复用第一阶段 Ubuntu 22.04、Mono 6.8、C5、Python venv 和 Z3 4.8.9。需要 Linux 允许 `unshare --pid --fork --mount-proc`（本次服务器 root 实测支持）。官方 CondTerm 自己会使用 `ps -A` 按名称结束 mono/z3/c5，所以**每次运行必须有独立 PID 与 /proc 命名空间**。隔离只限定其清理范围，不修改官方算法。旧的未隔离批次完整留存为 `unisolated_pilot`，不用于正式结论。

## 全量重新执行

在独立 clone 中先按第一阶段 `reports/reproducibility.md` 完成环境与原生构建：

```bash
bash scripts/setup.sh
bash scripts/build.sh
bash scripts/run_experiment.sh
bash stage2/scripts/run_all.sh
```

`run_all.sh` 把当前第二阶段输出移动到 `stage2/work/previous-runs/<UTC>/` 后新跑，原数据不删除；源码和第一阶段输出保持原样。全部运行可能需要较长时间，包含慢程序和 300 秒超时样本。复用已构建的服务器环境可以设置：

```bash
export RSG_BASE_ROOT=/root/RSG
export RSG_PYTHON=/root/RSG/.venv/bin/python
bash stage2/scripts/run_all.sh
```

单独步骤：

```bash
.venv/bin/python stage2/scripts/setup.py
.venv/bin/python stage2/scripts/check_isolation.py
.venv/bin/python stage2/scripts/collect.py --split smoke
.venv/bin/python stage2/scripts/validate_corpus.py
.venv/bin/python stage2/scripts/compare.py
.venv/bin/python stage2/scripts/collect.py --split holdout
.venv/bin/python stage2/scripts/validate_corpus.py
.venv/bin/python stage2/scripts/compare.py --resume
.venv/bin/python stage2/scripts/check_replay_syntax.py
.venv/bin/python stage2/scripts/aggregate.py
```

不要并行启动两个采集脚本，它们使用相同的工作进程目录。框架内部的四个工作进程已经分开；每个程序的 tmp/test/学习数据分开，同程序内的官方数据共享保持正常。

## 离线验证与冻结输入重放

原始日志、每条 SMT 查询及模型、每次进程的参数/退出码/时间/RSS、完整 frozen input、原生 prover 输出和开发失败记录均无损压缩在 `evidence/`，`evidence/manifest.json` 给出分片及解压后逐文件 SHA-256。先解压，再重放：

```bash
python3 stage2/scripts/unpack_evidence.py
.venv/bin/python stage2/scripts/validate_corpus.py
.venv/bin/python stage2/scripts/replay_instance.py primary/Flip/call_001
```

验证冻结输入无需重跑 RSLearn；B 需要先构建原生重放入口。重放会更新当前目录对应的第二阶段验证/比较记录，建议另用一份 clone 保存公开测量。只做验证时不需要运行 CondTerm 前端或下载新语料。

`results/summary.json` 按全体、smoke、holdout 分开统计；`results/hard_cases.json` 给出完整候选与证明引用；`results/corpus_index.json` 给出全部实际 AST。程序是频率统计单位，单次 RSG 调用只用于机制分析。SMT 超时、搜索预算耗尽、有限闭包状态上限、未支持、原生错误及无 RSG 均单列，不能据此声称数学上不存在扩展。
