# OpenObserve

## 产品介绍

OpenObserve 是一个面向日志、指标和链路追踪的开源可观测性平台，提供数据采集、检索、仪表盘、告警和 OpenTelemetry 接入能力。

## 主要功能

- 集中采集和检索日志、指标与链路数据
- 提供 Web 控制台、仪表盘、告警和查询 API
- 支持 JSON 日志 API、OTLP HTTP 与 OTLP gRPC
- 单节点本地模式，数据持久化到安装表单选择的目录

## 访问说明

- Web 控制台、HTTP API 和 OTLP HTTP 共用默认端口 `5080`。
- OTLP gRPC 默认使用端口 `5081`。
- 首次登录使用安装表单中的根用户邮箱与密码。
- 应用端口本身不提供 HTTPS。公开访问时应使用 HTTPS 反向代理并限制直接端口访问。
- `安全 Cookie` 默认为关闭，以兼容直接 HTTP 访问；配置 HTTPS 后建议在应用参数中开启。

## 数据与安全

- 本应用启用 `ZO_LOCAL_MODE=true`，不依赖 1Panel 商店中的数据库或 Redis Runtime。
- OpenObserve 的完整 `/data` 目录持久化到安装表单选择的数据目录。
- 安装脚本会生成满足上游密码策略的随机根密码，并将其保存为数据目录中的 `.openobserve_root_password`。该文件用于防止 1Panel 升级回放安装参数时轮换密码，请与业务数据一起备份并限制访问。
- 匿名遥测默认关闭，可在安装表单中按需开启。
- 当前官方镜像以 root 用户运行。应仅挂载专用数据目录，不要向容器挂载宿主机敏感路径。
- 容器健康检查直接调用官方二进制的 `node status` 命令，不依赖镜像中不存在的 Shell、curl 或 wget。

## 升级说明

- 升级前完整备份数据目录和 `.openobserve_root_password`。
- 固定版与 `latest` 使用相同的数据路径和配置键，可通过 1Panel 执行跨版本升级。
- OpenObserve 可能在启动时迁移元数据或存储结构。生产数据应先在副本环境验证目标版本，并在健康检查通过后恢复写入。
- 容器配置了 60 秒优雅停机窗口，仍应在升级前暂停持续写入以降低数据风险。

## Introduction

OpenObserve is an open-source observability platform for logs, metrics, and traces. This package runs the official image in local single-node mode, persists the complete `/data` directory, and exposes the Web/HTTP/OTLP HTTP endpoint on port `5080` plus OTLP gRPC on port `5081`.

Back up the data directory and `.openobserve_root_password` before upgrades. Public deployments should use an HTTPS reverse proxy and restrict direct access to both service ports.

## Features

- Centralized ingestion and search for logs, metrics, and traces
- Web console, dashboards, alerts, and query APIs
- JSON log ingestion plus OTLP over HTTP and gRPC
- Persistent local single-node deployment with replay-safe root credentials

## 参考资料

- 快速开始：<https://openobserve.ai/docs/quickstart/>
- OTLP 日志接入：<https://openobserve.ai/docs/ingestion/logs/otlp/>
- 源码仓库：<https://github.com/openobserve/openobserve>
- 官方镜像：<https://hub.docker.com/r/openobserve/openobserve>
