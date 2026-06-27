# Fider

## 产品介绍
Fider 是开源用户反馈平台，可用于收集需求建议、投票排序、讨论反馈并展示产品路线图。

## 主要功能
- 收集用户反馈、需求和问题建议
- 支持用户投票、评论和状态跟踪
- 支持邮件验证和通知，适合自托管产品反馈门户

## 访问说明
安装后通过 `http://<服务器 IP>:15081` 访问 Fider，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。默认内置 MailHog 用于捕获测试邮件，Web UI 端口以 `PANEL_APP_PORT_MAILHOG` 为准。

## Introduction
Fider is an open source platform for collecting user feedback, voting on ideas, discussing requests and sharing product roadmaps.

## Features
- Collect feedback, requests and product ideas
- Supports voting, comments and status tracking
- Includes email verification and notifications for self-hosted feedback portals

## 部署说明
- 本应用使用官方 Docker 镜像 `getfider/fider:stable`、官方文档推荐的 `postgres:17`，并按官方测试 SMTP 说明内置 MailHog。
- 应用分类：CRM。
- 支持架构：amd64。Fider 和 Postgres 支持 arm64，但默认内置的 `mailhog/mailhog` 镜像为 amd64 单架构。
- 可选版本：`latest`，对应 Fider stable channel。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Fider Web 访问端口，容器内映射到 `3000` | 15081 | 是 |
| PANEL_APP_PORT_MAILHOG | MailHog Web UI 端口，容器内映射到 `8025` | 18025 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Fider PostgreSQL 数据目录，数据库数据保存在 `APP_DATA_DIR/postgres` | ./data | 是 |

升级、迁移或重新安装前，请先在 1Panel 中备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| BASE_URL | Fider 对外访问地址，必须与实际访问协议、域名和端口一致 | http://localhost:15081 | 是 |
| POSTGRES_PASSWORD | 内置 PostgreSQL 密码，安装时随机生成 | 随机生成 | 是 |
| JWT_SECRET | Fider JWT 密钥，安装时随机生成 | 随机生成 | 是 |
| EMAIL_NOREPLY | 发信邮箱地址 | noreply@example.com | 是 |
| EMAIL_SMTP_HOST | SMTP 主机，默认指向内置 MailHog | fider-mailhog | 是 |
| EMAIL_SMTP_PORT | SMTP 端口 | 1025 | 是 |
| EMAIL_SMTP_USERNAME | SMTP 用户名 | 空 | 否 |
| EMAIL_SMTP_PASSWORD | SMTP 密码 | 空 | 否 |
| EMAIL_SMTP_ENABLE_STARTTLS | 是否启用 SMTP STARTTLS，使用 MailHog 时保持 `false` | false | 是 |
| EMAIL_SMTP_ENABLE_IMPLICIT_TLS | 是否启用 SMTP 隐式 TLS | false | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 首次创建站点和管理员账号时，Fider 会发送验证邮件；默认测试邮件会进入 MailHog，可在服务器本机、受信网络或临时安全入口查看 MailHog Web UI。
- 内置 MailHog 适合本地测试和首次验证，不适合作为生产发信服务，也不建议长期公网暴露。正式对外使用前，请把 SMTP 参数改成真实邮件服务，并确认 `BASE_URL` 为真实公开地址。
- 如果通过反向代理或 HTTPS 对外开放，请同步更新 `BASE_URL`，并检查防火墙、安全组和反向代理配置。
- Fider 官方文档提供的重置 SQL 会删除租户、用户、帖子、投票和评论数据；只在确认需要完全重置实例时使用。

## 参考资料
- 官网: <https://fider.io>
- 项目仓库: <https://github.com/getfider/fider>
- Docker 托管文档: <https://fider.io/hosting-instance>
- Dockerfile: <https://github.com/getfider/fider/blob/main/Dockerfile>
