# Next Terminal

## 产品介绍
Next Terminal 是一个交互式运维审计系统，支持 RDP、SSH、VNC、Telnet、Kubernetes 等协议。

`3.5.2` 和 `latest` 版本部署 Next Terminal 与 Guacd，并连接用户在 1Panel 安装表单中选择的 PostgreSQL 应用服务。历史 `3.1.1` 版本保留原有的内置 PostgreSQL 拓扑，仅用于兼容已有安装。

## 主要功能
- 管理和审计远程连接与会话。
- 使用 Guacd 提供远程桌面协议支持。
- 持久化配置、日志和录屏文件。
- 在 1Panel 中选择并关联 PostgreSQL 应用服务。
- Web UI 与 SSH 代理端口可在安装表单中配置。

## 访问说明
安装完成后，通过应用表单中的 Web UI 端口访问：

```text
http://<服务器 IP>:<Web UI 端口>
```

首次安装请访问 `/setup` 初始化管理员。`SSH 代理端口` 仅在 Next Terminal 后台启用 SSH 代理服务后使用。

## 部署拓扑
- `3.5.2`、`latest`：Next Terminal + Guacd + 1Panel PostgreSQL 应用服务。
- `3.1.1`：Next Terminal + Guacd + 应用包内置 PostgreSQL，仅作为历史兼容版本保留。
- `latest` 当前固定到已审计的 `3.5.2` 镜像，不跟随未审计的浮动标签。
- 支持架构：amd64、arm64。

## PostgreSQL 联动
安装 `3.5.2` 或 `latest` 前，请先在 1Panel 应用商店安装并启动 PostgreSQL 16.x。安装表单会先选择 PostgreSQL 应用，再选择实际运行的服务实例；不要手工填写容器主机名。

1Panel 会根据 `PANEL_DB_NAME`、`PANEL_DB_USER` 和 `PANEL_DB_USER_PASSWORD` 创建并关联应用数据库。PostgreSQL 的数据目录、备份和大版本升级由所选 PostgreSQL 应用负责，不属于 Next Terminal 的 `DATA_PATH`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Web UI 端口 | 40058 | 是 |
| `PANEL_APP_PORT_SSH` | SSH 代理端口 | 40059 | 否 |

## 数据持久化
| 路径 | 说明 |
| --- | --- |
| `DATA_PATH` | Next Terminal 配置、日志、录屏及 Guacd 共享数据 |
| `DATA_PATH/config.yaml` | 自动生成的应用配置；存在时不会被覆盖 |
| `DATA_PATH/logs` | Next Terminal 日志 |
| PostgreSQL 应用数据目录 | 数据库持久化位置，由所选 PostgreSQL 应用管理 |

历史 `3.1.1` 安装的数据库仍位于 `DATA_PATH/postgresql`。新版本不会读取、移动或删除该目录。

## 3.5.2 镜像来源
- 官方容器安装文档使用 `dushixiang/next-terminal` 和 `dushixiang/guacd`，官方 Compose 同时使用 PostgreSQL 16.4。
- `dushixiang/next-terminal:v3.5.2` 的多架构 manifest 固定为 `sha256:4e095f8a0309878e2966d3157af5667b6911b6890d5e4c4abfa5116e0209ca3e`。
- 上游仓库存在提交 `7704b32dde617c161540432b6f71867fb3cf9ed8`，提交信息为 `v3.5.2`；截至 2026-07-23，上游没有同名 Git tag 或 GitHub Release，因此本应用将其标记为官方发布镜像版本，不把它表述为 GitHub 正式 Release。
- Docker Hub 的 `dushixiang/next-terminal` 仓库在 2026-07-23 显示约 100 万次拉取。本应用按高下载量可信镜像策略接受该来源，并固定 manifest digest 防止标签漂移。
- Guacd 固定为上游兼容版本 `1.6.0`，manifest 为 `sha256:40872b125c3d946314bd322a3a54325ee2d9a58ecd788f76720ca11874548e42`。

这些容器不需要特权模式、Docker Socket、额外 capability 或 host network。上游镜像默认以 root 用户运行，部署前应按实际暴露范围配置防火墙和反向代理。

## 升级注意
应用继续设置 `crossVersionUpdate: false`。不支持从 `3.1.1` 直接升级到 `3.5.2`，因为数据库拓扑从包内 PostgreSQL 改为 1Panel PostgreSQL 应用服务。

新版本初始化脚本会在缺少 `PANEL_DB_HOST` 时停止；如果已有 `config.yaml` 中的数据库主机与所选 PostgreSQL 服务不同，也会停止并保留原文件。脚本不会重写配置、迁移数据库或删除 `DATA_PATH/postgresql`。

由于两个版本的主版本号同为 3，1Panel 仍可能显示升级入口。目标版本的 `upgrade.sh` 会检测旧的 `DATA_PATH/postgresql` 或缺失的 `PANEL_DB_HOST`，恢复仍在磁盘上的旧 Compose 后拒绝升级；面板会显示升级失败，但旧版本容器和数据会继续保留。不要重复点击升级，请按下述迁移流程新装。

迁移时请先备份 `DATA_PATH` 和旧 PostgreSQL 数据库，再安装 PostgreSQL 16.x，使用 PostgreSQL 原生备份/恢复或 Next Terminal 官方备份恢复流程迁移数据，最后新装 `3.5.2` 并验证业务数据。旧实例确认无误前不要卸载。

## Introduction
Next Terminal is an interactive operations-audit platform supporting RDP, SSH, VNC, Telnet, Kubernetes, and related protocols.

Versions `3.5.2` and `latest` deploy Next Terminal with Guacd and require a PostgreSQL 16.x service selected from an installed 1Panel PostgreSQL application. The historical `3.1.1` package retains its bundled PostgreSQL topology for existing installations.

The `v3.5.2` image is referenced by the upstream deployment channel and has a matching upstream source commit, but no matching Git tag or GitHub Release was available on 2026-07-23. The package therefore pins the published multi-architecture image digest and documents the Docker Hub repository's approximately one million pulls. Direct `3.1.1` to `3.5.2` upgrades remain disabled because database migration is manual.

## Features
- Manage and audit remote connections and sessions.
- Use Guacd for remote desktop protocol support.
- Persist configuration, logs, and recordings.
- Select and link a PostgreSQL service from the 1Panel application form.

## 参考资料
- 官网: <https://www.next-terminal.com/>
- 文档: <https://docs.next-terminal.com/>
- 容器安装: <https://docs.next-terminal.com/zh/install/container-install.html>
- 源码: <https://github.com/next-terminal/next-terminal>
- 镜像: <https://hub.docker.com/r/dushixiang/next-terminal>
