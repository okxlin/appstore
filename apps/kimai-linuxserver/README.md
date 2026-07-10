# Kimai

## 产品介绍
Kimai 是一个开源的时间跟踪系统，适用于个人、团队和项目工时管理。本应用使用 LinuxServer.io 维护的 Kimai 镜像，并配套 MariaDB 数据库。

## 主要功能
- 记录工作时间、客户、项目和活动
- 支持团队、用户权限、发票和报表
- 提供 Web 界面、API 和多语言支持
- 使用独立 MariaDB 服务持久化业务数据

## 访问说明
- Web 入口：安装后通过 `http://<服务器 IP>:<HTTP 端口>` 访问。
- HTTPS 入口：如启用容器内 HTTPS，可通过表单配置的 HTTPS 端口访问。
- 实际端口以安装时填写的 `PANEL_APP_PORT_HTTP` 和 `PANEL_APP_PORT_HTTPS` 为准。

## Introduction
Kimai is an open source time-tracking system for individuals, teams and project-based work. This package uses the Kimai image maintained by LinuxServer.io together with a MariaDB service.

## Features
- Tracks working time, customers, projects and activities
- Supports teams, user permissions, invoices and reports
- Provides a web interface, API and multilingual UI
- Persists application data in a dedicated MariaDB service

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：CRM。
- 支持架构：amd64、arm64。
- 可选版本以应用商店页面为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DB_DATA_PATH | 数据库数据目录 | ./data/db | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DB_PASSWORD | 数据库密码 | kimai-change-me | 是 |
| APP_SECRET | 用于会话和安全令牌的应用密钥 | 安装时随机生成 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| TRUSTED_HOSTS | 允许访问 Kimai 的主机名正则表达式 | .* | 是 |
| TRUSTED_PROXIES | 可信代理 | 127.0.0.1/32 | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- `APP_SECRET` 会在新安装时随机生成；旧版本升级时如缺失或为空，升级脚本会生成并写入现有 `.env`。
- 建议按实际域名或 IP 收紧 `TRUSTED_HOSTS`，使用 `.*` 可保持现有访问方式兼容。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.kimai.org/>
- 文档: <https://docs.linuxserver.io/images/docker-kimai/>
- 源码: <https://github.com/linuxserver/docker-kimai>
