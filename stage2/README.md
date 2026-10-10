# 第二阶段：自然 RSG 输入采集与协调泛化比较

基于提交 `769bca6`，独立分支 `stage2/natural-rsg-20261010`。原第一阶段文件及结果保持不变。

- 任务原文：`instructions.txt`
- 预先固定的主实验预算：`config/protocol.json`
- 程序分母及开发/留出划分将在运行官方语料前写入 `config/manifest.json`。
- 服务器工作区：`/root/RSG/stage2-repo`，临时构建和第一阶段复核放在 `stage2/work/`。
- 最终报告：`../reports/stage2_natural_rsg_report.md`。

先复核第一阶段，再审计真实调用与无额外求解的轨迹采集；开发集通过后才采集官方完整分母。比较始终使用相同冻结语法和实际 VC。不会把超时或预算内未找到扩展当成能力不可能。
