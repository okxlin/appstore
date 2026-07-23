# Chatwoot

## 产品介绍
Chatwoot 是一个开源全渠道客户支持平台，可用于在线客服、邮件收件箱、客户会话和帮助台流程。

## 主要功能
- 在线客服和网站聊天组件
- 多收件箱客户沟通
- 团队协作、分派和会话管理
- 本地文件存储、PostgreSQL 数据库和 Redis 队列

## 访问说明
安装后通过 `http://<服务器 IP>:18086` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Chatwoot is an open source omnichannel customer support platform for live chat, email inboxes, customer conversations and helpdesk workflows.

## Features
- Live chat and website inboxes
- Omnichannel customer conversations
- Team assignment and conversation management
- Local file storage with PostgreSQL and Redis

## 部署说明
- 本应用使用官方 Docker 镜像 `chatwoot/chatwoot:v4.15.1-ce`。
- 官方生产 compose 使用 Rails Web、Sidekiq Worker、PostgreSQL 和 Redis；本适配保留相同拓扑，并使用 `pgvector/pgvector:pg16`。
- 安装和后续升级时，Web 容器会在启动 Rails Server 前执行官方要求的 `rails db:chatwoot_prepare`，Worker 会等待 Web 健康检查通过后再启动。
- 应用分类：CRM。
- 支持架构：amd64、arm64。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口，映射到容器内 `3000` | 18086 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Chatwoot 上传文件、PostgreSQL 数据和 Redis 数据目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| FRONTEND_URL | 对外访问地址，生产环境建议填写反向代理后的 HTTPS 域名 | http://1.2.3.4:18086 | 是 |
| SECRET_KEY_BASE | Rails 签名密钥，安装后不要随意更换 | 随机生成 | 是 |
| POSTGRES_PASSWORD | PostgreSQL 数据库密码 | 随机生成 | 是 |
| REDIS_PASSWORD | Redis 密码 | 随机生成 | 是 |
| ENABLE_ACCOUNT_SIGNUP | 是否允许注册账号 | true | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 首次安装后，通过 Web 页面创建管理员账号。
- 若实例暴露到公网，建议创建首个管理员后将 `ENABLE_ACCOUNT_SIGNUP` 改为 `false`，避免开放注册。
- 生产环境建议在 1Panel 或外部反向代理中配置 HTTPS，并将 `FRONTEND_URL` 改为实际 HTTPS 地址。
- 官方文档说明，升级 Chatwoot 镜像后需要再次运行 `rails db:chatwoot_prepare`；本应用会在 Web 容器启动前自动执行该步骤。
- 如果未来从较老版本升级，官方建议按中间版本逐步升级，并阅读各版本 release notes。

## 安全风险
- Chatwoot 官方镜像包含 Rails、Node.js 和完整的基础系统运行环境，漏洞扫描器可能报告继承自这些组件的 High 或 Critical 漏洞；升级可以减少已知风险，但不代表镜像不存在漏洞。
- 部署前请重新扫描目标镜像，持续跟踪上游安全更新，并避免将未配置 HTTPS 和访问控制的实例直接暴露到公网。

## Security Risks
- The official Chatwoot image includes Rails, Node.js, and a complete base-system runtime. Image scanners may report High or Critical vulnerabilities inherited from these components; upgrading can reduce known risk but does not make the image vulnerability-free.
- Re-scan the target image before deployment, track upstream security updates, and do not expose an instance publicly without HTTPS and access controls.

## 参考资料
- 官网: <https://www.chatwoot.com/>
- 项目仓库: <https://github.com/chatwoot/chatwoot>
- Docker 部署文档: <https://developers.chatwoot.com/self-hosted/deployment/docker>
- 环境变量文档: <https://developers.chatwoot.com/self-hosted/configuration/environment-variables>
