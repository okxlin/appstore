# Password Pusher

## 产品介绍

Password Pusher 是一个通过网络传递密码的开源 Web 应用。本应用商店适配使用 PostgreSQL 保存数据，并将本地文件上传持久化到 Docker 卷。

## 主要功能

- 创建带有效期和查看次数限制的密码推送。
- 通过链接安全地分享密码内容。
- 将本地上传文件保存在持久化存储中。

## 访问说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`release`；固定版本以应用商店当前版本目录和安装表单为准。
- 安装后按应用表单中的端口访问 Web UI。

## 重要：MySQL/MariaDB 老用户升级

`2.17.3` 和 `release` 适配使用 PostgreSQL。Password Pusher 已弃用 MySQL/MariaDB；其 ActiveStorage 迁移在 MySQL/MariaDB 上可能因外键列类型不兼容而失败。

如果现有实例使用 MySQL/MariaDB，**不要直接升级或只切换数据库服务**。升级前请先停用应用并备份完整数据库、应用容器中的 `/opt/PasswordPusher/storage` 文件目录，以及任何自定义的 `PWPUSH_MASTER_KEY`。按 [Password Pusher 官方迁移指南](https://docs.pwpush.com/docs/mysql-to-postgresql-migration/) 使用 pgloader 将数据单向迁移到 PostgreSQL，再在 1Panel 升级表单中选中迁移后的 PostgreSQL 服务，并填写目标数据库的名称、用户和密码。

如果旧实例有文件推送，更新后的包会创建名为 `passwordpusher-storage` 的持久卷，但**不会自动把旧容器里的文件复制进去**。请在启动新版本前将旧容器 `/opt/PasswordPusher/storage` 中的文件备份并恢复到新卷，并确保已有文件允许容器 UID/GID `1000:1000` 读写；启动过程只会为全新的空卷设置目录所有者，不会递归修改已有文件。若设置过自定义 `PWPUSH_MASTER_KEY`，请在升级表单填回同一个密钥；更换密钥会使旧推送无法解密。迁移后确认旧推送可解密、附件可读取并能创建新推送；验证完成前保留旧数据库备份、容器和存储目录。

更换数据库不会自动搬运数据。若未完成迁移，新 PostgreSQL 数据库会是空库。未自定义加密密钥的用户可保留空值，应用会使用其默认密钥。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40180 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | postgresql | 是 |
| PANEL_DB_HOST | PostgreSQL 服务 | 由 1Panel 选择 | 是 |
| PANEL_DB_PORT | PostgreSQL 端口 | 5432 | 是 |
| PANEL_DB_NAME | 数据库名 | passwordpusher | 是 |
| PANEL_DB_USER | 数据库用户 | passwordpusher | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | 由 1Panel 生成 | 是 |
| PWPUSH_MASTER_KEY | 自定义推送加密密钥 | 空（使用应用默认密钥） | 否 |

- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 安装时选择可用的 PostgreSQL 服务，并填写数据库名、用户和密码。
- 从旧实例迁移时，数据库名、用户和密码须与迁入 PostgreSQL 的目标库一致。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://pwpush.com>
- 文档: <https://docs.pwpush.com>
- 源码: <https://github.com/pglombardo/PasswordPusher>
- MySQL/MariaDB 迁移指南: <https://docs.pwpush.com/docs/mysql-to-postgresql-migration/>
