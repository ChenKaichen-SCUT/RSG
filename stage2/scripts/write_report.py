#!/usr/bin/env python3
"""Render the Chinese report from measured results; never invent missing trials."""
import collections,json,pathlib,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import ROOT,S
read=lambda n:json.loads((S/'results'/n).read_text())
summary=read('summary.json');a=summary['all'];e=read('e2e_analysis.json');runs=read('e2e.json')
online=read('e2e_online_validation.json');evidence=json.loads((S/'evidence/manifest.json').read_text())
assert len(runs)==207 and online['passed']
assert collections.Counter(r['trial']['phase'] for r in runs)=={'warmup':27,'measurement':180}
assert all(r.get('configured_workers')==16 for r in runs if r['trial']['phase']=='measurement')
for p in e['programs'].values():assert all(m['runs']==20 for m in p['methods'].values())
def table(headers,rows):
 return '\n'.join(['| '+' | '.join(headers)+' |','|'+'|'.join(['---']*len(headers))+'|']+['| '+' | '.join(map(str,r))+' |' for r in rows])
def f(x):return f'{x:.3f}'
def dist(d):return f"{d['median']:.3f} [{d['q1']:.3f}, {d['q3']:.3f}]" if d else '未记录'
denom=table(['指标','全部','smoke','holdout'],[
 [label,*[summary[s][key] for s in ('all','smoke','holdout')]] for key,label in [
 ('manifest_programs','官方程序'),('attempted_programs','实际尝试程序'),('programs_triggering_rsg','触发 RSG 程序'),
 ('programs_without_rsg','未触发 RSG 程序'),('rslearn_invocations','RSLearn 入口调用'),('rsg_calls','完整 RSG 输入'),
 ('compared_instances','非空有效、进入比较的输入'),('valid_multiterm_inputs','有效多项 DNF 输入'),
 ('programs_with_multiterm_inputs','具有多项输入的程序'),('empty_seed_inputs','空种子输入'),('official_did_not_expand','A 与种子等价的输入')]])
methods=table(['方法','扩大 R0：输入/程序','严格超过 A：输入/程序','与 A 等价/更小/不可比','算法秒中位数'],[
 [n,f"{m['expanded_seed_instances']}/{len(m['expanded_seed_programs'])}",f"{m['strictly_larger_than_official_instances']}/{len(m['strictly_larger_than_official_programs'])}",
  '/'.join(str(m['versus_official_relations'].get(k,0)) for k in ('equal','A_strictly_larger','incomparable')) if n!='A_official' else '自身',f(m['algorithm_seconds_median'])]
 for n,m in a['methods'].items()])
statuses=table(['方法','全部状态计数','UNKNOWN 查询','最终无效输出'],[
 [n,'；'.join(f'{k}={v}' for k,v in m['statuses'].items()),m['search_unknown_queries'],m['final_invalid_results']] for n,m in a['methods'].items()])
split_methods=table(['方法','smoke 严格超过 A：输入/程序','holdout 严格超过 A：输入/程序'],[
 [n,*[f"{summary[s]['methods'][n]['strictly_larger_than_official_instances']}/{len(summary[s]['methods'][n]['strictly_larger_than_official_programs'])}" for s in ('smoke','holdout')]] for n in a['methods']])
costs=table(['方法','搜索 SMT 次数','另计原生查询','搜索求解器累计秒','算法累计秒','算法秒范围'],[
 [n,m['search_smt_calls_sum'],m.get('additional_native_smt_calls_sum',0),f(m['search_solver_seconds_sum']),f(m['algorithm_seconds_sum']),f"{f(m['algorithm_seconds_min'])}–{f(m['algorithm_seconds_max'])}"] for n,m in a['methods'].items()])
e2e=table(['程序/方法','成功/20','返回状态','总秒中位数 [Q1,Q3]','迭代/RSLearn/终止侧调用中位数','接纳次数/错误'],[
 [p+'/'+n,m['successes'],','.join(f'{k}:{v}' for k,v in m['tool_results'].items()),dist(m['wall_seconds']),
  '/'.join(str(m[k]['median']) for k in ('iterations','rsl_calls','termination_boogie_calls')),f"{m['accepted_extensions']}/{m['integration_errors']}"]
 for p,d in e['programs'].items() for n,m in d['methods'].items()])
