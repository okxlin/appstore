# Next Terminal

## 产品介绍
一个简单好用安全的交互审计系统，支持 RDP、SSH、VNC、Telnet、Kubernetes 等协议。

当前应用包按 Next Terminal 官方容器部署方式提供 Next Terminal、Guacd 和 PostgreSQL 服务。安装脚本会在数据目录中生成 `config.yaml`，并保留已经存在的配置文件。

## 主要功能
- 管理和审计 RDP、SSH、VNC、Telnet、Kubernetes 等远程连接。
- 使用 Guacd 提供远程桌面协议支持。
- 使用内置 PostgreSQL 保存应用数据。
- 持久化配置、日志、录屏和数据库数据。
- Web UI 与 SSH 代理端口可在 1Panel 表单中配置。

## 访问说明
安装完成后，通过应用表单中的 Web UI 端口访问：

```text
http://<服务器 IP>:<Web UI 端口>
```

`SSH 代理端口` 仅在 Next Terminal 后台启用 SSH 代理服务后使用。升级或迁移前，请先在 1Panel 中备份应用数据目录。

## Introduction
Next Terminal is a simple and secure interactive audit system supporting RDP, SSH, VNC, Telnet, Kubernetes, and related remote access protocols.

This package follows the official container deployment model and includes Next Terminal, Guacd, and PostgreSQL. The install script generates `config.yaml` in the data directory and preserves an existing config file.

## Features
- Manage and audit RDP, SSH, VNC, Telnet, Kubernetes, and related remote sessions.
- Use Guacd for remote desktop protocol support.
- Store application data in the bundled PostgreSQL service.
- Persist config, logs, recordings, and database files.
- Configure Web UI and SSH proxy ports from the 1Panel form.

## 应用简介
一个简单好用安全的交互审计系统，支持 RDP、SSH、VNC、Telnet、Kubernetes 等协议。

英文说明：A simple and secure interactive audit system supporting RDP, SSH, VNC, Telnet, Kubernetes, and related remote access protocols.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 当前容器版本需要 `config.yaml` 和 PostgreSQL；安装脚本会在数据目录中自动生成 `config.yaml`。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.1.1`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web UI 端口 | 40058 | 是 |
| PANEL_APP_PORT_SSH | SSH 代理端口，需在 Next Terminal 后台启用 SSH 代理服务器 | 40059 | 否 |

## 数据持久化
| 路径 | 说明 |
| --- | --- |
| `DATA_PATH` | Next Terminal 数据、日志、`config.yaml` 和内置 PostgreSQL 数据目录 |
| `DATA_PATH/postgresql` | PostgreSQL 数据目录 |
| `DATA_PATH/logs` | Next Terminal 日志目录 |

升级或迁移前，请在 1Panel 中备份应用数据目录。

## 数据库
当前应用包按官方容器部署方式内置 PostgreSQL 服务，并通过 `PANEL_DB_NAME`、`PANEL_DB_USER`、`PANEL_DB_USER_PASSWORD` 初始化数据库。

## 升级注意
Next Terminal 上游历史版本存在不兼容迁移，旧的 SQLite/单容器部署不能保证无缝升级到当前 PostgreSQL 部署。应用包已关闭跨版本升级；如需迁移旧数据，请先按官方文档导出/备份，再在新部署中恢复。

## 参考资料
- 官网: <https://next-terminal.typesafe.cn/>
- 文档: <https://docs.next-terminal.typesafe.cn/>
- 源码: <https://github.com/dushixiang/next-terminal>
