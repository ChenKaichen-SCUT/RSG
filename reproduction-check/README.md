# 独立目录复现核验

在同一服务器的 `/root/RSG-reproduction-check`，使用已安装系统依赖和已校验 Artifact 缓存，重新创建 venv、解压原始源码、执行 `setup.sh`、`build.sh`、`run_experiment.sh`。全部阶段退出码为 0。

这是脚本可复现性核验，不是新增 benchmark，也没有与首批 30 次测量混合。`results/` 和 `logs/` 均是该核验目录自身的输出；其中相对路径按此目录解析。入口记录见 `reproduction.log`，最终判断与首批一致。
