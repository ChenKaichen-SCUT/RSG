# 环境、来源与复现说明

正式实验在用户指定服务器 `/root/RSG` 完成。最初本地 WSL2 仅用于下载准备和连接检查；它没有可用的 Docker 隔离能力，容器探测返回 `unshare: operation not permitted`。此限制没有被伪装成官方构建失败。服务器采用官方 README 指定的 Ubuntu 22.04 / Mono / C5 / Z3 技术路线，Python 使用项目内 venv。

## 来源及完整性

| 项目 | 实际来源与版本 |
|---|---|
| 论文 | [Accurate Inference of Termination Conditions](https://feihe.github.io/materials/icse26.pdf)，保存 `sources/icse26.pdf` |
| 官方项目页 | [THU FV ICSE 2026](https://thufv.github.io/research/icse26) |
| DOI | [10.5281/zenodo.16891884](https://doi.org/10.5281/zenodo.16891884)，解析到 v1 记录 16891885 |
| 精确文件 | [CondTerm-Artifact.rar](https://zenodo.org/records/16891885/files/CondTerm-Artifact.rar)，发布 2025-08-18，338,912,600 字节 |
| Artifact MD5 | `a75d0094fedfb274dd48bf31cf730741`，与 Zenodo 元数据一致 |
| Artifact SHA-256 | `bae5800d4e0a6134e9910ca17e540b60070ef54cc8b8b9d71c176c01d41207fb` |
| 包内 Git HEAD | `05e6dfac376141e14bb8420f56c4f2c12eccba3f`，`icse26-submit` |
| 论文 SHA-256 | `a7e1b91620093a58a13e8b86b295bc1608b6f65c41e4c3b8790d2d83fdbb461c`，372,188 字节 |

包内 Git 工作树相对该 HEAD 有大量差异，不能把 HEAD 当成干净源码版本；本实验以官方分发包及逐文件哈希为准。`results/pristine_manifest.json` 保存包内状态和每个文件的 SHA-256。`.git/config` 所指 GitHub 仓库不可访问，相关失败日志保留；未猜测替代仓库。Zenodo API 遇到网关问题时，从真实记录页面的嵌入元数据获取文件名称、URL 和校验值。大文件使用可恢复的分段请求，校验每段 Content-Range，合并后验证整包 MD5、SHA-256 及 RAR CRC。

原始下载日志为 `logs/preparation/initial_downloads.json`、`logs/download_parts/`、`logs/artifact_crc.*` 等。公开副本移除了匿名 HTTP Set-Cookie 响应头；实验标准输出、求解结果和计时数值未改写。原始服务器副本保留。

## 服务器环境与构建选择

正式环境详情见 [environment.json](../results/environment.json) 与 [requirements.lock](../scripts/requirements.lock)。

- Ubuntu 22.04.5 LTS，Linux 5.15.0-173-generic，x86_64，KVM。
- 16 vCPU（AMD General Purpose Processor，8 核 × 2 线程），30 GiB RAM，无 swap。
- Mono / xbuild 6.8.0.105；GCC/G++ 11.4.0；Python 3.10；Z3 4.8.9。
- Z3 Python 包 `z3-solver==4.8.9.0`；ANTLR runtime 4.13.0，与包内生成器一致；SymPy 1.14.0。其余 Python 精确版本均固定。
- 未配置 GPU；未设置 CPU 绑核；未声称隔离云主机邻居负载。没有把 xbuild 的弃用提示解释成失败。

已阅读真实 README、INSTALL 与构建项目文件。顶层官方 README 给出的实际解决方案为 `NewBoogie.sln`；INSTALL 内旧名称不作为构建依据。未找到本次包中的 Dockerfile，故没有编造官方容器镜像。

首次普通 xbuild 编译因三处 `is null` 语法报错；加入 `/p:LangVersion=Experimental` 后原始源码成功编译，不需要改算法或源代码。C5.0 原样 `make clean` / `make all`。GitHub 的 Z3 Ubuntu zip 下载遇到连接重置后，使用同版本官方 PyPI wheel 内的 CLI，复制为 `Binaries/z3.exe`，实测版本为 4.8.9；这是发行包装差异，不能宣称与官方 Ubuntu zip 的二进制逐字节一致。曾下载 Roslyn 编译器备用但没有使用。README 未列出的 SymPy 依赖补装并固定。

未经插桩的官方 `WhileTrue` 示例经自己的 `RSLearner.GenerateRSLBplFile` 预处理后，Boogie 返回 `1 verified, 0 errors`、退出码 0。首次记录外部耗时 0.314524111 秒，见 `logs/official_smoke.*`。所有遇到的网络、依赖和首次编译失败都保留 stdout/stderr/退出码，后续成功不会掩盖此前失败。

## 一键复现

在 Ubuntu 22.04 x86_64 的独立目录执行（系统安装需要 root 或 sudo）：

```bash
git clone https://github.com/ChenKaichen-SCUT/RSG.git
cd RSG
bash scripts/setup.sh
bash scripts/build.sh
bash scripts/run_experiment.sh
```

`setup.sh` 安装系统依赖、创建 venv、固定 Python 版本、下载并校验来源、解压 pristine 并建立工作副本。已安装系统依赖时可用 `RSG_SKIP_APT=1 bash scripts/setup.sh`。镜像网络有需要时可设置 `PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple`。不会下载别的算法版本作为替代。

`build.sh` 恢复 pristine 输入，以 `/t:Rebuild` 重建官方二进制；官方示例和独立 RSLearn 对照通过后，再加入小型实验入口并完整重建。两套二进制分开保存。

`run_experiment.sh` 依次执行全整数 SMT、前端等价性、A1/A2/A3/A5 与强化 A4、Joint/Repair、三次预热与每组 30 次计时、精确边界 A4、三个端到端配置、独立终止条件复核及结构化汇总。任一阶段非零退出会停止；汇总拒绝 UNKNOWN、缺少重复运行或无效输出。全部命令使用参数数组记录，没有通过 shell 拼接动态公式。

脚本在服务器另一个干净目录 `/root/RSG-reproduction-check` 实际核验。该核验复用已安装系统包与校验通过的 Artifact 缓存，重新创建 venv、重新解压与编译，再执行完整脚本；不是第二次从互联网重新下载 339 MB 文件。核验记录单列于 `reproduction-check/`，不替换第一批正式测量。

**重跑会覆盖该目录的 results/logs 同名文件。** 若要保留提交的数据，请使用新 clone 或先复制输出。`run_end_to_end.py` 每次清空其自身 `work/e2e/{natural,fixed_R0,oracle_Rstar}`，确保没有前次 trace/数据共享缓存。

## 数据与测量口径

`results/results.json` 是包含各模块详细记录的总结果；同时保留 `interface.json`、`end_to_end.json`、`exact_single_term.json`、`independent_smt.json` 和每次运行 JSON。`logs/` 包含 argv、cwd、UTC 开始时间、退出码、stdout、stderr、GNU time 和独立 SMT-LIB 查询。A4 的全部 20,000 个边界组合见 `logs/A4_exact_candidates.csv.gz`。

接口重复实验使用随机种子 20261010、每组预热 3 次、30 次随机轮转测量、每次新进程。预热主要消除文件缓存等首次影响，不消除新进程内 Mono JIT。官方计时包围未修改的 RSG 函数，包含首次 JIT 和诊断输出；Python 计时包含候选构造和整个搜索的所有求解，排除写 JSON。独立最终复核不计入算法计时。

求解耗时也有边界差异：官方为 `CheckAndUnsatCore` 往返及 core 提取，Python 为 `Solver.check`。SMT 次数按顶层 check 计数，不把 Z3 内部 core 最小化算作多次外部查询。内存是每 5 ms 采样进程树 RSS 之和，可能漏过短峰值或重复计入共享页；同时保存 GNU time 的单进程最大 RSS。不得将两种内存指标混为一谈。

端到端三配置各一次探索运行，使用原配置的数据共享/启发式，仅替换临时路径，随机种子 888。报告另列外部进程时间与工具自己报告的分析时间。官方 RSLearn 的两位小数 prover 时间不含 RSG，不能用其零值宣称 oracle/注入无求解成本。没有跨配置可比的端到端完整 solver 总时间，报告明确保留此限制。

## 仓库和服务器保留内容

- `original/CondTerm/`：官方文本源码与示例快照，保留原有版权声明。为避免重复上传发行二进制、对象文件和历史 `.git`，公开源码快照不代替完整 RAR；文件清单另列 `results/published_source_manifest.json`。
- `sources/`：元数据、论文及官方项目页。339 MB 原始 RAR、分段缓存、venv、编译产物留在服务器，按上述 URL 和校验和可恢复；不纳入普通 Git 历史。
- `patches/rsg_experiment.patch`：三个修改文件和一个新增文件的完整逻辑差异；仅规范化 BOM/换行以便审阅。
- `experiments/`、`scripts/`：全部实验实现及可复现入口。
- `logs/`、`results/`、`reports/`：首批正式结果、原始诊断和报告。
- `reproduction-check/`：独立目录的一键重跑输出与核验摘要。

服务器工作区保留完整 pristine Artifact、工作源码、两套可执行文件、正式输出和重跑目录。公开提交不含 SSH 密码、GitHub 凭据或 SSH 私钥。
