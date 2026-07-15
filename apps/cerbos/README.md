# Cerbos

## 产品介绍

Cerbos 是一个开源的策略决策点（PDP），用于把应用中的授权规则集中定义为 YAML 策略，并通过 HTTP 或 gRPC API 返回访问决策。

## 主要功能

- 使用资源策略、派生角色和主体策略表达 RBAC/ABAC 规则
- 提供 HTTP 与 gRPC 授权决策 API
- 监听策略目录变更并自动重新加载磁盘策略
- 提供内置 API 浏览器、健康检查与策略编译工具

## 访问说明

- HTTP API 和内置 API 浏览器默认使用 `3592` 端口。
- gRPC API 默认使用 `3593` 端口。
- Cerbos 不是用户登录系统，也不提供业务管理后台；业务应用需要通过 SDK、HTTP 或 gRPC 调用授权接口。
- 授权接口不应直接暴露到不受信任的公网。建议通过防火墙、内网或反向代理限制访问范围。

## 策略与安全

- 本应用使用 Cerbos 官方镜像的默认磁盘存储配置，把安装表单选择目录下的 `policies` 子目录挂载到容器 `/policies`。
- 初始策略目录为空时服务可以正常启动，但没有匹配策略的请求会被拒绝。请按官方格式为每个策略创建独立的 YAML 或 JSON 文件。
- 匿名遥测通过 `CERBOS_NO_TELEMETRY=1` 默认关闭。
- 默认配置未启用 Cerbos Admin API，也不联动 1Panel 数据库、Redis 或网站 Runtime。
- 如需 Git、数据库、Cerbos Hub、审计日志或 Admin API 存储驱动，应在独立测试后自定义配置，不应直接复用本包的默认磁盘模式结论。

## 升级说明

- 升级前备份完整数据目录，尤其是 `policies` 子目录。
- 固定版与 `latest` 使用相同的策略挂载路径，可通过 1Panel 执行跨版本升级。
- 发布前应先使用 `cerbos compile` 或测试套件检查策略，并阅读目标版本的升级说明；策略语义变化需要人工审查。

## Introduction

Cerbos is an open-source policy decision point for application authorization. This package runs the official image as one service, exposes the HTTP and gRPC APIs, and persists disk-backed policies under the selected data directory.

## Features

- YAML/JSON policies for RBAC and ABAC authorization decisions
- HTTP and gRPC decision APIs
- Automatic reload of disk-backed policy changes
- Official binary health check and telemetry disabled by default

Back up the policy directory before upgrades. Keep the decision APIs on a trusted network, and validate policies against the target Cerbos release before production rollout.

## 参考资料

- 容器安装：<https://docs.cerbos.dev/cerbos/latest/installation/container.html>
- 快速开始：<https://docs.cerbos.dev/cerbos/latest/quickstart.html>
- 配置参考：<https://docs.cerbos.dev/cerbos/latest/configuration/index.html>
- 源码仓库：<https://github.com/cerbos/cerbos>
- 官方镜像：<https://hub.docker.com/r/cerbos/cerbos>
