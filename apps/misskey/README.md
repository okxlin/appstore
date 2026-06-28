# Misskey

## 产品介绍
Misskey 是一个基于 ActivityPub 的开源联邦社交网络平台，可用于搭建个人或社区实例。

## 主要功能
- 发布笔记、图片和互动内容
- 与 ActivityPub 联邦网络互通
- 支持主题、插件、角色和实例管理

## 访问说明
安装后通过 `http://<服务器 IP>:18091` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Misskey is an open source federated social media platform powered by ActivityPub.

## Features
- Publish notes, images and interactive content
- Federate with other ActivityPub servers
- Manage themes, plugins, roles and instance settings

## 部署说明
- 本应用使用官方 `misskey/misskey:2026.6.0` 镜像，并按官方 Docker Compose 示例内置 PostgreSQL 与 Redis。
- 可选的 Meilisearch、mCaptcha 等服务默认不启用，降低默认部署复杂度和暴露面。
- 应用分类：Website。
- 支持架构：amd64、arm64。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 18091 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Misskey 配置、文件、PostgreSQL 和 Redis 数据目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MISSKEY_URL | 用户最终访问的公开地址 | http://localhost:18091/ | 是 |
| POSTGRES_PASSWORD | PostgreSQL 数据库密码 | 随机生成 | 是 |
| MISSKEY_SETUP_PASSWORD | 首次创建管理员时使用的设置密码 | 随机生成 | 是 |

## 使用说明
- 首次访问后，使用安装表单中的 `MISSKEY_SETUP_PASSWORD` 完成管理员初始化。
- 生产环境建议把 `MISSKEY_URL` 设置为真实 HTTPS 访问地址，并在 1Panel 或外部反向代理中配置 HTTPS。
- Misskey 官方配置说明提醒：实例启动后不要随意修改最终访问 URL，否则会影响联邦身份和已生成的链接。
- 默认全文搜索使用 PostgreSQL 的 `sqlLike` 模式；未内置 Meilisearch。
- 当前版本固定为 `2026.6.0`，未加入 Renovate 自动合并白名单。升级前应阅读 Misskey release notes，备份数据，并确认数据库迁移兼容性。

## 参考资料
- 官网: <https://misskey-hub.net/>
- 项目仓库: <https://github.com/misskey-dev/misskey>
- 官方 Compose 示例: <https://github.com/misskey-dev/misskey/blob/develop/compose_example.yml>
- 官方 Docker 配置示例: <https://github.com/misskey-dev/misskey/blob/develop/.config/docker_example.yml>
