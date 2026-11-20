## 产品介绍

Dify 是一个开源 LLM 应用开发平台，提供 Agent、Workflow、RAG、模型接入、插件市场和应用发布能力。

本适配基于 Dify 官方 `docker/docker-compose.yaml` 默认部署路径，PostgreSQL 与 Redis 使用 1Panel 应用商店已安装服务联动，应用本身包含 Weaviate、Sandbox、Agent Backend、Agent Local Sandbox、SSRF Proxy、Plugin Daemon、API、Worker、Web 和 Nginx 服务。默认通过 Dify 自带 Nginx 暴露 Web 入口，可再由 1Panel OpenResty 反向代理到该端口。

> Dify Agent 当前为 Beta。其本地沙箱允许执行代码和 Shell 命令，只应向可信、非恶意用户开放。Agent 服务端加密密钥必须是解码后 32 字节的 Base64URL；安装或升级脚本会替换缺失或格式无效的值，并在 1Panel 任务日志中说明，但不会输出密钥内容。

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
- `Sandbox、Plugin Daemon、Agent、Weaviate 密钥`：安装时应使用随机强密码。Agent 服务端加密密钥会被校验为 32 字节 Base64URL；脚本保留合法自定义值，只替换缺失或无效值。

Webhook 与插件远程调试依赖公网可访问地址；未填写 `公网基础 URL` 时，包内默认只保留相对路径，避免向远程用户暴露误导性的 `localhost` 地址。协作模式默认走同源 `/socket.io`。升级前建议备份 `./data` 目录。

## 升级提示：1.19.0 → 1.20.0

1.20.0 的 `APP_DATA_DIR` 和 `CUSTOM_ENV_FILE` 必须指向当前 Dify 实例目录内的相对路径；绝对路径、目录穿越和符号链接都会被拒绝。若旧实例任一设置指向实例目录外，或使用了目录穿越/符号链接路径，请先完整备份现有数据目录和 `custom.env`（若 `custom.env` 不在数据目录内，需单独备份），再将数据复制到实例目录内的 `./data`，并将自定义环境文件复制为 `./data/custom.env`。然后在旧实例设置中将两项分别改为 `APP_DATA_DIR=./data` 和 `CUSTOM_ENV_FILE=./data/custom.env`，确认旧实例仍能读取原有数据后再升级。保留旧目录和备份，直至 1.20.0 验证通过。

旧版 `local_sandbox` 没有把 `/home/dify` 和 `/workspace` 挂载到 `APP_DATA_DIR`，其中的文件只存在于旧容器可写层。1Panel 会先停止并移除旧容器，再运行新版 `upgrade.sh`，因此升级脚本无法自动复制这些文件；未备份的内容会丢失。如果 Agent home 或 workspace 中有需要保留的内容，请在升级前、旧容器仍存在时备份：

```sh
CONTAINER="当前 Dify 实例的 local-sandbox 容器名"
BACKUP_DIR="/path/to/dify-local-sandbox-backup"
mkdir -p "$BACKUP_DIR/home" "$BACKUP_DIR/workspace"
docker cp -a "$CONTAINER:/home/dify/." "$BACKUP_DIR/home/"
docker cp -a "$CONTAINER:/workspace/." "$BACKUP_DIR/workspace/"
```

确认两次复制都成功后再升级，并保留备份。升级后核对本实例 `APP_DATA_DIR`，将备份内容恢复到其中的 `agent_local_sandbox/home` 和 `agent_local_sandbox/workspace`，再重启并检查 Dify。若这两处目录为空或未使用，则无需迁移。

## Introduction

Dify is an open-source LLM application development platform for building agents, workflows, RAG applications, model integrations, plugins, and published AI apps.

This package follows Dify's official Docker Compose deployment path. PostgreSQL and Redis are linked to existing 1Panel app store services, while Dify's own Nginx exposes the web entry and can be proxied by 1Panel OpenResty. Dify Agent Backend and Agent Local Sandbox are included for the Agent experience introduced in Dify 1.16.

> Dify Agent is currently beta software. Its local sandbox can execute code and shell commands and should only be exposed to trusted, non-malicious users. The server secret must be Base64URL that decodes to exactly 32 bytes. Install and upgrade scripts replace missing or invalid values and note the replacement in the 1Panel task log without printing the secret.

## Features

- Visual agent, workflow, and chat application orchestration.
- Built-in RAG knowledge base, model provider integrations, and app publishing.
- Plugin daemon, code execution sandbox, and SSRF proxy isolation.
- PostgreSQL and Redis dependencies provided by 1Panel app store services.
- Persistent Weaviate, uploaded files, and plugin data under the configured data directory.

PostgreSQL 15 is recommended. The package was tested with 1Panel PostgreSQL 15.18 and Redis for install, restart, and upgrade flows; PostgreSQL 18 is not recommended for Dify migrations. Runtime defaults live in `dify.env`, while `.env.sample` remains a standalone Compose helper. Collaboration mode is disabled by default and uses same-origin `/socket.io` when enabled; set `PUBLIC_BASE_URL` when you want webhook or plugin callback URLs derived for remote users.

### Upgrade note: 1.19.0 to 1.20.0

In 1.20.0, `APP_DATA_DIR` and `CUSTOM_ENV_FILE` must resolve to relative paths inside the current Dify instance directory; absolute paths, traversal, and symbolic links are rejected. If either old setting points outside the instance directory, uses traversal, or passes through a symbolic link, first back up the complete data directory and `custom.env` (back up the env file separately when it is outside the data directory), then copy the data into `./data` inside the instance directory and copy the custom env file to `./data/custom.env`. Change the old installation settings to `APP_DATA_DIR=./data` and `CUSTOM_ENV_FILE=./data/custom.env`, confirm the old installation still reads its existing data, and then upgrade. Keep the old data and backup until 1.20.0 has been verified.

The 1.19.0 `local_sandbox` service did not bind `/home/dify` or `/workspace` to `APP_DATA_DIR`; files there exist only in the old container's writable layer. 1Panel removes the old containers before running the target version's `upgrade.sh`, so this package cannot copy those files automatically. Unbacked data will be lost. If you stored Agent home or workspace data, back it up before upgrading while the old container still exists:

```sh
CONTAINER="the current Dify local-sandbox container name"
BACKUP_DIR="/path/to/dify-local-sandbox-backup"
mkdir -p "$BACKUP_DIR/home" "$BACKUP_DIR/workspace"
docker cp -a "$CONTAINER:/home/dify/." "$BACKUP_DIR/home/"
docker cp -a "$CONTAINER:/workspace/." "$BACKUP_DIR/workspace/"
```

Start the upgrade only after both copies succeed, and keep the backup. After upgrading, check this instance's `APP_DATA_DIR`, restore the files to `agent_local_sandbox/home` and `agent_local_sandbox/workspace` beneath it, then restart and verify Dify. Empty or unused directories do not need migration.
