# Langfuse

## 产品介绍

Langfuse 是开源的大语言模型工程与可观测平台，可记录和分析 Trace、Observation、Score、Prompt 与评测数据。本应用使用官方 Langfuse Web、Worker、ClickHouse 和 MinIO 镜像，并复用 1Panel 管理的 PostgreSQL 与 Redis 服务。

## 主要功能

- Langfuse Web 提供界面、公开 API 和初始化管理账户。
- Langfuse Worker 处理摄取队列、后台任务和后台迁移。
- 内置 ClickHouse 25.8 LTS 保存分析数据；内置 MinIO 保存原始事件和媒体对象。
- PostgreSQL 12+ 保存事务数据；Redis 7+ 负责队列与缓存。二者必须在安装表单中选择现有的 1Panel 服务。
- 选择 Redis 服务后，还必须在 `Redis Password` 中填写该服务的 root password；可在所选 Redis 应用的 1Panel 配置中查看。该值不会写入本应用的 README 或日志。

官方默认 Compose 使用浮动的 Debian PostgreSQL/Redis 镜像；本包不内置这两个依赖，而是使用 1Panel 服务选择器。ClickHouse 使用符合 Langfuse 24.3+ 要求、已验证可在目标主机运行的固定 `25.8.28.1`，MinIO 使用固定的多架构 OCI digest。

## 访问说明

- Web 默认地址为 `http://<服务器地址>:3000`，MinIO S3 默认端口为 `9090`；两个端口均可修改。
- `NEXTAUTH_URL` 必须填写用户实际访问 Langfuse 的完整 URL。使用域名或反向代理时应填写 HTTPS 地址。
- `LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT` 是客户端访问 MinIO 的完整 URL，通常为 `http://<服务器地址>:<MinIO 端口>`；该地址不可只在容器网络内可见。
- 安装时会创建一个初始管理员、组织、默认项目和项目 API 密钥。初始化只会补齐不存在的记录，不会在重启或升级时覆盖现有业务数据。
- 首次登录后请在项目设置中轮换或新建 API 密钥，并妥善保存初始管理员密码。

## 数据与升级

- PostgreSQL、ClickHouse 和 MinIO 都是备份边界；Redis 主要保存队列与缓存状态。升级前应同时备份所选 PostgreSQL 数据库、ClickHouse 卷和 MinIO 卷。
- Web 容器启动时执行快速数据库迁移，Worker 启动后执行后台迁移。每次升级后应在 Langfuse 界面确认后台迁移完成，再进行下一次升级。
- 固定版与 `latest` 使用相同的服务、密钥和数据卷，可通过 1Panel 原生升级。`latest` 跟随 Langfuse v3 移动标签。
- 卸载会删除本应用的 ClickHouse 与 MinIO 命名卷；所选的外部 PostgreSQL/Redis 服务及其数据不会由本应用卸载。卸载前必须完成备份。

## 安全说明

- PostgreSQL 密码会进入连接 URL，必须使用 URL 安全字符；建议仅使用字母、数字、点、下划线、波浪号和连字符。
- `ENCRYPTION_KEY` 必须是 64 位十六进制值。安装/升级脚本会保留有效值，并在值无效时静默生成新的安全值；密钥变化会导致既有加密数据无法解密，因此升级前必须备份 `.env`。
- 本包默认关闭公开注册和遥测，且不使用特权模式、主机网络、设备、Docker Socket 或主机目录挂载。
- 仅 Web 与 MinIO S3 端口对外发布；ClickHouse、Worker、PostgreSQL 和 Redis 应仅在可信的 1Panel 内部网络中访问。
- Langfuse 核心采用 MIT 许可证，仓库中的企业版目录受单独的 Langfuse Enterprise License 约束。部署前请确认所用功能的许可范围。

## Introduction

Langfuse is an open-source LLM engineering and observability platform. This package runs the official Web and Worker images with pinned ClickHouse and MinIO services while using selectable 1Panel-managed PostgreSQL 12+ and Redis 7+ services.

## Features

- Capture and analyze traces, observations, scores, prompts, and evaluations.
- Run the official Web and Worker services with persistent ClickHouse and MinIO storage.
- Reuse selectable 1Panel-managed PostgreSQL and Redis services instead of bundling database sidecars.
- Provision an initial owner, organization, project, and API key without enabling public signup.

Set `NEXTAUTH_URL` to the externally reachable Langfuse URL and `LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT` to the externally reachable MinIO S3 endpoint. The installer provisions an initial owner, organization, project, and API key. Public signup and telemetry are disabled by default.

After selecting the Redis service, enter that service's root password in `Redis Password`; it is available in the selected Redis app's 1Panel configuration. Do not put the value in documentation or logs.

Back up PostgreSQL, the ClickHouse volumes, the MinIO volume, and `.env` before upgrades. Fast migrations run in Web startup and background migrations run in the Worker; wait for all background migrations to finish before another upgrade. Uninstall removes the app-owned ClickHouse and MinIO volumes but does not delete the selected external PostgreSQL or Redis services.

Sources: <https://github.com/langfuse/langfuse>, <https://langfuse.com/self-hosting/deployment/docker-compose>, <https://langfuse.com/self-hosting/deployment/infrastructure/postgres>, <https://langfuse.com/self-hosting/deployment/infrastructure/cache>, <https://langfuse.com/self-hosting/deployment/infrastructure/clickhouse>, and <https://langfuse.com/self-hosting/deployment/infrastructure/blobstorage>.