paired=table(['程序/方法','成对差中位数（秒）','bootstrap 95% CI'],[
 [p+'/'+n,f(d['median_difference_seconds']),f"[{f(d['bootstrap_95_percent_CI'][0])}, {f(d['bootstrap_95_percent_CI'][1])}]"]
 for p,row in e['programs'].items() for n,d in row['paired_wall_differences'].items()])
ecost=table(['程序/方法','RSG 秒中位数','RSG 求解秒中位数','RSG SMT 次数中位数','进程树峰值 MiB 中位数'],[
 [p+'/'+n,f(m['rsg_seconds']['median']),f(m['rsg_solver_seconds']['median']),m['rsg_smt_calls']['median'],f(m['peak_tree_rss_kib']['median']/1024)]
 for p,d in e['programs'].items() for n,m in d['methods'].items()])
hard=table(['实例（primary/）','DNF 项/原子','分类','重放'],[
 [h['instance'].removeprefix('primary/'),f"{h['dnf_terms']}/{h['atoms']}",', '.join(h['types']),f"`replay_instance.py {h['instance']}`"] for h in a['hard_cases']])
failures=table(['程序','进程状态/工具结果','原始 stderr'],[
 [r['program'],str(r['status'])+'/'+str(r['result']),'`'+r['log']+'`'] for r in a['failures']])
