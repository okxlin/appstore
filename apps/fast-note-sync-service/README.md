# Fast Note Sync Service

## 产品介绍

Fast Note Sync Service 是一个面向 Obsidian 的高性能、低延迟笔记同步服务，提供 Web 管理面板、REST API、WebSocket 同步、附件同步和多端配置同步。

本应用使用上游项目维护的 Docker Hub 应用镜像 `haierkeys/fast-note-sync-service`。上游项目采用 Apache-2.0 许可证，默认使用 SQLite，不需要 Redis、MySQL、PostgreSQL、Docker Socket 或特权权限。该镜像由上游仓库的发布工作流推送，但其 Dockerfile 基于社区维护的 `woahbase/alpine-glibc`，请按第三方基础镜像信任边界审计并及时更新。

## 主要功能

- Obsidian 笔记、附件和 `.obsidian` 配置多端同步
- Web 管理面板、REST API 和 WebSocket 接口
- 支持笔记历史、回收站、分享、Git 自动化和多存储备份
- 支持 MCP，可供兼容的 AI 客户端访问笔记和附件

## 上游来源

- 官方仓库: <https://github.com/haierkeys/fast-note-sync-service>
- 上游维护的 Docker 镜像: <https://hub.docker.com/r/haierkeys/fast-note-sync-service>
- 官方部署文档: <https://github.com/haierkeys/fast-note-sync-service/blob/master/docs/README.zh-CN.md>
- 支持架构: `amd64`、`arm64`、`armv7`

Docker Hub 镜像由上游 GitHub Actions 发布，当前有较高社区使用量（约 24 万 pulls）。这不等同于基础镜像由上游维护；安装前仍应核对镜像 digest、上游 release notes 和扫描结果。

镜像同时声明了 `9001` 端口，但上游 README 的默认 compose 只映射 `9000`。本应用遵循该单服务部署路径，不默认暴露 `9001`。

## 安全与权限

- 上游镜像中的主进程默认以容器内 `root` 用户运行。
- 本应用不使用 `privileged`、Docker Socket、host network、设备映射或额外 Linux capabilities。
- 容器只绑定安装表单指定的存储和配置目录，请勿把系统目录、密钥目录或其他敏感宿主路径填入 `APP_DATA_DIR`、`APP_CONFIG_DIR`。
- 上游镜像的系统库和 Go 运行时可能包含镜像扫描器报告的已知 High / Critical 漏洞。请及时更新应用，仅向可信网络开放，并在升级前核对上游安全修复说明。

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

## 数据库版本选择

常用配置位于 `APP_CONFIG_DIR/config.yaml`。应用的外部访问地址、注册开关、全文检索、OIDC、备份和存储后端等高级选项由该配置文件管理。

当前提供 SQLite 和外部数据库两个安装版本。外部数据库版本内部再选择具体引擎：

- `3.6.0`：SQLite，适合单机和个人使用，不需要安装数据库 runtime。
- `3.6.0&database`：通过同一个 1Panel 数据库服务选择器选择 MySQL 或 PostgreSQL runtime，并由面板创建应用数据库和用户。

SQLite、MySQL 和 PostgreSQL 不能通过升级脚本静默互换。需要切换数据库引擎时，请按上游迁移文档执行备份、导入和客户端验证，再新建对应版本的应用；外部数据库变体检测到已有 SQLite `config.yaml` 时会拒绝启动，不会覆盖它。

MySQL/PostgreSQL 版本的表单会先选择数据库类型，再选择该类型下已安装且运行中的 1Panel runtime。不要把数据库主机字段当作普通文本填写，也不要在同一个安装中重复使用其他应用的数据库名、用户或密码。

PostgreSQL 选择器使用 1Panel 的 linked database 创建流程。当前 1Panel v2 会将应用 PostgreSQL 角色创建为 superuser，请在生产环境前评估这一权限边界，或为本应用使用专用 runtime。卸载时可能删除该应用关联的 schema/user，但不会删除共享 runtime 容器或其他应用资源。

## 升级说明

- 版本升级前请备份 `APP_DATA_DIR` 和 `APP_CONFIG_DIR`，并阅读上游 release notes。
- `3.6.0` SQLite 用户升级到后续 SQLite 版本时，安装脚本会保留已有 `config.yaml`、SQLite 数据库和数据目录；当前数据库变体是独立安装版本，不是 SQLite 到外部数据库的自动迁移器。
- 外部数据库版本升级前请同时确认所选 runtime 仍为 `Running`，并备份外部数据库；1Panel 删除本应用时可能删除该应用关联的 linked schema/user，但不会删除共享 runtime 容器或其他应用的数据库资源。
- 不要在应用运行时直接复制 SQLite 数据库目录；如需迁移，请先停止应用并同时保留 SQLite 的 `-wal`、`-shm` 文件。
- 上游客户端插件和服务端版本应保持兼容，升级后请重新检查客户端同步和 WebSocket 连接。

## Introduction

Fast Note Sync Service is a high-performance, low-latency note synchronization service for Obsidian. It provides a web admin panel, REST API, WebSocket synchronization, attachment sync, and configuration sync.

The package uses the upstream-maintained Docker Hub application image `haierkeys/fast-note-sync-service`. The default deployment uses SQLite and does not require Redis, MySQL, PostgreSQL, Docker Socket, or privileged permissions. The upstream image is built on the community-maintained `woahbase/alpine-glibc` base image, so review it as a trusted third-party base and keep the image updated.

## Features

- Multi-device synchronization for Obsidian notes, attachments, and configuration
- Web administration, REST API, WebSocket synchronization, and MCP support
- SQLite-based default deployment with no external database or cache dependency
- One external-database variant with MySQL and PostgreSQL 1Panel runtime selectors
- Persistent storage and configuration directories exposed through the 1Panel form

## Security and permissions

The upstream process runs as root inside the container. This package does not grant privileged mode, Docker Socket, host networking, device access, or extra Linux capabilities. Only use dedicated application directories for the two bind mounts.

The upstream image's system libraries and Go runtime may include known High or Critical vulnerabilities reported by image scanners. Keep the app updated, limit access to trusted networks, and review upstream security fixes before upgrading.

The PostgreSQL selector uses 1Panel's linked-database provisioning path. In the current 1Panel v2 implementation, that path creates the application PostgreSQL role with superuser privileges; keep the selected runtime dedicated or review this privilege boundary before production use. Uninstall may remove the linked schema/user, while the shared runtime container and unrelated resources remain.

## References

- Repository: <https://github.com/haierkeys/fast-note-sync-service>
- Upstream-maintained Docker image: <https://hub.docker.com/r/haierkeys/fast-note-sync-service>
- Documentation: <https://github.com/haierkeys/fast-note-sync-service/blob/master/README.md>
