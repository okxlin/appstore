# WhoDB

## 产品介绍

WhoDB 是一个轻量级多数据库管理工作台，可在浏览器中浏览结构、查询和编辑数据。

## 主要功能

- 支持 PostgreSQL、MySQL、MariaDB、SQLite、MongoDB、Redis 等多种数据库
- 提供数据浏览、查询、关系图、导入和导出
- 可选连接本地或托管的 AI 模型服务
- 将数据库登录会话加密保存在持久化目录中
- 通过独立目录持久化并连接本地 SQLite 或 DuckDB 文件

## 访问说明

安装后通过 `http://<服务器 IP>:8080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction

WhoDB is a lightweight browser workspace for exploring, querying, and editing multiple database systems.

## Features

- Browse schemas and edit data across multiple database engines
- Run queries, inspect relationships, and import or export data
- Optionally connect local or hosted AI providers
- Persist encrypted database login sessions
- Persist and connect local SQLite or DuckDB files through a separate directory

## 部署与安全

- 使用官方 WhoDB Community 镜像 `clidey/whodb`。
- `WHODB_ENCRYPTION_KEY` 默认填写 `generate`，安装脚本会生成并持久保存 64 位十六进制密钥；不要在已有会话时随意更换。
- WhoDB 会保存用户输入的数据库凭据。请保护 `APP_DATA_DIR`、应用 `.env` 和备份，避免提交或共享其中内容。
- WhoDB Community 不提供独立的全局访问登录。不要将端口直接暴露到不受信任的网络；建议通过 VPN、IP 白名单或带认证的 1Panel 反向代理访问。
- 在 HTTPS 反向代理后将 `WHODB_SECURE` 设为 `true`，使浏览器仅通过 HTTPS 发送会话 Cookie。
- 可选 AI 提供商会将用户请求发送到所选外部服务，请自行确认数据边界和凭据权限。

## 数据持久化

`APP_DATA_DIR` 挂载到容器 `/data`，保存加密登录会话和密钥缓存。`DB_DATA_DIR` 挂载到容器 `/db`，保存本地 SQLite 和 DuckDB 文件；在 WhoDB 中填写相对于 `/db` 的文件名（例如 `example.db`）进行连接。升级、迁移或卸载前请备份这两个目录。

`APP_DATA_DIR` is mounted at `/data` for encrypted sessions and the key cache. `DB_DATA_DIR` is mounted at `/db` for local SQLite and DuckDB files; enter a path relative to `/db`, such as `example.db`, in WhoDB. Back up both directories before upgrades, migrations, or uninstalling.

## 参考资料

- 官网: <https://whodb.com/>
- 源码: <https://github.com/clidey/whodb>
- 文档: <https://docs.whodb.com/>
- Docker 持久化说明: <https://github.com/clidey/whodb/blob/main/README.md#docker-with-persistent-sessions>
