# Codex2API

## 产品介绍

Codex2API 是一个 Codex 账号池网关，对外提供 OpenAI 与 Anthropic 兼容接口，对内管理账号、调度、限流恢复、用量统计和访问密钥。本应用采用上游官方 SQLite + 内存缓存的单容器部署方式，不依赖 PostgreSQL 或 Redis。

## 主要功能

- 提供 OpenAI Chat Completions、Responses、Images 和 Anthropic Messages 兼容接口。
- 统一管理 Codex 账号池、健康状态、并发调度、限流恢复和用量统计。
- 通过管理后台维护账号、代理、下游 API Key 和运行参数。
- 使用 SQLite 与内存缓存实现无需外部依赖的单容器部署。

## 访问说明

- 安装时会随机生成 `ADMIN_SECRET`。这是管理后台凭据，请在安装表单中记录并妥善保存。
- 安装完成后，通过应用详情中的 Web 端口访问 `/admin/`，使用 `ADMIN_SECRET` 登录。
- 首次登录后，在管理后台的“API 密钥”页面创建至少一把下游 API Key，再向客户端开放 `/v1/*`。
- 在创建第一把 API Key 之前，`/v1/*` 会返回 HTTP 503；创建后，无有效 API Key 的请求会返回 HTTP 401。
- 上游已不再从 `CODEX_API_KEYS` 环境变量导入下游密钥，因此本应用没有提供无效的 `CODEX_API_KEYS` 表单项。

## Introduction

Codex2API is a Codex account-pool gateway that exposes OpenAI and Anthropic compatible APIs while managing accounts, scheduling, rate-limit recovery, usage, and access keys. This package uses the upstream single-container SQLite and in-memory cache deployment.

## Features

- OpenAI Chat Completions, Responses, Images, and Anthropic Messages compatible APIs.
- Account-pool health, concurrency scheduling, rate-limit recovery, and usage tracking.
- Admin management for accounts, proxies, downstream API keys, and runtime settings.
- Single-container SQLite deployment without PostgreSQL or Redis.

## 数据与升级

- SQLite 数据库、账号信息和图片存放在安装目录的 `data/data` 子目录。
- 应用日志存放在安装目录的 `data/logs` 子目录。
- 应用会保存 Codex Refresh Token、Access Token、代理和下游 API Key。升级、重建或迁移前，请先在 1Panel 中备份整个 `data` 目录。

## 安全与许可证说明

- 仅应在可信环境中部署，并建议通过反向代理启用 HTTPS、限制管理后台来源并配置防火墙访问控制。不要在 HTTP 明文连接中上传真实 Token。
- 本应用强制设置 `CODEX_ALLOW_ANONYMOUS=false`。下游 API Key 仍需在管理后台创建，不能只依赖网络边界。
- 固定版本镜像来自上游作者的 GHCR，OCI source、revision 和版本标签与 `v2.5.8` 源码提交一致。
- 截至 2026-07-21，上游 `2.5.8` 镜像基于已结束支持的 Alpine 3.19。Trivy 在运行文件系统中报告 `musl` 和 `musl-utils` 的 `CVE-2026-40200`（High），镜像安装的是 `1.2.4_git20230717-r5`，修复版本为 `r6`。应用二进制以 `CGO_ENABLED=0` 构建，但镜像内基础工具仍受影响；对该风险敏感时应等待上游发布更新镜像后再部署。
- 上游 README 声明使用 MIT License，但仓库没有独立的 `LICENSE` 文件，OCI license 标签也为空。部署和再分发前请自行确认许可证条件。

## 参考资料

- 项目仓库：<https://github.com/james-6-23/codex2api>
- 部署文档：<https://github.com/james-6-23/codex2api/blob/main/docs/DEPLOYMENT.md>
- 配置文档：<https://github.com/james-6-23/codex2api/blob/main/docs/CONFIGURATION.md>
- 官方镜像：<https://github.com/james-6-23/codex2api/pkgs/container/codex2api>
