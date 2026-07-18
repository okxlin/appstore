# Kestra

## 产品介绍

Kestra 是开源的工作流编排平台。本应用包使用 Kestra 官方容器镜像，并将元数据、队列和调度状态保存在选定的 1Panel PostgreSQL Runtime 中。

## 主要功能

- 通过 Web UI 创建、运行和检查工作流。
- 使用 1Panel PostgreSQL Runtime 保存元数据、队列和调度状态。
- 使用可配置的本地目录保存工作流文件存储。
- 使用首次安装时配置的 Basic Auth 保护 Web UI 和 API。

## 访问说明

- 安装前，请在同一 1Panel 中安装并启动 PostgreSQL Runtime，然后在安装表单中选择该服务。面板会为 Kestra 创建独立的数据库和用户。
- 首次访问使用安装表单中的 Basic Auth 用户名和密码。用户名必须是有效的电子邮件地址；密码至少 8 位，且必须含有大写字母、小写字母和数字。
- 在 UI 中创建并运行官方 `hello_world` Log flow，即可验证基础工作流执行。
- 通过 `http://<服务器 IP>:<HTTP 端口>` 访问 Kestra。

## 数据与安全

- 应用业务状态保存在 PostgreSQL，文件存储位于 `DATA_PATH/storage`。升级或迁移前请同时备份 PostgreSQL 数据库和该存储目录。
- 本包默认不挂载 Docker socket，Kestra 应用进程不以 root 身份运行。Docker task runner 需要容器引擎控制权限，不属于默认部署范围；需要该功能时请按 Kestra 官方文档在隔离环境中单独评估。
- 容器仅在启动时以 root 创建并赋权 `/app/storage`，随后立即降权为 Kestra 的 UID/GID `1000` 运行；不会挂载 Docker socket。

## 参数说明

| 参数 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Kestra Web 端口 | `8080` | 是 |
| `PANEL_DB_HOST` | 1Panel PostgreSQL 服务 | - | 是 |
| `PANEL_DB_NAME` | Kestra 专用数据库名 | 自动生成 | 是 |
| `PANEL_DB_USER` | Kestra 专用数据库用户 | 自动生成 | 是 |
| `PANEL_DB_USER_PASSWORD` | Kestra 专用数据库用户密码 | 自动生成 | 是 |
| `KESTRA_BASIC_AUTH_USERNAME` | 初始 Basic Auth 用户名（电子邮件地址） | `admin@kestra.local` | 是 |
| `KESTRA_BASIC_AUTH_PASSWORD` | 初始 Basic Auth 密码 | 自动生成 | 是 |
| `DATA_PATH` | 本地文件存储根目录（使用安装目录外的绝对路径以便卸载后保留） | `/opt/1panel-data/kestra` | 是 |

## 官方资源

- [Kestra 安装文档](https://kestra.io/docs/installation)
- [Kestra Docker Compose 示例](https://kestra.io/docs/installation/docker)
- [Kestra Hello World flow](https://kestra.io/docs/getting-started/quickstart)

---

## Introduction

Kestra is an open-source workflow orchestration platform. This package uses the official Kestra image and stores metadata, queue state, and schedules in the selected 1Panel PostgreSQL Runtime.

## Features

- Create, run, and inspect workflows from the Web UI.
- Store metadata, queue state, and schedules in a 1Panel PostgreSQL Runtime.
- Store workflow files in a configurable local directory.
- Protect the Web UI and API with Basic Auth configured at first installation.

## Notes

- Install and start a PostgreSQL Runtime in the same 1Panel before installing Kestra, then select it in the install form. 1Panel provisions a dedicated Kestra database and user.
- Sign in with the Basic Auth username and password from the install form. The username must be a valid email address; the password must be at least eight characters and include uppercase, lowercase, and numeric characters.
- Create and run the official `hello_world` Log flow in the UI to verify the base workflow path.
- Business state is stored in PostgreSQL and file storage is kept in `DATA_PATH/storage`. Back up both before upgrading or migrating.
- This package does not mount the Docker socket; the Kestra application process does not run as root. Docker task runners need container-engine control and are intentionally outside the default deployment; assess them separately in an isolated environment using the official Kestra documentation.
- The container uses root only at startup to create and assign `/app/storage`, then immediately drops to Kestra UID/GID `1000`; it does not mount the Docker socket.
