# GPT-Load

## 产品介绍
GPT-Load 是多渠道 AI API 透明代理服务，面向需要统一管理多个上游模型服务、密钥池、负载均衡和调用监控的场景。

## 主要功能
- 提供 OpenAI、Gemini、Claude 等 API 的透明代理入口
- 支持密钥池管理、自动轮询、失败恢复和负载均衡
- 管理端和代理端分离鉴权，并支持 SQLite 单容器轻量部署

## 访问说明
安装后通过 `http://<服务器 IP>:15077` 访问管理界面，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准；API 代理地址为 `http://<服务器 IP>:<端口>/proxy`。

## Introduction
GPT-Load is a multi-channel AI API transparent proxy for managing upstream providers, key pools, load balancing and request monitoring.

## Features
- Transparent proxy entry for OpenAI, Gemini, Claude and similar APIs
- Key pool management, rotation, failure recovery and load balancing
- Separate authentication for management and proxy access, with SQLite single-container deployment by default

## 部署说明
- 本应用使用官方 GitHub Container Registry 镜像 `ghcr.io/tbphp/gpt-load` 部署。
- 默认采用官方文档中的 SQLite 单容器形态，只挂载 `/app/data` 数据目录。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | GPT-Load Web 管理端与 API 代理端口 | 15077 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | GPT-Load 数据目录，挂载到容器 `/app/data` | ./data | 是 |

升级、迁移、变更加密密钥或切换外部数据库前，请先在 1Panel 中备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AUTH_KEY | 管理端登录密钥，安装时随机生成 | 随机生成 | 是 |
| ENCRYPTION_KEY | API Key 静态加密密钥，安装后请保持稳定 | 随机生成 | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 请妥善保存 `AUTH_KEY`，它用于登录管理界面。
- `ENCRYPTION_KEY` 用于加密存储 API Key；已有数据后请勿随意修改，否则可能需要按官方迁移流程处理加密数据。
- 本应用是 AI API 代理服务，使用前请确认你已合法取得上游 API Key、账号、模型服务和接口权限。
- 如对公网开放访问，请同步配置防火墙、安全组、反向代理、HTTPS 和访问控制。
- 如需 MySQL、PostgreSQL、Redis 或集群部署，请参考官方文档后再调整配置。

## 参考资料
- 项目仓库: <https://github.com/tbphp/gpt-load>
- Docker 快速开始: <https://github.com/tbphp/gpt-load#method-1-docker-quick-start>
- Compose 部署说明: <https://github.com/tbphp/gpt-load#method-2-using-docker-compose-recommended>
