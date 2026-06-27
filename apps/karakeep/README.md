# Karakeep

## 产品介绍
Karakeep 是一个自托管的书签、笔记和网页归档应用，支持保存网页、图片、文本内容，并提供全文搜索、浏览器扩展和移动端分享入口。

## 主要功能
- 保存链接、笔记、图片和网页内容
- 通过 Meilisearch 提供全文搜索
- 使用 Chrome sidecar 抓取动态网页、截图和归档内容
- 可选配置 OpenAI API Key 启用自动标签等 AI 功能

## 访问说明
安装后通过 `http://<服务器 IP>:13000` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

`NEXTAUTH_URL` 必须填写为用户实际访问 Karakeep 的完整地址，例如 `https://karakeep.example.com` 或 `http://<服务器 IP>:13000`。

## Introduction
Karakeep is a self-hosted app for bookmarks, notes, and web archives.

## Features
- Save links, notes, images, and web content
- Full-text search powered by Meilisearch
- Chrome sidecar for dynamic page crawling, screenshots, and archival
- Optional OpenAI API key for AI-assisted tagging

## 部署说明
- 本应用使用官方 Docker 镜像 `ghcr.io/karakeep-app/karakeep:release` 部署。
- 按官方 compose 搭配 `gcr.io/zenika-hub/alpine-chrome:124` 和 `getmeili/meilisearch:v1.41.0`。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 13000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Karakeep 数据、SQLite 数据库、资产和 Meilisearch 索引目录 | ./data | 是 |

持久化目录包含：
- `${APP_DATA_DIR}/data:/data`
- `${APP_DATA_DIR}/meilisearch:/meili_data`

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |
| NEXTAUTH_URL | Karakeep 对外访问地址 | http://1.2.3.4:13000 | 是 |
| NEXTAUTH_SECRET | NextAuth JWT 签名密钥 | 随机生成 | 是 |
| MEILI_MASTER_KEY | Meilisearch 主密钥 | 随机生成 | 是 |
| DISABLE_SIGNUPS | 是否禁止新用户注册 | false | 是 |
| OPENAI_API_KEY | 可选 OpenAI API Key，用于自动标签等 AI 功能 | 空 | 否 |

## 使用说明
- 首次安装建议保持 `DISABLE_SIGNUPS=false`，创建管理员账号后再按需改为 `true`。
- 不配置 `OPENAI_API_KEY` 时，Karakeep 仍可正常保存和搜索内容，只是 AI 自动标签等功能不可用。
- 官方文档提示 Meilisearch 版本迁移需要参考故障排查说明；升级前请备份数据目录。

## 参考资料
- 官网: <https://karakeep.app/>
- 项目仓库: <https://github.com/karakeep-app/karakeep>
- Docker 安装文档: <https://github.com/karakeep-app/karakeep/blob/main/docs/docs/02-installation/01-docker.md>
- 官方 compose: <https://github.com/karakeep-app/karakeep/blob/main/docker/docker-compose.yml>
- 配置文档: <https://github.com/karakeep-app/karakeep/blob/main/docs/docs/03-configuration/01-environment-variables.md>