exact=sum(len(d['exact_condition_checks']) for d in e['programs'].values())
exact_pass=sum(x['check']['passed'] for d in e['programs'].values() for x in d['exact_condition_checks'])
eq=[r for r in e['condition_checks'] if 'entry_equivalence' in r]
eq_pass=sum(r['entry_equivalence']['passed'] for r in eq)
report=f'''# 第二阶段：CondTerm 自然 RSG 输入、闭包与自动联合搜索

实验日期：2026-10-10（日志使用 UTC）。基线提交 `769bca6e3b232527135117407ecee9d6be97197f`；独立分支 `stage2/natural-rsg-20261010`。完整定义和源文件哈希见 [protocol](../stage2/config/protocol.json)、[manifest](../stage2/config/manifest.json)，复现入口见 [README](../stage2/README.md)。

## 结论和决策

**NO-GO：本轮证据不支持投入完整增量 SAT/MaxSAT + SMT 泛化器。** 266 个官方程序全部尝试，95 个触发 RSG，203 次输入中 201 次为非空有效输入；其中 73 次多项输入只来自 18 个程序。自动双项方法 E-v1 和事后修复 E-v2 均未找到严格包含官方结果的集合。没有一个程序满足本报告的保守 Type II/III 证据条件；这表示本轮没有证明必要协调，不能解释为协调缺口在数学上不存在。

重复官方 RSG 在 17 个程序的 25 次输入上超过一次官方调用；受限符号闭包在 11 个程序的 14 次输入上超过官方。精确有限闭包在 Ex06 的两次输入上超过官方，且实际集成减少外层迭代。更合理的近期方向是重复泛化、适用时的精确有限闭包、入口相关性筛选和廉价符号闭包；还没有足够证据作出“大量必要协调由符号闭包解决”的 PIVOT 判断。

## 继承、源码审计与观测可信度

第一阶段完整复现脚本的 8 个阶段在独立目录重新执行，全部退出 0，见 [stage1_recheck.json](../stage2/results/stage1_recheck.json)。原始第一阶段文件没有改动；该重跑的原始证据单独保存在 `stage2/evidence/stage1-recheck.tar.gz`。环境仍为 Ubuntu 22.04.5、Python 3.10.12、Mono 6.8、Z3 4.8.9；16 个逻辑 CPU、约 30 GiB 内存，详见 [environment.json](../stage2/results/environment.json)。没有 GPU 计算需求。

再次按源码定位 `MLHoudini.LearnInv` 中 `modelExpr = modifiedGeneralizeRS_2(modelExpr)`。仅把调用包装为 `S2Run`；方法体 SHA-256 保持 `8058a728d10ca4bbe3f681ed33ad25a9d8dfeec2a81259676c0a33f8a8f0e431`。`Stage2Trace.cs` 保存完整 Expr AST、原始 DNF 各原子/属性、变量类型、距离候选、输入/输出 Boogie 文本、求解器与 UNSAT core 次数/耗时；RSLearner 包装保存准确 input.bpl、命令、seed、DataSharing、outer_iteration 和入口序号。序号按 RSLearn 入口计数，所以没有 RSG 的入口会留下 call 编号空档，不应把空档误当丢失。

真实 guard/转移/路径语义来自官方 `impl2VC` 与当前 prover 断言栈：候选由 `Stage2Candidate` 函数参数化，经真实 control binding 保存。导出事务只写 prover 日志，`Process.Send` 被抑制，额外活求解器查询为 0。验证器结构化恢复 push/pop 活跃栈，删除 `:lblpos/:lblneg` 等无语义注释；精确消去定义性的零元控制量，并额外验证消去前后存在量化等价。候选检查包含 `R0 => R'` 与完整官方 guard/closure VC；不根据程序名猜测简化转移。集合关系用两个反例查询判定，SAT 必须有模型，UNKNOWN 一律不当证明。

原阶段 witness 的自然混合 DNF 与 R0 等价，官方输出仍为 R0；Rstar 通过完整 VC，两个单侧扩展、整个 guard 和 True 均被负控制拒绝。未插桩/插桩版本均 3 次外层迭代、2 次 RSLearn，最终条件等价且为精确条件。另对 Flip、Singapore_v2 和 ChenFlur…Ex2.12 做自然程序对照，结果、迭代数、RSLearn 数一致，最终条件 SMT 等价。全部 B 重放的输入 AST 节点/顺序核对通过（仅忽略父节点类型元数据）。证据见 [tracing_control](../stage2/results/tracing_control.json)、[natural_controls](../stage2/results/natural_tracing_controls.json)、[replay_integrity](../stage2/results/replay_syntax_integrity.json)。这些控制覆盖关键行为，不能证明任意程序上的微小观测开销为零。

官方 `CondTerm.py` 本身会按 `ps -A` 的名称杀死 mono/z3/c5。最初并行批次发生进程互杀后，整个批次降级为 `unisolated_pilot`，保留但排除正式结论；正式 266 个全部以 `unshare --pid --fork --mount-proc` 重跑。每个运行有独立 PID、/proc、tmp/test/学习数据目录，同程序内 DataSaving 保持原样。详见 [isolation](../stage2/results/pid_isolation.json) 和 [开发记录](../stage2/development_log.md)。

## 语料分母和数据划分

Artifact 实际包含 266 个程序（96 个 nonterm、170 个 term），输入文件完整。固定种子 888，正常数据共享，每程序 300 秒上限；24 个 smoke 与 242 个 holdout 在运行前冻结，采集与核心离线比较使用 4 个工作进程。

{denom}

全部进程中 265 正常退出，1 个失败；工具结果为 213 Cond-Termination、49 Unknown、3 Timeout、1 个无结果。正常退出并不等于求解成功。95/266（35.71%）程序触发 RSG；94 个程序提供非空有效输入，18/266（6.77%）程序有多项输入。128 个有效输入仅含一项，其余 73 个含 2–16 项。完整入口审计得到 280 个 RSLearn 目录、203 个 RSG 种子公告与完整 trace，另外 77 个入口没有 RSG 种子公告；没有公告存在而 trace 丢失的正式输入。

两个空种子分别是 `ChenFlurMukhopadhyay-SAS2012-Ex4.01_false-no-overflow/call_000` 和 `NonTermination4_false-termination/call_001`，不进入非空能力比较。机器字段历史名称为 `validation_failed`，实际原因是非空性查询 UNSAT；非空输入上下文提取/验证失败数为 0。空种子仍计入程序和 RSG 总分母。

独立程序是频率单位；同程序不同 call 只用于机制分析，不能把 201 次输入当成 201 个独立程序。程序名称相近的系列也不应宣称代表完全独立机制。主实验仅 seed 888，未声称跨随机种子普适。

虽然保留 smoke/holdout 分表，基础设施修复前已看过部分 holdout 输出；E-v2 更是在初步留出结果可见后新增。因此不把最终数据称为完全未见、没有调试影响的确认性留出评价。

## 候选语言、基线和能力比较

A 是真实自然调用中的原始官方 RSG。B 从同一冻结 R0 原样 AST 启动原生官方入口，最多调用 5 次，按 SMT 等价停止。C 一次修改一个原 DNF 项，保留混合属性表达式，允许删除原子或按 0/1/2/4/6/8/10/20/50 放宽已有界；一个项内多个原子可以组合修改，其他项固定。C 按编辑宽度、属性/距离交错枚举，找到第一个合法严格扩展就停止；仅候选语言完整穷尽时报告 `complete_no_extension`。

D_finite 枚举 guard 的完整整数状态，必须得到穷尽 UNSAT 和 guard 等价证书；上限 128，未能证明完备只报告状态/时间限制。然后逐次删除不能保持闭包的点，最终验证完整 VC。D_symbolic 保留原种子，加最多 64 个原混合谓词项的放宽区域，允许重叠；依据完整 VC 的前/后候选极性检查并删除不安全区域，最终检查整合集合。它没有区域细化，不声称全局最大闭集；`symbolic_fixpoint` 只针对保留区域。

E 自动生成所有项对及每项至多 16 个变体，用完整候选公式检查后继覆盖，后继可由任何选定项覆盖。E-v1 先按项对顺序遍历，首对 16×16 会耗完 256 候选；保留这一冻结结果。E-v2 (`E_balanced`) 使用相同池与预算、按项对轮转，明确作为事后覆盖修复单列。两者都是遇到第一个合法扩展就停止，未优化全局覆盖，也未证明其他候选不存在。没有触发 F 的有证据条件，因此未扩展 3/4 项搜索，也未制造额外合成压力样本来维持预设结论。

所有方法每输入软墙钟 20 秒、256 候选，单条 SMT 查询 2 秒；B 子进程仅获得剩余墙钟。软预算在候选边界检查，最后一次查询和最终验证可能越界。每个返回值均独立复核；不能证实时退回原种子。原种子回退可能小于 A，离线表不会悄悄换成 A。

{methods}

“扩大 R0”与“超过 A”不同。A 扩大 60 次、停滞 141 次；C 扩大 61 次，但只有 TwoFloatInterv 的 1 次超过 A。E-v2 扩大 21 次，全部没有严格超过 A，另有 1 次与 A 不可比较。C/E 的首个合法扩展未必包含 A，因此不能凭这个表宣称它们的完整候选语言能力较弱。B 在 Factorial 的 1 次输入上小于 A、6 次（Factorial 五次及 Fibonacci 一次）与 A 不可比；原样输入 AST 不保证全新原生 solver 会选择与自然历史会话相同的 UNSAT core/泛化路径。此处如实按集合关系记录，未把 B 当成必然从观测 A 单调扩大的链，也未确定差异的唯一来源。

{split_methods}

{statuses}

E 的 128 个 `complete_no_extension` 都是单项输入的空项对语言，不能当作多项协调不存在的证明。C 有 78 个固定语言穷尽证明，另外 62 个未扩展结果只是预算限制。D_finite 的 195 个状态/时间限制不能解释为证明 guard 无限；另有 3 个闭包阶段预算限制。D_symbolic 的 20 个 `budget_or_unknown` 本次实际未出现 UNKNOWN 查询，属于预算未完成。全部方法 UNKNOWN 查询与最终无效返回均为 0；状态分类不能被压成笼统“失败”。

{costs}

A 是 C# 内部函数计时，B 包含多次原生进程启动，C/D/E 为 Python 算法计时（最终复核另记），边界不同；不能用这些中位数宣称实现级加速比。B 的搜索查询列是 Python 侧检查，原生查询另列，原生耗时保存在各次 trace 中，不能把 Python 求解秒当 B 总求解秒。SMT 搜索量可诊断预算/语言成本，最终系统性能以完整接入测量为准。单项输入让 E 立即返回，其总体中位数低不代表多项联合搜索便宜。

## 困难实例与依赖结构

完整可重放清单共 {len(a['hard_cases'])} 个输入，见 [hard_cases.json](../stage2/results/hard_cases.json)，每项保留自然 AST、官方输出、各方法候选、独立验证、包含关系、证明文件引用和重放命令。所有候选与 SMT 反例均在归档中。

1. **Type I：TwoFloatInterv/call_001。** R0 是 `11<t && t<=19`，A 的 `-t<=-12 && t<=19` 在整数上等价。C 得到 `11<t && t<=29`，经完整 VC 验证严格扩大。这是单个 DNF 项的启发式遗漏，没有必要双项协调证据。
2. **Ex06/call_000。** R0 为 `-6<t && t<=0`，A 为 `-5<=t<=1`。D_finite 证明 guard 恰有 11 个状态，返回完整 `-5<=t<=5`；B 也到达这个集合（5 次预算耗尽，不能据状态名伪称已经做过下一轮不动点检查）。D_symbolic 的有限区域池只到较小范围。问题来自有限状态可精确处理及区域模板，种子只有一项，不是多项必要协调。
3. **AlternDivWidening/call_000。** 自然两项含 `t+w` 和 `t-w` 混合属性。符号闭包与重复官方均可超过 A，C 已找到单项扩展，所以不能宣称单项不可能。主程序实际入口固定 `w=5`，很多新增其他 w 状态不改善入口终止条件；端到端迭代数是否改变见下表。
4. **Fibonacci/call_000。** 四变量状态、单项种子 `n<=-1 && j>0 && _i>=0`。D_symbolic 同时保留若干互补放宽区域，超过 A；这说明区域并集有用，但不是已经证明必须修改两个原始 DNF 项。完整系统仍 Unknown 的成本必须保留。
5. **2Nested_false-termination/call_008。** 九个自然项、混合属性；C 完整单项语言有 1,322,000,991 个候选，256 预算显然不完备。E-v2 把访问项对数从 1 提高到 36/36，仍未穷尽每对候选，未找到超过 A 的结果。瓶颈主要是组合空间与候选覆盖；不能据此推导 MaxSAT 必有收益。

11 个代表程序的依赖审计在 [dependency_observations.json](../stage2/results/dependency_observations.json)。它记录 VC 反例模型中各负候选应用处的区域覆盖者，数量为 0–8，包含多个替代区域。这些是模型下的诊断值，并未证明每个出现处都在激活路径上，也不会把一个可选覆盖者当成强制依赖。最小必要协调宽度均未建立。因此已证 Type II、Type III 程序数均为 0，Type IV 的联合优势前提也没有成立。闭包额外开销/入口无收益单独讨论，避免冒充联合方法的 Type IV。

{hard}

## 实际 CondTerm 接入与成对测量

选择已经验证闭包超过 A 的 AlternDivWidening、Ex06、Fibonacci，覆盖无限 guard、完整有限 guard 和慢 Unknown 案例。官方、closure、joint 三配置共享程序、seed、学习器、终止证明器、DataSaving 和停止规则；每次在线取当前真实种子/VC 执行算法。closure 以通用 guard 语法有界性选择 D_finite 或 D_symbolic，有限性仍需 SMT 完备证书。joint 使用 E-v2。只有候选有效且严格包含本次官方输出才接纳，否则返回官方结果；没有按程序名注入 Rstar。

每程序/配置 3 次预热、20 次正式测量，共 {len(runs)} 次。配对块为同一程序/round 的三配置，按预先随机 seed 20261010 排序，在一个工作目录串行执行；块之间并行。用户在正式测量前要求尽量用满配置，因此保留 24 次已完成的 8-worker 预热，另存中断预热目录后补跑余下 3 次，将全部正式测量上限统一为 **16 个工作进程**。不绑定 CPU，尾部可用任务不足时实际活跃数降低；正式测量期间没有其他实验批次。报告反映该共享主机负载，不能解释为独占 CPU 加速。

{e2e}

成对差为“方法总秒 − 同 round 官方总秒”，正数代表更慢；各 20 对，按配对差重采样 10,000 次、固定统计 seed 20261010，报告中位数差的百分位 bootstrap 区间。共享主机上块间资源相关、程序仅三个，因此置信区间是该调度下的描述性不确定度，不是跨程序总体显著性保证。Unknown/Timeout/失败的全部墙钟纳入，不能据被截尾/Unknown 程序声称 time-to-solution 加速。

{paired}

{ecost}

进程树 RSS 每 10 ms 采样，峰值是采样下界。表中 SMT 成本仅 RSG 原生与 Python 查询；没有完整插桩终止侧内部 SMT 总量，不能把缺失总量记成 0。总墙钟包括解释器启动、搜索、公式转换、trace、终止侧和所有官方阶段。Python 候选与 C# **实际返回 AST** 分别检查：{len(online['checks'])} 个在线返回全部通过完整 VC 及边界等价验证。

最终条件在真实入口赋值/假设下比较，而不是把内部状态变量无条件视为自由输入。AlternDivWidening 入口 w=5 的精确终止条件为 `-5<=t<=5`；Ex06 为 `t<-5 || t>5`。两者独立归纳/立即退出证明见 [exact_e2e_conditions.json](../stage2/results/exact_e2e_conditions.json)；正式输出精确性检查 {exact_pass}/{exact} 通过，方法与官方入口条件等价检查 {eq_pass}/{len(eq)} 通过。Fibonacci 的 Unknown 不当作已经得到精确终止条件。

## 失败、有效性边界与原始记录

官方 `PodelskiRybalchenko-VMCAI2004-Ex1_false-no-overflow-version` 因 DataSaving 尝试将 `?` 转为整数抛出 ValueError，保留失败，没有偷偷修正官方流程或移除分母。以下列出全部非成功/Unknown/Timeout 程序；过程退出 0 的 Timeout 是工具自身返回值。

{failures}

开发阶段出现过空 Expr.Type、旧 SMT 标签解析、原生重放 AST 负数字面量、并行全局清理、试跑目录标签、否定比较前端兼容、单元素 Or 跨语言编码等问题。全部失败/旧批次原始数据保留并明确命名，正式数据只使用修复后的隔离实现。完整经过见 [development_log.md](../stage2/development_log.md)；这些失败不能混入正式效果统计，也不能从证据包删除。

限制包括：一个主种子；少量自然多项程序；候选语言有限且大部分搜索不完备；符号区域不细化；原生重放与自然 solver 历史可能不同；E-v2 事后修复；部分 holdout 曾被查看；只选三个有收益信号的端到端案例；并发负载可能影响墙钟预算与区间。所有有效结果仍须完整无界整数 SMT 证明，有限采样从未替代这个检查。

## 三个研究问题的直接回答

**RQ1：上一阶段的必要联合能力差异是否在官方自然输入中复现？** 本轮没有建立相同强度的证据。观察到官方启发式遗漏和更大合法集合，但 0 个程序被证明只有协调修改才有效。多项自然输入仅来自 18 个程序，预算未穷尽处保持未决，不能宣布差异不存在。

**RQ2：简单符号闭包是否足够，困难来自哪里？** 它在 11 个程序上严格超过一次官方调用，适用的精确有限闭包在 Ex06 更强；重复官方也解决大量差距。符号闭包尚不足以声称处理所有输入：64 个区域、256 次检查限制和粗表示会限制结果，20 次搜索没有完成闭包不动点。本次未观察到 UNKNOWN 求解主导；有直接证据的瓶颈首先是候选/区域表达和枚举数量，尚没有证明最小必要协调宽度。

**RQ3：是否支持开发新增量 SAT/MaxSAT + SMT？** 尚不支持。自动双项搜索没有严格超过 A 的自然结果，也没有在强闭包面前建立优势；优先做入口相关的廉价重复泛化、精确有限闭包及增量区域闭包/反例复用。只有将来在不同真实程序上得到单项完备失败、简单闭包受限且联合成功的证据，才重新评估 MaxSAT。

## 复现和证据

完整命令见 [stage2/README.md](../stage2/README.md)。源码/方法冻结和后续修复由 Git 历史、config 中的哈希及开发记录对应。原始语料、查询、模型、日志、失败记录和逐输入结果共 {evidence['raw_file_count']:,} 个文件、{evidence['raw_bytes']:,} 字节，压缩为 {len(evidence['parts'])} 个文件，总计 {sum(p['bytes'] for p in evidence['parts']):,} 字节。分片与解压后文件逐一 SHA-256 见 [manifest](../stage2/evidence/manifest.json)，公开的 [corpus_index](../stage2/results/corpus_index.json) 包含完整输入/输出 AST 与元数据。

```bash
# 全量新实验：先在独立 clone 完成第一阶段环境和构建
bash scripts/setup.sh
bash scripts/build.sh
bash scripts/run_experiment.sh
bash stage2/scripts/run_all.sh

# 精确取回本次原始证据；冻结重放不重新运行 RSLearn
python3 stage2/scripts/unpack_evidence.py
.venv/bin/python stage2/scripts/replay_instance.py primary/TwoFloatInterv/call_001

# 正式集成（需要 fresh 目录；已有完成记录可用 --resume）
.venv/bin/python stage2/scripts/run_e2e.py --ids AlternDivWidening Ex06 Fibonacci --workers 16
```

服务器本次实验目录为 `/root/RSG/stage2-repo/stage2`，原阶段工程仍在 `/root/RSG`。新的实验目录不要复用未完成 trial 的学习缓存；已完成的记录也不覆盖。公开结果与第一次完整试跑的 wall time 不要求逐位相同，正确性证明、候选与所有失败状态可以按冻结输入复核。
'''
target=ROOT/'reports/stage2_natural_rsg_report.md';target.parent.mkdir(exist_ok=True);target.write_text(report)
print('Wrote',target)
