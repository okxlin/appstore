# LibreDB Studio

## 产品介绍

LibreDB Studio 是一个 MIT 许可、自托管、基于浏览器的数据库 IDE，27 种驱动覆盖 PostgreSQL、MySQL、Oracle、Db2 LUW、SQL Server、SQLite、MongoDB、Redis、ClickHouse 等 54 种引擎（另有 27 种引擎使用相同协议，通过已有驱动连接）。按上游 `docs/DATABASE_PROVIDERS.md` 的驱动表，27 种驱动中有 10 种只发送读取请求；其中 Druid、Elasticsearch 和 OpenSearch 的语法里完全没有 `UPDATE` 和 `CREATE TABLE`，只能查询和浏览。首次启动时管理员密码会打印到容器日志（零配置）。

这里列出的数据库引擎是应用连接目标，应用商店包本身只运行 LibreDB Studio，不会自动安装 PostgreSQL、Redis 或其他数据库服务。

## 主要功能

- 一个浏览器界面接入 27 种数据库驱动，27 种中有 10 种为只读
- SSO (OIDC)、RBAC 与查询审计日志（免费版内置）
- ER 图、EXPLAIN 可视化、模式对比，在支持这些功能的引擎上可用

## 访问说明

- 默认端口 3000（PANEL_APP_PORT_HTTP）
- 安装后访问：http://<server-ip>:<port>
- 首次登录密码见容器日志

## 数据与升级

- `APP_DATA_DIR_1` 可以是相对路径，也可以是绝对路径。绝对路径会保留在应用目录之外，因此已设置绝对路径的安装保留原目录，不需要迁移数据；0.16.1 的脚本会拒绝所有绝对路径并中断升级。相对路径须以点开头，如 `./data`。被拒绝的值会说明原因，`scripts/init.sh` 里列出了全部规则。
- 本包使用 `STORAGE_PROVIDER=sqlite`，因此处于 0.18.1 所修复问题的影响范围内（共享浏览器配置文件时工作区在账户之间泄露，含已保存的连接凭据和查询历史，影响 0.8.0 到 0.18.0）。本包不设置 `ADMIN_PASSWORD`，首次启动写入 `auth-bootstrap.json` 的密码升级后继续有效；升级会让已登录用户退出一次，之前签发的 MCP 令牌需要重新创建。SQLite 连接现在只对管理员开放。

## Introduction

LibreDB Studio is an MIT-licensed, self-hosted, browser-based database IDE and client. 27 drivers reach 54 named engines, because 27 further engines speak one of the same wire protocols. Per the provider table in upstream `docs/DATABASE_PROVIDERS.md`, 10 of the 27 drivers send only read requests; on Druid, Elasticsearch and OpenSearch that is the engine's own doing, since no `UPDATE` and no `CREATE TABLE` is in their grammar at all, so you query and browse there rather than manage.

The listed database engines are connection targets. This AppStore package runs LibreDB Studio as a single service and does not provision PostgreSQL, Redis, or other database servers.

## Features

- One browser interface for 27 database drivers, 10 of the 27 read-only
- SSO (OIDC), RBAC and query audit logs in the free build
- ER diagrams, EXPLAIN visualization and schema comparison, on the engines that support them
- On first run the admin password is printed to the container log (zero-config). Default port 3000.

## Data and upgrades

- `APP_DATA_DIR_1` takes a relative path or an absolute one. An absolute path is kept outside the app directory, so an installation that already holds one keeps its directory and nothing is migrated; the 0.16.1 script refused every absolute value and stopped the upgrade. A relative path has to begin with a dot, as `./data` does. A refused value says why, and `scripts/init.sh` carries the full set of rules.
- This package runs `STORAGE_PROVIDER=sqlite`, so it is in range of the workspace leak between accounts sharing a browser profile that 0.18.1 fixed, affecting 0.8.0 through 0.18.0. It sets no `ADMIN_PASSWORD`, so the password written to `auth-bootstrap.json` on first run keeps working after the upgrade; the upgrade signs local users out once and invalidates MCP tokens issued before it. A SQLite connection now opens for an admin only.

## 参考资料

- 官网: <https://libredb.org>
- 源码: <https://github.com/libredb/libredb-studio>
