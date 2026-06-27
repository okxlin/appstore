# beancount-gs

## 产品介绍
beancount-gs 是基于 beancount 的个人记账 API 服务，并内置 Web 管理界面，适合以文本账本为核心的个人财务管理。

## 主要功能
- 提供 beancount 账本的 RESTful API
- 内置移动端友好的 Web 管理界面
- 持久化账本、图标、配置、备份和日志

## 访问说明
安装后通过 `http://<服务器 IP>:10000` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
beancount-gs is a personal accounting API and web interface based on beancount.

## Features
- RESTful API for beancount ledger data
- Built-in mobile-friendly web interface
- Persistent ledger, icon, config, backup and log directories

## 部署说明
- 本应用使用官方文档中的 Docker 镜像 `xdbin/beancount-gs` 部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 10000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 账本、图标、配置、备份和日志的根目录 | ./data | 是 |

容器内挂载路径包括 `/data/beancount`、`/app/public/icons`、`/app/config`、`/app/bak` 和 `/app/logs`。升级或迁移前，请先备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 首次安装后请在 Web 界面内完成账本和配置初始化。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 项目仓库: <https://github.com/BaoXuebin/beancount-gs>
- Docker Compose: <https://github.com/BaoXuebin/beancount-gs/blob/main/docker-compose.yml>
