# CondTerm RSG 源码审计

审计对象是 Zenodo v1 / record 16891885 的实际文件。下列行号均指 pristine 源码，非插桩后的文件。`S` 表示 `original/CondTerm/CondTerm/ice/popl16_artifact/Boogie/Source`。完整包校验信息见 [reproducibility.md](reproducibility.md)，实验判断见 [experiment_report.md](experiment_report.md)。

## 真实入口和数据流

```text
experiment/scripts/CondTerm.py（整体循环，第 752 行）
  → src/IceTerm.py:getTerminationCondition（1195）
  → src/RSLearner/RSLearner.py:GenerateRSLBplFile / ExecuteRSL
  → mono Boogie.exe /RSInfer /RSGeneralize
  → ExecutionEngine.CheckRecurrentSet / RunHoudini
  → MLHoudini 构造：C5Domain、setupC5、官方 VC 生成
  → ComputeSummaries（5150）→ LearnInv（1251）
  → C5Domain.getModelExpr（1596）
  → modifiedGeneralizeRS_2(modelExpr)（1603）
  → [INFO] Generalized RS
  → RSLearner 解析 → IceTerm.analyzeRS → 更新终止条件
```

| 审计点 | 文件、函数与 pristine 行号 | 实际行为 |
|---|---|---|
| 学习树转 DNF | `S/Houdini/MLHoudini.cs`，`C5TreeNode.constructBoogieExpr` 61、67；`C5Domain.constructModel` 7327 | 返回 `List<List<Expr>>`，内层合取、外层析取；`ExtendsExpr.disjunction` 构造 Boogie 表达式 |
| RS 对象 | 同文件 `C5Domain` 7257；构造 7263，`getModelExpr` 7281，`getModelVars` 7286 | `model` 保存布尔 AST，形式参数提供变量顺序；并非有限状态集合 |
| 实际 RSG 入口 | 同文件 `LearnInv` 1593–1604；`modifiedGeneralizeRS_2` 1617–2188 | 学习验证成功，且启用 `/RSGeneralize` 后调用 |
| 单遍遍历 | 同文件 1629–1649、1967–1968 | `getTerms(...,"||")` 后对原始项列表 `foreach`；更新 `newDisjuncts` 的相应项 |
| 谓词删除 | 同文件 1657–1779 | 为当前项原子谓词建立布尔假设，构造含其他项的完整候选、检查 VC，使用 core 重建当前项 |
| 常量与 digging | 同文件 1786–1968；`unifyPredicate` 2935，`generateIntervals` 3002，`newSimplifyGenIntervals` 3037 | 谓词统一为 `a <= c`，对多个排除区间同时建立假设，通过 core 选择，再重建边界 |
| RSG 距离 | 同文件 623–632 | `{0,1,2,4,6,8,10,20,50}`，与论文实验设置一致 |
| 属性表 | 同文件 `setupC5` 1017；基本属性 1053 起，混合属性 1201–1228 | 两变量默认学习属性为 `p,x,p+x,p-x`；正负方向由比较和规范化体现 |
| SMT/core | `S/Provers/SMTLib/ProverInterface.cs`，`CheckAndUnsatCore` 1281，`UnsatCore` 1308，`MinimizeUnsatCore` 1331 | 发送 Z3 4.8.9 支持的 `(check-sat assumptions...)`；只有 Valid/UNSAT 才取 core；设置 `smt.core.minimize true` |
| RS 验证模型 | `S/Core/Absy.cs:CheckRecurrentSet` 229；`S/Core/AbsyCmd.cs:checkAndInstrumentRecurrentSet` 529，关键插桩 793–800 | 循环头假设 R，验证 guard，执行循环体，再断言下一状态仍满足 R |
| 调用验证管线 | `S/ExecutionEngine/ExecutionEngine.cs` 786、906 | 构造 RS 验证程序后进入 Houdini |

