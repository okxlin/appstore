# Teldrive

## 产品介绍
Teldrive 是一个自托管 Telegram 文件管理工具，可以通过网页界面整理 Telegram 文件，并支持与 Rclone 等工作流配合使用。

## 主要功能
- 管理 Telegram 频道中的文件
- 提供网页界面进行浏览和操作
- 支持加密上传数据和限制允许登录的 Telegram 用户

## 访问说明
安装后通过 `http://<服务器 IP>:18080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Teldrive is a self-hosted tool for organizing Telegram files through a web interface.

## Features
- Manage files stored in Telegram channels
- Provide a browser-based management interface
- Support upload encryption and allowed Telegram user restrictions

## 部署说明
- 本应用使用官方容器镜像 `ghcr.io/tgdrive/teldrive` 部署。
- PostgreSQL 使用 Teldrive 官方 compose 中的 `ghcr.io/tgdrive/postgres:17-alpine` 镜像。
- 应用分类：存储。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 18080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Teldrive 数据目录，包含 PostgreSQL 数据和本地 `storage.db` 文件 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |
| POSTGRES_PASSWORD | PostgreSQL 数据库密码 | 随机生成 | 是 |
| JWT_SECRET | JWT 登录密钥 | 随机生成 | 是 |
| UPLOADS_ENCRYPTION_KEY | 上传数据加密密钥 | 随机生成 | 是 |
| ALLOWED_USERS | 允许登录的 Telegram 用户名，多个用户按上游支持格式填写 | 空 | 否 |
| TG_NTP | 启用 Telegram NTP 时间同步 | false | 是 |

## 使用说明
- 首次访问后需要使用 Telegram 账号登录，并在界面设置中同步频道和默认频道。
- 如登录停留在登录页，请检查服务器时间同步；也可以在安装参数中启用 `TG_NTP`。
- `ALLOWED_USERS` 用于限制可登录的 Telegram 用户名，不需要填写 `@`。
- 已对“复用 1Panel 商店 PostgreSQL runtime”做过真实联动复核，但 Teldrive 当前数据库迁移依赖 `pgroonga` 扩展；标准 `postgresql` 运行时不提供该扩展，启动时会在 `20240711163538_search.sql` 迁移阶段失败。
- 也额外验证了“补 local app 数据库 runtime 再联动”的路径：一次独立 `localmysql` smoke 中，本地数据库 app 虽然能成功安装并运行，但 `/apps/services/mysql` 返回空，`databases` 资源表也没有生成可复用记录。结合当前 1Panel local app 同步会把数据库 app key 变成 `local...`、而数据库资源登记仍走未加前缀常量的实现路径，这里可以合理推断 local PostgreSQL runtime 目前也不能直接作为 Teldrive 的可选数据库服务。因此当前继续保留上游自带的 `ghcr.io/tgdrive/postgres:17-alpine` 拓扑，而不是切换到商店或 local app PostgreSQL。

## 参考资料
- 官网: <https://teldrive-docs.pages.dev/>
- 项目仓库: <https://github.com/tgdrive/teldrive>
- Docker 使用说明: <https://github.com/tgdrive/teldrive-docs/blob/main/docs/getting-started/usage.md#running-with-docker>
- 官方 compose: <https://github.com/tgdrive/teldrive/blob/main/docker/compose/teldrive.yml>
