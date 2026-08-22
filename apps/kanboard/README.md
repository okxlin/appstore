# Kanboard

## 产品介绍
Kanboard 是一款专注于看板方法的开源项目管理软件，适合个人和小型团队自托管使用。

## 主要功能
- 可视化看板、任务和泳道管理
- 任务筛选、搜索、分析和自动化操作
- 支持插件扩展以及多种身份验证方式

## 访问说明
安装后通过 `http://<服务器 IP>:8088` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。初始账号和密码均为 `admin`，首次登录后应立即修改密码。

## Introduction
Kanboard is open-source project management software focused on the Kanban methodology.

## Features
- Visual boards, tasks, and swimlanes
- Task filters, search, analytics, and automated actions
- Plugin extensions and multiple authentication methods

## 部署说明
- 本应用采用上游官方单镜像 SQLite 拓扑，使用官方镜像 `kanboard/kanboard`。
- 镜像内由 s6 管理 nginx 和 PHP-FPM；应用限制为单实例，不应横向扩容共享 SQLite 数据目录。
- 仅发布容器 HTTP 端口。证书目录仍按上游契约持久化，但内部 HTTPS 端口不对外发布。
- 可选版本：`latest`；固定版本以应用商店当前版本目录和安装表单为准。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Kanboard Web 端口 | 8088 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | SQLite 数据库、附件和缓存目录 | ./data | 是 |
| APP_PLUGINS_DIR | 插件目录 | ./plugins | 是 |
| APP_CERTS_DIR | 镜像内部 HTTPS 证书目录 | ./certs | 是 |

升级、迁移或卸载前，请同时备份以上三个目录。默认相对目录位于 1Panel 应用安装目录内，卸载时可能随安装目录一起删除。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 默认 SQLite 模式面向单实例部署，不适合多个容器同时写入同一数据库。
- 上游默认关闭 Web 插件安装器。如需安装插件，请按上游安全说明人工管理插件目录。
- 如需对外开放访问，请同步配置防火墙、安全组或反向代理，并在首次登录后修改默认管理员密码。

## 参考资料
- 项目仓库: <https://github.com/kanboard/kanboard>
- Docker 文档: <https://docs.kanboard.org/v1/admin/docker/>
- SQLite Compose: <https://github.com/kanboard/kanboard/blob/v1.2.53/docker-compose.sqlite.yml>
