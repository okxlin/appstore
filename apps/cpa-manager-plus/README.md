# CPA Manager Plus

## 产品介绍
CPA Manager Plus 是面向 Cli-Proxy-API 的增强管理与观测面板，支持管理页面、请求监控、兼容接口和本地数据加密存储。

CPA Manager Plus 是新安装的推荐版本，与维护模式的 CPA Manager 使用独立应用 key 和管理员认证机制。

## 主要功能
- 独立部署的管理与观测面板
- 支持通过 UI 连接现有 CPA 实例
- 管理员凭据、SQLite 数据和加密密钥本地持久化
- 支持 `auto`、`subscribe`、`http`、`resp` 四种采集模式

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口/management.html
```

可以在安装表单中设置稳定的 `CPA_MANAGER_ADMIN_KEY`。留空时，上游会在首次启动时生成符合格式的高强度密钥，并仅在容器日志中输出一次；请先保存该密钥，再登录并填写 CPA URL 和 CPA Management Key。

使用前需已有可访问的 CPA / Cli-Proxy-API 实例，并启用远程管理接口、设置 Management Key 和开启用量统计。上游推荐 CPA `v7.1.39+`，HTTP 用量队列最低要求为 `v6.10.8+`。

如需从其他设备访问，请在安装时开启端口外部访问，或在 1Panel 中配置反向代理。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/data`，保存 `usage.sqlite`、`data.key` 和其他本地运行数据
- 备份必须同时包含 SQLite 文件及其 `-wal`、`-shm` 文件和 `data.key`；丢失 `data.key` 后，已保存的 CPA Management Key 无法恢复

## 从 CPA Manager 迁移
CPA Manager Plus 不是 CPA Manager 的普通版本升级。迁移前停止旧应用并完整备份 `/data`，再按照上游迁移指南复用数据目录；不要让两个应用同时消费同一个用量队列。

## Introduction
CPA Manager Plus is an enhanced management and observability panel for Cli-Proxy-API. It provides the management UI, request monitoring, compatibility endpoints, and local encrypted data storage.

CPA Manager Plus is recommended for new installations. It uses a separate app key and a different administrator authentication contract from the maintenance-mode CPA Manager.

## Features
- Standalone management and observability panel
- Connects to an existing CPA instance through the UI
- Persists the admin credential, SQLite data, and encryption key locally
- Supports `auto`, `subscribe`, `http`, and `resp` collector modes

## 参考资料
- 源码: <https://github.com/seakee/CPA-Manager-Plus>
- 文档: <https://github.com/seakee/CPA-Manager-Plus/blob/main/README.md>
- Docker Compose: <https://github.com/seakee/CPA-Manager-Plus/blob/main/docker-compose.manager.yml>
- 迁移指南: <https://github.com/seakee/CPA-Manager-Plus/blob/main/docs/migration-from-cpa-manager.zh-CN.md>
