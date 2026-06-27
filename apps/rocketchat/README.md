# Rocket.Chat

## 产品介绍
Rocket.Chat 是一套开源团队通信协作平台，支持频道、私聊、用户管理、集成和工作区协作。

## 主要功能
- 创建团队频道和私聊会话
- 管理工作区用户、角色和权限
- 支持机器人、Webhook 和应用集成

## 访问说明
安装后通过安装表单中的 `ROOT_URL` 访问。默认地址为 `http://<服务器 IP>:18087`，实际端口以 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Rocket.Chat is an open source team communication platform for channels, direct messages, user management, integrations and workspace collaboration.

## Features
- Create team channels and direct messages
- Manage workspace users, roles and permissions
- Use bots, webhooks and app integrations

## 部署说明
- 本应用基于官方 `rocketchat-compose` 的核心服务适配，包含 Rocket.Chat、MongoDB 单节点复制集和 NATS。
- 当前固定使用 `registry.rocket.chat/rocketchat/rocket.chat:8.0.1`、`mongodb/mongodb-community-server:8.2-ubi8` 和 `nats:2.11-alpine`。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`，但镜像版本固定，避免自动跨版本升级。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 18087 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | MongoDB 数据目录 | ./data | 是 |

升级、迁移或修改 MongoDB/Rocket.Chat 版本前，请先在 1Panel 中备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ROOT_URL | Rocket.Chat 对外访问地址，必须和真实访问协议、域名或端口保持一致 | http://127.0.0.1:18087 | 是 |
| REG_TOKEN | Rocket.Chat Cloud 注册令牌，没有可留空 | 空 | 否 |
| ADMIN_USERNAME | 初始管理员用户名 | admin | 是 |
| ADMIN_NAME | 初始管理员显示名 | Admin | 是 |
| ADMIN_EMAIL | 初始管理员邮箱 | admin@example.com | 是 |
| ADMIN_PASS | 初始管理员密码 | 随机生成 | 是 |

## 使用说明
- 首次访问后，使用安装表单中的初始管理员信息登录并完成工作区设置。
- 生产环境建议使用真实域名和 HTTPS 反向代理，并将 `ROOT_URL` 设置为最终访问地址。
- Rocket.Chat 官方建议生产环境固定版本，不要使用浮动的 `latest` 标签。
- Rocket.Chat 升级前必须阅读目标版本发布说明，确认 MongoDB 兼容版本，并按版本顺序升级；不要跳过大版本。
- 本应用未加入 Renovate 自动合并白名单，后续升级需要人工审计 MongoDB、NATS 和 Rocket.Chat 版本兼容性，并执行真实升级测试。

## 参考资料
- 官网: <https://www.rocket.chat/>
- 项目仓库: <https://github.com/RocketChat/Rocket.Chat>
- 官方 Docker Compose 文档: <https://docs.rocket.chat/docs/deploy-with-docker-docker-compose>
- 官方 Compose 仓库: <https://github.com/RocketChat/rocketchat-compose>
- 初始管理员文档: <https://docs.rocket.chat/docs/admin-account-creation>
- 安全升级指南: <https://docs.rocket.chat/docs/guidelines-for-updating-rocketchat>
