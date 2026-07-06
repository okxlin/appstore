# Jianmu

## 产品介绍

Jianmu（建木）是一个面向 DevOps 场景的开源无代码 / 低代码工作流平台，可用于图形化编排、任务执行、流程分发和 Runner 管理。

## 主要功能

- 图形化 DevOps 工作流编排与执行
- Web UI、Java 服务端和 Docker Worker 官方三服务拓扑
- 对接外部 MySQL 8 服务保存工作流、用户和运行数据
- 通过 Docker Worker 在宿主机上拉起与调度任务容器

## 访问说明

- 安装后通过 `http://<服务器IP>:<端口>` 访问，实际端口以表单中的 `PANEL_APP_PORT_HTTP` 为准。
- 默认登录用户名固定为 `admin`，密码使用安装表单里的 `JIANMU_API_ADMINPASSWD`。
- 首次启动需要等待 Java 服务端完成数据库连接和迁移，通常需要 1 到 3 分钟。

## Introduction

Jianmu is an open source no-code and low-code DevOps workflow platform for graphical pipeline orchestration, task execution, and worker management.

## Features

- Graphical DevOps workflow orchestration
- Official three-service topology with Web UI, Java server, and Docker worker
- Reuse 1Panel store-managed MySQL-compatible runtimes through the install form selector
- Docker worker execution on the host through the Docker socket

## 部署说明

- 本应用基于官方源码仓库 `jianmu-dev/jianmu` 和官方 deploy 仓库 `jianmu-dev/jianmu-deploy` 适配。
- 保留官方 `web + ci-server + worker` 三服务拓扑，但移除官方 compose 中自带的 MySQL 容器，优先改为复用 1Panel 管理的 MySQL / LocalMySQL / MariaDB 服务实例。
- 官方 deploy 示例默认使用固定弱口令 `admin/123456`、`worker-secret` 和 MySQL `123456`；本适配改为表单化或随机化处理 `JIANMU_API_ADMINPASSWD`、`JIANMU_API_JWTSECRET` 和 `JIANMU_WORKER_SECRET`。
- 版本目录 `2.8.2` 与 `latest` 当前都固定到同一官方发布线：`jianmu-ui:v2.8.2`、`jianmu-server:v2.8.2`、`jianmu-worker-docker:v1.0.13`。
- 官方镜像来自 deploy compose 使用的 `docker.jianmuhub.com/jianmu/*` 命名空间，并已核实 `amd64` / `arm64` 可拉取。

## 端口

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Jianmu Web 访问端口，映射到容器内 `80` | `18080` | 是 |

## 数据持久化

| 变量 / 目录 | 说明 | 默认值 |
| --- | --- | --- |
| `APP_DATA_DIR/server-data` | Jianmu 服务端数据目录，对应容器 `/home/jianmu/data` | `./data/server-data` |

升级、迁移或重装前，请至少备份 `APP_DATA_DIR` 和外部 MySQL 数据库。

## 参数说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_DB_TYPE` | 安装表单中的数据库类型选择器，支持 `mysql` / `localmysql` / `mariadb` | `mysql` | 是 |
| `PANEL_DB_HOST` | 由 1Panel 商店数据库 service 选择器注入的服务名；也兼容旧安装里手工填写的主机名或 IP | `mysql` | 是 |
| `PANEL_DB_PORT` | MySQL 端口 | `3306` | 是 |
| `PANEL_DB_NAME` | Jianmu 数据库名 | `jianmu` | 是 |
| `PANEL_DB_USER` | Jianmu 数据库用户 | `jianmu` | 是 |
| `PANEL_DB_USER_PASSWORD` | Jianmu 数据库密码 | 随机生成 | 是 |
| `TZ` | 容器与 JVM 时区 | `Asia/Shanghai` | 是 |
| `JIANMU_API_ADMINPASSWD` | 默认 `admin` 账户密码 | 随机生成 | 是 |
| `JIANMU_API_JWTSECRET` | API JWT 密钥，安装后不要随意更换 | 随机生成 | 是 |
| `JIANMU_WORKER_SECRET` | Worker 与服务端共享密钥 | 随机生成 | 是 |
| `JIANMU_WORKER_ID` | Worker 标识 | `worker1` | 是 |
| `JIANMU_WORKER_CAPACITY` | Worker 可并发任务数 | `5` | 是 |
| `DOCKER_SOCK_PATH` | 宿主机 Docker 套接字路径 | `/var/run/docker.sock` | 是 |

## 使用说明

- 安装表单中请先选择数据库类型，再从下一级 service 列表选择具体的 1Panel 商店数据库实例；当前已适配 `MySQL`、`LocalMySQL` 和 `MariaDB`。
- 如果选择的是 1Panel 管理的 MySQL 兼容 runtime，本包会在安装阶段自动探测对应容器并完成 Jianmu 所需的建库、建用户和授权。
- 旧安装如果已经把 `PANEL_DB_HOST` 手工写成外部 MySQL 主机名或 IP，本次升级不会覆盖该值；这类外部数据库场景仍需提前手工创建 `PANEL_DB_NAME`、`PANEL_DB_USER` 和对应权限。
- 如果宿主机 Docker 套接字不是默认 `/var/run/docker.sock`，请把 `DOCKER_SOCK_PATH` 改成真实路径。
- 官方 README 提到 Ubuntu 等场景也可以改成 Docker TCP；当前适配只封装了本地 Socket 路径方案，没有默认开放远程 Docker TCP。
- 如果需要公网访问，请在 1Panel 或外部反向代理层补 HTTPS、鉴权和网络隔离。

## 风险与升级说明

- `worker` 服务会以读写方式挂载宿主机 Docker Socket，具备在宿主机上创建、停止和删除容器的能力，只建议部署在可信主机上。
- 这是一个多服务、外部数据库、带 Docker Socket 权限的高联动应用，排障与升级复杂度高于普通单容器应用。
- 当前包固定到官方 `v2.8.2` / `v1.0.13` 镜像线，`latest` 目录也同样固定到该发布线。
- 自动 in-place 升级暂未放开；`upgrade.sh` 只输出明确提醒，不做破坏性迁移。
- 升级前请备份 `APP_DATA_DIR`、MySQL 兼容数据库数据，以及安装时使用的 `JIANMU_API_JWTSECRET` / `JIANMU_WORKER_SECRET`。
- `upgrade.sh` 会兼容把旧测试包里的 `DB_PORT` 迁移为 `PANEL_DB_PORT`，并尽量根据旧 `PANEL_DB_HOST` 自动推断补齐 `PANEL_DB_TYPE`，避免已绑定 `localmysql` / `mariadb` 的老安装在升级后无法于表单中正确回显商店 runtime。
- 由于存在 Docker Socket 权限、外部数据库依赖和升级联动风险，本应用不加入 Renovate 自动合并白名单。

## 参考资料

- 官网: <https://jianmu.dev>
- 官方文档: <https://docs.jianmu.dev>
- 项目仓库: <https://github.com/jianmu-dev/jianmu>
- 官方 deploy 仓库: <https://gitee.com/jianmu-dev/jianmu-deploy>
- 官方 deploy compose: <https://gitee.com/jianmu-dev/jianmu-deploy/raw/master/docker-compose.yml>
