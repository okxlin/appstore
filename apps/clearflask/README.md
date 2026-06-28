# ClearFlask

## 产品介绍
ClearFlask 是一个开源用户反馈管理平台，可用于收集需求、投票排序、发布路线图和更新记录。

## 主要功能
- 收集用户反馈和产品需求
- 支持投票、路线图和更新日志
- 提供管理后台和公开反馈入口

## 访问说明
安装后通过 `http://<服务器 IP>:18087` 访问 ClearFlask，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

默认同时启动 Mailpit 测试邮箱，可通过 `http://<服务器 IP>:18028` 查看首次注册/登录邮件，实际端口以 `PANEL_APP_PORT_MAILPIT` 为准。

## Introduction
ClearFlask is an open source feedback management platform for collecting ideas, voting on requests and publishing product roadmaps.

## Features
- Collect product feedback and feature requests
- Support voting, roadmaps and changelogs
- Provide an admin dashboard and public feedback portal

## 部署说明
- 本应用使用官方 ClearFlask `2.3.1` server/connect 镜像，并沿用官方 self-host 依赖拓扑：MariaDB 和 LocalStack。
- 默认使用 Mailpit 作为本地测试 SMTP，方便首次安装后查看注册/登录邮件。
- 应用分类：CRM。
- 支持架构：amd64、arm64。
- 可选版本：`latest`，当前固定使用 ClearFlask 2.3.1 镜像；由于官方配置项和依赖较多，不建议自动跨版本升级。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | ClearFlask HTTP 访问端口 | 18087 | 是 |
| PANEL_APP_PORT_MAILPIT | Mailpit 邮件查看端口 | 18028 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | ClearFlask 配置、密钥、MariaDB 和 LocalStack 数据目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CLEARFLASK_DOMAIN | 对外访问域名或主机名，不含协议 | localhost | 是 |
| CLEARFLASK_SUPER_ADMIN_EMAIL_REGEX | 可创建管理员账号的邮箱正则 | ^admin@localhost$ | 是 |
| CLEARFLASK_SIGNUP_ENABLED | 是否允许账号注册 | true | 是 |
| CLEARFLASK_AUTH_COOKIE_SECURE | 使用 HTTPS 反向代理后可改为 true | false | 是 |
| MYSQL_ROOT_PASSWORD | MariaDB root 密码 | 随机生成 | 是 |
| EMAIL_SERVICE | 邮件服务，默认 smtp | smtp | 是 |
| SMTP_STRATEGY | SMTP、SMTP_TLS 或 SMTPS | SMTP | 是 |
| SMTP_HOST | SMTP 主机，默认指向内置 Mailpit | clearflask-mailpit | 是 |
| SMTP_PORT | SMTP 端口 | 1025 | 是 |
| SMTP_USER | SMTP 用户名 | 空 | 否 |
| SMTP_PASSWORD | SMTP 密码 | 空 | 否 |
| SMTP_DISPLAY_NAME | 发件名称 | ClearFlask | 是 |
| SMTP_FROM_LOCAL_PART | 发件邮箱前缀 | noreply | 是 |
| SMTP_FROM_DOMAIN_OVERRIDE | 发件邮箱域名 | localhost | 是 |

## 使用说明
- 首次访问后，使用符合 `CLEARFLASK_SUPER_ADMIN_EMAIL_REGEX` 的邮箱注册；默认可使用 `admin@localhost`。
- 默认 Mailpit 只适合本地验证和首次安装，不建议长期公网暴露；正式使用前请改为真实 SMTP 服务。
- 如果通过 HTTPS 反向代理访问，请将 `CLEARFLASK_DOMAIN` 改成实际域名，并将 `CLEARFLASK_AUTH_COOKIE_SECURE` 改为 `true`。
- 本应用会在首次启动时生成并持久化 ClearFlask server/connect 通信密钥、SSO 密钥、cursor 密钥和 token signer；后续重启会复用同一组密钥。

## 参考资料
- 官网: <https://clearflask.com/>
- 项目仓库: <https://github.com/clearflask/clearflask>
- 官方自托管说明: <https://github.com/clearflask/clearflask#self-hosting>
- 官方 Docker Compose: <https://github.com/clearflask/clearflask/blob/master/clearflask-release/src/main/docker/compose/docker-compose.self-host.yml>
- 官方 Helm 配置: <https://github.com/clearflask/clearflask/tree/master/clearflask-helm/charts/clearflask>
- Mailpit: <https://github.com/axllent/mailpit>
