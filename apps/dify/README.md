## 产品介绍

Dify 是一个开源 LLM 应用开发平台，提供 Agent、Workflow、RAG、模型接入、插件市场和应用发布能力。

本适配基于 Dify 官方 `docker/docker-compose.yaml` 默认部署路径，PostgreSQL 与 Redis 使用 1Panel 应用商店已安装服务联动，应用本身包含 Weaviate、Sandbox、SSRF Proxy、Plugin Daemon、API、Worker、Web 和 Nginx 服务。默认通过 Dify 自带 Nginx 暴露 Web 入口，可再由 1Panel OpenResty 反向代理到该端口。

## 主要功能

- 可视化编排 Agent、Workflow 和聊天应用。
- 内置 RAG 知识库、模型供应商接入和应用发布能力。
- 支持插件市场、代码执行沙箱和 SSRF 代理隔离。
- 使用 1Panel 商店 PostgreSQL 和 Redis 服务作为依赖。
- 默认持久化 Weaviate、上传文件和插件数据。

## 访问说明

安装后访问：

```text
http://<服务器 IP>:<HTTP 端口>
```

主要数据默认保存在 `./data` 下，包括应用上传文件、Weaviate、Sandbox 依赖和 Plugin Daemon 数据；PostgreSQL 与 Redis 数据保存在对应的 1Panel 商店服务中。Dify 官方 compose 使用 PostgreSQL 15，本适配已使用 1Panel PostgreSQL 15.18 与 Redis 通过安装、重启、升级测试；不建议选择 PostgreSQL 18。1Panel 运行时默认变量保存在版本目录的 `dify.env` 中，`.env.sample` 仅用于单独 `docker compose` 部署参考；如需覆盖更多 Dify 官方变量，可在安装后创建 `./data/custom.env`，该文件会在容器启动时作为可选 env file 读取。

常用表单项：

- `HTTP 端口`：Dify Web 访问端口。
- `数据目录`：所有持久化数据的宿主机目录。
- `公网基础 URL`：可选。填写后会自动派生 `TRIGGER_URL`、插件回调模板和协作 WebSocket 地址。
- `初始化密码`：首次初始化管理员账号时使用。
- `数据库服务`：请选择 1Panel 商店中的 PostgreSQL 服务，建议使用 PostgreSQL 15。
- `Redis 服务`：请选择 1Panel 商店中的 Redis 服务。
- `协作模式`：默认关闭。启用后默认使用同源 `/socket.io` 地址；如需同时生成公网 webhook / 插件调试地址，再填写 `公网基础 URL`。
- `Sandbox、Plugin Daemon、Weaviate 密钥`：安装时建议使用随机强密码。

Webhook 与插件远程调试依赖公网可访问地址；未填写 `公网基础 URL` 时，包内默认只保留相对路径，避免向远程用户暴露误导性的 `localhost` 地址。协作模式默认走同源 `/socket.io`。升级前建议备份 `./data` 目录。

## Introduction

Dify is an open-source LLM application development platform for building agents, workflows, RAG applications, model integrations, plugins, and published AI apps.

This package follows Dify's official Docker Compose deployment path. PostgreSQL and Redis are linked to existing 1Panel app store services, while Dify's own Nginx exposes the web entry and can be proxied by 1Panel OpenResty.

## Features

- Visual agent, workflow, and chat application orchestration.
- Built-in RAG knowledge base, model provider integrations, and app publishing.
- Plugin daemon, code execution sandbox, and SSRF proxy isolation.
- PostgreSQL and Redis dependencies provided by 1Panel app store services.
- Persistent Weaviate, uploaded files, and plugin data under the configured data directory.

PostgreSQL 15 is recommended. The package was tested with 1Panel PostgreSQL 15.18 and Redis for install, restart, and upgrade flows; PostgreSQL 18 is not recommended for Dify 1.15 migrations. Runtime defaults now live in `dify.env`, while `.env.sample` remains a standalone Compose helper. Collaboration mode is disabled by default and uses same-origin `/socket.io` when enabled; set `PUBLIC_BASE_URL` when you want webhook or plugin callback URLs derived for remote users.
