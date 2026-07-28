# Flagsmith

## 产品介绍

Flagsmith 是开源的功能标志与远程配置平台，可集中管理功能开关、环境、身份和分段规则，并通过 SDK 或 API 向应用提供配置。

## 主要功能

- 为多个项目和环境管理功能标志
- 按身份、特征和分段规则逐步发布功能
- 通过客户端、服务端 SDK 和 REST API 获取标志
- 记录标志分析数据并运行后台任务

## 访问说明

- 安装前需在 1Panel 中准备一个正在运行的 PostgreSQL 服务，并在表单中选择它。1Panel 会创建并关联 Flagsmith 使用的数据库和用户。
- 安装后访问 `http://<服务器 IP>:8000`，实际端口以 `PANEL_APP_PORT_HTTP` 为准，然后创建首个账户。
- `FLAGSMITH_DOMAIN` 填写浏览器实际访问的主机和可选端口，不包含 `http://` 或路径。例如 `flags.example.com` 或 `192.0.2.10:8000`。
- 公网部署应通过 HTTPS 反向代理访问，并将 `FLAGSMITH_ALLOWED_HOSTS` 限制为实际域名。

## 拓扑和数据

本包保留官方 Compose 的完整应用拓扑：独立数据库迁移门禁、Web/API 主服务和独立任务处理器。三个角色使用同一官方镜像，迁移成功后门禁容器进入空闲状态，另外两个服务才会启动。迁移容器保持运行是为了兼容 1Panel 将成功退出的一次性容器仍标记为异常的状态模型；它不对外提供服务或重复执行任务。Redis 仅用于可选的高级缓存或事件摄取配置，不是官方基础 Compose 的必需依赖。

业务数据保存在所选 PostgreSQL 服务中。升级或卸载前请备份该数据库；卸载应用不会删除外部 PostgreSQL 服务本身。1Panel 当前可能将关联 PostgreSQL 用户创建为超级用户，因此共享实例上的关联用户不是强隔离边界。面向不受信任用户或高价值数据时，应使用专用 PostgreSQL 实例。

## 安全说明

- `DJANGO_SECRET_KEY` 在首次安装时生成并保存在应用 `.env` 中，升级时保持不变。不要提交或共享安装后的 `.env`。
- 默认允许首个及后续用户注册。完成管理员初始化后，可将 `PREVENT_SIGNUP` 改为 `true`。
- Google OAuth、SAML、SMTP、Webhook 和其他外部集成均为可选功能。启用时应使用最小权限凭据，并在升级前重新检查镜像安全公告。
- 应用镜像以非 root 用户运行，只有 Web/API 主服务向主机发布端口；迁移和任务处理器不发布主机端口。

## Introduction

Flagsmith is an open-source feature flag and remote configuration platform. This package preserves the official migration gate, Web/API service, and task-processor topology while using a 1Panel-managed PostgreSQL service. The migration container stays idle after a successful migration because 1Panel otherwise treats a successfully exited one-shot Compose container as unhealthy.

## Features

- Manage feature flags across projects and environments
- Target identities and segments for gradual releases
- Serve configuration through client SDKs, server SDKs, and REST APIs
- Store flag analytics and process background tasks

Choose a running PostgreSQL service during installation. Back up the linked database before upgrades or uninstalling. A 1Panel-linked PostgreSQL role may currently be a superuser, so use a dedicated PostgreSQL instance where stronger isolation is required. Set `FLAGSMITH_DOMAIN` to the public host with an optional port, and use an HTTPS reverse proxy for Internet-facing deployments.

## References

- Website: <https://www.flagsmith.com/>
- Source: <https://github.com/Flagsmith/flagsmith>
- Documentation: <https://docs.flagsmith.com/deployment-self-hosting/hosting-guides/docker>
- License: BSD-3-Clause
