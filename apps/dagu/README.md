# Dagu

## 产品介绍

Dagu 是一个本地优先的工作流编排引擎。它以单个进程提供 Web UI、调度器和执行器，使用本地文件保存 DAG 定义、运行记录和配置，不依赖外部数据库或消息队列。

## 主要功能

- 通过 YAML 和 Web UI 创建、调度与运行 DAG
- 查看步骤日志、运行历史、重试和审批状态
- 支持 Shell、HTTP、SSH 等多种工作流步骤
- 内置用户管理、API 和 MCP 服务

## Introduction

Dagu is a local-first workflow orchestration engine. A single process provides the Web UI, scheduler, and executor, while DAG definitions, run history, and configuration are stored as local files without an external database or message broker.

## Features

- Create, schedule, and run YAML-based DAGs from the Web UI
- Inspect step logs and run history, then retry or approve work
- Build workflows with shell, HTTP, SSH, and other supported executors
- Use built-in user management, REST APIs, and the MCP endpoint

## 访问说明

安装后通过 `http://<服务器 IP>:8080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。首次访问时，按照初始化页面创建管理员账户。

## 部署说明

- 本应用使用 Dagu 官方镜像 `ghcr.io/dagucloud/dagu` 的单机 `dagu start-all` 模式。
- 数据目录映射到容器内 `/var/lib/dagu`，保存 DAG 定义、用户、配置和运行历史。
- 默认使用内置认证模式，不包含预设账户或固定密钥。
- 默认不挂载 Docker Socket。Shell、HTTP 等常规步骤可直接使用；需要运行 Docker 容器的 DAG 必须由管理员在了解主机控制风险后另行配置。

## 参数说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Web UI 和 API 的 HTTP 端口 | `8080` | 是 |
| `APP_DATA_DIR` | Dagu 数据目录 | `./data` | 是 |
| `DAGU_TZ` | 调度器时区 | `Asia/Shanghai` | 是 |

## 数据与升级

升级、迁移或卸载前，请备份 `APP_DATA_DIR` 指向的完整目录。默认的 `./data` 位于 1Panel 应用安装目录内，卸载时会被移除。需要跨卸载保留数据时，可选择已规划的独立绝对路径；若该目录已经存在，须提前将其所有权设为 UID/GID `1000:1000`，应用脚本不会修改既有绝对目录的所有权。

## 参考资料

- 项目网站: <https://dagu.sh>
- 项目仓库: <https://github.com/dagucloud/dagu>
- Docker 用法: <https://github.com/dagucloud/dagu#docker>
- Docker Compose 示例: <https://github.com/dagucloud/dagu/blob/main/deploy/docker/compose.minimal.yaml>
