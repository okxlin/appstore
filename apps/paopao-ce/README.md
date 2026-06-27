# PaoPao-ce

## 产品介绍
PaoPao-ce 是一个基于 Go 和 Vue 的开源微社区平台，适合自托管社区、轻量社交和产品讨论场景。

## 主要功能
- 发布动态、评论和互动
- 内嵌 Web 前端
- 使用 MySQL、Redis Stack 和 Meilisearch 提供数据、缓存和搜索能力
- 支持本地附件存储

## 访问说明
安装后通过 `http://<服务器 IP>:18088` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

首次安装不会创建默认管理员账号，请打开页面后按界面流程注册首个账号，并及时在应用内完成站点设置。

## Introduction
PaoPao-ce is an open source micro-community platform built with Go and Vue for self-hosted communities, social timelines and product discussions.

## Features
- Posts, comments and social interactions
- Embedded web frontend
- MySQL, Redis Stack and Meilisearch for storage, cache and search
- Local attachment storage

## 部署说明
- 本应用使用官方多服务 Docker Compose 拓扑：PaoPao-ce Backend、MySQL、Redis Stack、Meilisearch。
- 后端镜像固定为 `bitbus/paopao-ce:v0.6.0-alpha.2`。Docker Hub 当前没有发布 `v0.6.0-alpha.3` 后端镜像，且官方 compose 默认的 `0.6-alpha` tag 不存在。
- 当前仅声明 amd64 架构，因为 `bitbus/paopao-ce` 已发布后端镜像为 amd64 单架构。
- 不使用 all-in-one 镜像；该镜像在测试中出现缺少 `groupmod`、`usermod`、`gosu` 且 HTTP 服务未正常启动的问题。
- `crossVersionUpdate` 已关闭，后续升级需要人工确认镜像 tag、数据库兼容性和真实升级测试。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 访问端口 | 18088 | 是 |

## 数据持久化
| 路径 | 说明 |
| --- | --- |
| APP_DATA_DIR/custom | PaoPao 配置、附件和日志 |
| APP_DATA_DIR/mysql | MySQL 数据 |
| APP_DATA_DIR/redis | Redis Stack 数据 |
| APP_DATA_DIR/meili | Meilisearch 数据 |
| APP_DATA_DIR/initdb | MySQL 首次初始化 SQL |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PUBLIC_DOMAIN | 本地附件公开访问主机，通常为 `服务器 IP:端口` 或反代域名 | 127.0.0.1:18088 | 是 |
| MYSQL_PASSWORD | MySQL 数据库密码 | 随机生成 | 是 |
| JWT_SECRET | JWT 签名密钥 | 随机生成 | 是 |
| MEILI_MASTER_KEY | Meilisearch 主密钥 | 随机生成 | 是 |

## 使用说明
- 后端容器首次启动时只在 `APP_DATA_DIR/custom/config.yaml` 不存在时生成配置文件，不会覆盖用户后续修改。
- MySQL 初始化 SQL 会复制到 `APP_DATA_DIR/initdb/paopao.sql`，仅在 MySQL 数据目录首次初始化时执行。
- 仅暴露 PaoPao Web 端口；MySQL、Redis Stack 和 Meilisearch 不对外暴露。
- 如果通过反向代理或域名访问，请将 `PUBLIC_DOMAIN` 设置为最终访问主机，不要包含 `http://` 或 `https://`。

## 参考资料
- 项目仓库: <https://github.com/rocboss/paopao-ce>
- 官方 compose: <https://github.com/rocboss/paopao-ce/blob/v0.6.0-alpha.2/docker-compose.yaml>
- 安装文档: <https://github.com/rocboss/paopao-ce/blob/main/INSTALL_ZH.md>
