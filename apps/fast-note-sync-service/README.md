# Fast Note Sync Service

## 产品介绍

Fast Note Sync Service 是一个面向 Obsidian 的高性能、低延迟笔记同步服务，提供 Web 管理面板、REST API、WebSocket 同步、附件同步和多端配置同步。

本应用使用上游项目维护的 Docker Hub 官方镜像 `haierkeys/fast-note-sync-service`。上游项目采用 Apache-2.0 许可证，默认使用 SQLite，不需要 Redis、MySQL、PostgreSQL、Docker Socket 或特权权限。

## 主要功能

- Obsidian 笔记、附件和 `.obsidian` 配置多端同步
- Web 管理面板、REST API 和 WebSocket 接口
- 支持笔记历史、回收站、分享、Git 自动化和多存储备份
- 支持 MCP，可供兼容的 AI 客户端访问笔记和附件

## 上游来源

- 官方仓库: <https://github.com/haierkeys/fast-note-sync-service>
- 官方 Docker 镜像: <https://hub.docker.com/r/haierkeys/fast-note-sync-service>
- 官方部署文档: <https://github.com/haierkeys/fast-note-sync-service/blob/3.5.7/docs/README.zh-CN.md>
- 当前应用版本: `3.5.7`
- 支持架构: `amd64`、`arm64`、`armv7`

镜像同时声明了 `9001` 端口，但上游 README 的默认 compose 只映射 `9000`。本应用遵循该单服务部署路径，不默认暴露 `9001`。

## 访问说明

- 安装完成后访问 `http://<服务器IP>:<PANEL_APP_PORT_HTTP>`。
- 首次访问时按页面提示注册管理员账号，然后在管理面板中生成客户端插件配置。
- Obsidian 客户端需要安装上游的 [Obsidian Fast Note Sync Plugin](https://github.com/haierkeys/obsidian-fast-note-sync)。
- 如通过反向代理或公网使用，建议启用 HTTPS，并按上游文档配置可信代理和外部访问地址。

## 数据持久化

| 目录变量 | 容器目录 | 内容 |
| --- | --- | --- |
| `APP_DATA_DIR` | `/fast-note-sync/storage` | SQLite 数据库、笔记附件、日志、索引和备份 |
| `APP_CONFIG_DIR` | `/fast-note-sync/config` | `config.yaml` 等应用配置 |

默认配置使用 SQLite，数据库文件位于 `storage/database/db.sqlite3`。升级或卸载前请备份 `APP_DATA_DIR` 和 `APP_CONFIG_DIR`；卸载应用不会主动删除这两个 bind mount 目录。

## 配置说明

常用配置位于 `APP_CONFIG_DIR/config.yaml`。应用的数据库类型、外部访问地址、注册开关、全文检索、OIDC、备份和存储后端等高级选项由该配置文件管理，本应用安装表单只暴露经过验证的端口、时区和持久化目录。

上游支持 SQLite、MySQL 和 PostgreSQL，但当前官方 Docker compose 默认使用 SQLite，且外部数据库需要编辑 `config.yaml` 并完成应用侧配置，因此没有在安装表单中虚构或强制添加数据库 runtime 选择器。

## 升级说明

- 当前为首次收录版本 `3.5.7`，没有旧版 appstore 包可直接升级。
- 后续版本升级前请备份 `APP_DATA_DIR` 和 `APP_CONFIG_DIR`，并阅读上游 release notes。
- 不要在应用运行时直接复制 SQLite 数据库目录；如需迁移，请先停止应用并同时保留 SQLite 的 `-wal`、`-shm` 文件。
- 上游客户端插件和服务端版本应保持兼容，升级后请重新检查客户端同步和 WebSocket 连接。

## Introduction

Fast Note Sync Service is a high-performance, low-latency note synchronization service for Obsidian. It provides a web admin panel, REST API, WebSocket synchronization, attachment sync, and configuration sync.

The package uses the upstream-maintained official Docker Hub image `haierkeys/fast-note-sync-service`. The default deployment uses SQLite and does not require Redis, MySQL, PostgreSQL, Docker Socket, or privileged permissions.

## Features

- Multi-device synchronization for Obsidian notes, attachments, and configuration
- Web administration, REST API, WebSocket synchronization, and MCP support
- SQLite-based default deployment with no external database or cache dependency
- Persistent storage and configuration directories exposed through the 1Panel form

## References

- Repository: <https://github.com/haierkeys/fast-note-sync-service>
- Docker image: <https://hub.docker.com/r/haierkeys/fast-note-sync-service>
- Documentation: <https://github.com/haierkeys/fast-note-sync-service/blob/3.5.7/README.md>