关键源码：[MLHoudini.cs](../original/CondTerm/CondTerm/ice/popl16_artifact/Boogie/Source/Houdini/MLHoudini.cs#L1617)、[SMT 接口](../original/CondTerm/CondTerm/ice/popl16_artifact/Boogie/Source/Provers/SMTLib/ProverInterface.cs#L1281)、[循环插桩](../original/CondTerm/CondTerm/ice/popl16_artifact/Boogie/Source/Core/AbsyCmd.cs#L793)。同文件里的 `modifiedGeneralizeRS`、`newGeneralizeRS` 及大段注释代码不是本次活跃入口。

## 与论文 Section 5 / Algorithm 2 的对应

单遍逐项、每项先删除谓词再泛化常量、更新整个 R，均与论文框架对应。每次 VC 使用完整的当前 R，包含其他析取项，且在各状态的函数调用处进行参数替换（1673 起、1837 起）。因此不能把失败解释为“官方只孤立检查当前项”。`newDisjuncts` 包含此前项的更新，但遍历不会回访此前项，也没有内部语义不动点循环。

digging 并非每次只移动一个边界：一次 SMT/core 查询处理当前项多个谓词的多个区间，可以同时去掉若干区间假设。本实验原样保留这些查询与 core 最小化选项。core 的最小化也不等于全局最少谓词、最大状态覆盖的优化保证。

实现还存在需明确区分的细节：

- 最远的无界尾区间的排除选择设为硬约束（1827–1832），常量步骤保留有限放宽边界；谓词删除是另一步骤。
- 活跃路径调用 `newSimplifyGenIntervals`，从保留区间提取最小常量，返回单个 `a <= c`，没有输出任意带孔区间的完整 DNF。论文描述的是保留区间否定式的合取；代码的最终表示更受限。这里不对这种重建在其他程序上的一般正确性作额外断言，本次输出全部独立验证。
- `getTerms` 只拆解已有 OR/AND；活跃 RSG 没有合并两个析取项、重新学习属性或创造 `p+x`、`p-x`。属性选择发生在 RSLearn/C5 阶段。冻结输入表达式后，只保留默认属性表不会替换已有原子谓词。
- 谓词阶段拿不到 core 时保留旧项；区间阶段的异常/core-null 分支回退到硬区间（1908–1920）。本次所有官方接口运行均正常返回四个 UNSAT 和四个 core，未触发该分支。未将 UNKNOWN 当作成功。

## 实验钩子及完整差异

[实验入口](../experiments/RSGExperiment.cs) 在 `MLHoudini` 官方构造函数完成后，通过 `ComputeSummaries` 开头的 opt-in 分支直接处理冻结 AST。此时解析、循环插桩、官方 VC、prover、`b1(p,x)` 的模型变量均已建立；跳过的是 `LearnInv`，不是官方 RSG。日志明确打印入口名、输入 SMT、属性表、输出 SMT 与计时。

更改只有三处官方文件及一个新增文件，见 [完整逻辑补丁](../patches/rsg_experiment.patch)：

1. `MLHoudini` 改为 partial，增加 opt-in 分支以及正常学习种子的诊断输出。
2. `Houdini.csproj` 增加 `RSGExperiment.cs`。
3. `ProverInterface.CheckAndUnsatCore` 增加 Stopwatch 的 try/finally 计时；不改求解选项或返回值。
4. 新增实验 partial class，构造种子并调用 `modifiedGeneralizeRS_2`。

`add_experiment_hook.py` 始终读取 pristine 源码重建上述修改，并检查整个活跃 RSG 方法原文仍然存在。方法按 UTF-8、去 BOM、CRLF→LF 规范化后的 SHA-256：

```text
8058a728d10ca4bbe3f681ed33ad25a9d8dfeec2a81259676c0a33f8a8f0e431
```

`hook_integrity.json` 记录 `body_unchanged: true`；补丁显示所有 RSG 辅助函数也未改动。差异为便于阅读统一换行，原始文件字节另有清单校验。`build.sh` 先恢复并编译 pristine 官方版本、运行官方示例，保存 `work/pristine-bin`，随后再编译 `work/instrumented-bin`。自然端到端配置使用 pristine 二进制，不含实验入口或计时包装。

接口配置：A1/A2/A3 的 learner 表过滤为 `p,x`，冻结谓词为 `p,-p,x,-x` 的四个有符号不等式；A5 保留完整默认表 `p,x,p+x,p-x`，但输入 AST 完全相同。A3 每次用新进程/官方 VC 上下文处理前次完整输出，避免实验入口重复声明产生名称冲突；本例第一遍已达语义不动点。

端到端注入仅替换第一次 RSLearn 调用。oracle 分支直接返回经独立验证的 R*，明确打印 oracle 标志，不计作联合算法结果。注入日志中的 RSLearn prover/C5 次数为零，只表示学习被绕过；RSG 的四次求解及耗时另行统计。
