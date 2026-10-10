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

## 有条件的真实端到端比较

`run_all.sh` 在核心比较完成后检查自然收益；存在经过验证的闭包/联合收益时，按 `config/e2e_selection.json` 的冻结程序名单运行真实集成：

```bash
.venv/bin/python stage2/scripts/build_integration.py
.venv/bin/python stage2/scripts/run_e2e.py --ids AlternDivWidening Ex06 Fibonacci --workers 8
.venv/bin/python stage2/scripts/validate_online.py
.venv/bin/python stage2/scripts/analyze_e2e.py
.venv/bin/python stage2/scripts/prove_simple_conditions.py
```

每个程序/配置 3 次预热、20 次正式测量，共 207 个完整运行。8 个独立工作目录/PID 命名空间并行执行配对块；同一配对块的三种方法依预先随机顺序串行，所有预热块结束后才开始测量。正式测量期间停止其他实验批次。计时属于这一共享主机调度条件，不宣称独占主机微基准加速。

集成配置为官方方法、简单闭包、自动双项搜索。闭包以通用语法检查判断每个整数变量是否在 guard 每个分支中有直接上下界：有则调用仍须 SMT 证明枚举完备的有限闭包，否则调用冻结的符号闭包；不手工指定目标集合。序列化最多另用 2 秒删除已证明冗余的 DNF 项，转换前后验证等价。所有集成候选最终必须严格包含官方结果且完整 VC 验证通过，否则回退到官方结果。空种子直接回退。

除了 Python 选中的候选，`validate_online.py` 还验证 C# 实际返回的 AST 与 Python 结果等价并满足完整 VC。端到端时间计入解释器启动、所有搜索/转换、独立检查与前端成本。SMT 成本表是 RSG 部分，未插桩终止侧全部内部 SMT 查询，不把缺少的总量写成 0。`Unknown`、超时与失败的运行仍保留在每组成本及成功率分母中。
