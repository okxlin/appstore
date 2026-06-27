# Komari

## 产品介绍
Komari 是轻量自托管服务器监控面板，通过 Web 界面查看服务器状态，并可配合客户端 Agent 上报性能数据。

## 主要功能
- 展示服务器在线状态和性能指标
- 支持轻量 Agent 数据上报
- 支持自定义初始管理员账号和密码

## 访问说明
安装后通过 `http://<服务器 IP>:25774` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Komari is a lightweight self-hosted server monitoring dashboard.

## Features
- Display server status and performance metrics
- Receive reports from lightweight agents
- Configure the initial administrator account during installation

## 部署说明
- 本应用使用官方 GitHub Container Registry 镜像 `ghcr.io/komari-monitor/komari` 部署。
- 应用分类：DevOps。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Komari Web 端口 | 25774 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Komari 数据目录，挂载到容器 `/app/data` | ./data | 是 |

升级、迁移或重置管理员账号前，请先备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ADMIN_USERNAME | 初始管理员用户名 | admin | 是 |
| ADMIN_PASSWORD | 初始管理员密码 | 随机生成 | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- `ADMIN_USERNAME` 和 `ADMIN_PASSWORD` 用于首次初始化管理员账号；已有数据库时通常不会覆盖现有账号。
- Komari 用于监控自有或已授权管理的服务器，请勿部署到未授权目标。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 项目仓库: <https://github.com/komari-monitor/komari>
- Docker 部署说明: <https://github.com/komari-monitor/komari#docker-deployment>
