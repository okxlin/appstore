# SQLPage

## 产品介绍

SQLPage 是一个使用 Rust 编写的 SQL 驱动动态网站构建器。页面由 `.sql` 文件定义，查询结果会被渲染为表单、列表、图表等界面组件。默认包使用单容器 SQLite 拓扑，不依赖外部数据库。

## 主要功能

- 使用 SQL 文件构建表单、列表、图表和动态页面
- 默认使用 SQLite，也支持 PostgreSQL、MySQL、SQL Server 和 ODBC 数据源
- 支持迁移、文件上传、自定义组件和可选 OIDC 认证
- 提供官方 Todo 示例用于验证完整的写入和读取流程

### 默认示例

安装时会在空的数据目录中写入 SQLPage 官方 Todo 示例。可通过网页新增、编辑和删除待办事项，数据保存在 SQLite 数据库中。初始化只补充缺失的示例文件，不会覆盖已有文件。

## 访问说明

- 默认通过 `127.0.0.1:8080` 发布，适合经 1Panel HTTPS 反向代理访问。
- Todo 示例没有身份认证。公开访问前应替换示例、配置 OIDC 或应用级授权，并在反向代理层设置访问控制和请求速率限制。
- `sqlpage.exec`、危险 Markdown HTML 和危险 URL 协议默认禁用。
- 容器以 UID/GID `1000:1000` 运行，使用只读根文件系统、受限临时目录，并丢弃全部 Linux capabilities。

## 数据与定制

- `APP_DATA_DIR` 映射到 `/var/www`，保存 SQL 页面文件和 `sqlpage.db`。
- 包内 `/etc/sqlpage` 配置以只读方式挂载，使用 `sqlite:///var/www/sqlpage.db?mode=rwc`。
- 修改数据目录中的 `.sql` 文件即可定制站点。升级前应备份整个数据目录。
- 如选择既有绝对数据目录，请先将其所有权设置为 `1000:1000`。

## Introduction

SQLPage is a Rust-based dynamic website builder driven by SQL. Pages are defined as `.sql` files, and query results render as forms, lists, charts, and other interface components. The default package uses a single-container SQLite topology with no external database.

## Features

- Build forms, lists, charts, and dynamic pages from SQL files
- Use SQLite by default, with optional PostgreSQL, MySQL, SQL Server, and ODBC data sources
- Support migrations, file uploads, custom components, and optional OIDC authentication
- Start with the official Todo example for a complete write and read workflow

## Usage And Security

- A clean install seeds SQLPage's official Todo example without overwriting existing files.
- The starter is unauthenticated. Replace it or configure OIDC or application-level authorization before public exposure, and enforce access control and rate limits at the reverse proxy.
- The default bind address is `127.0.0.1`, intended for publication through a 1Panel HTTPS reverse proxy.
- Dangerous execution and Markdown options remain disabled by default.

## Persistence

- `APP_DATA_DIR` is mounted at `/var/www` and stores the SQL pages plus `sqlpage.db`.
- The container runs as UID/GID `1000:1000` with a read-only root filesystem, a constrained temporary directory, and all Linux capabilities dropped.
- Back up the complete data directory before upgrades or migration.

## References

- Project: <https://github.com/sqlpage/SQLPage>
- Stable release: <https://github.com/sqlpage/SQLPage/releases/tag/v0.45.0>
- Docker documentation: <https://github.com/sqlpage/SQLPage#with-docker>
- Configuration: <https://github.com/sqlpage/SQLPage/blob/v0.45.0/configuration.md>
- Starter source: <https://github.com/sqlpage/SQLPage/tree/v0.45.0/examples/todo%20application>
- License: <https://github.com/sqlpage/SQLPage/blob/v0.45.0/LICENSE.txt> (MIT)
