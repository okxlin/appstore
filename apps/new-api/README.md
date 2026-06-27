# New API

## 产品介绍
New API 是新一代大模型网关与 AI 资产管理系统，可用于统一管理已授权的模型服务商、渠道、令牌、用户、用量统计和计费策略。

## 主要功能
- 提供 OpenAI、Claude、Gemini 等多种 API 格式的网关与转发能力
- 支持渠道管理、模型路由、用量统计、额度和用户权限管理
- 支持使用 SQLite 单容器部署，也可按官方文档扩展到外部数据库

## 访问说明
安装后通过 `http://<服务器 IP>:15076` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
New API is a next-generation LLM gateway and AI asset management system for authorized model provider, channel, token, user, usage and billing management.

## Features
- Gateway and relay support for OpenAI, Claude, Gemini and other API formats
- Channel management, model routing, usage statistics, quotas and user permissions
- SQLite-based single-container deployment by default, with external database options documented upstream

## 部署说明
- 本应用使用官方 Docker 镜像 `calciumion/new-api` 部署。
- 默认采用官方文档中的 SQLite 单容器形态，只挂载 `/data` 数据目录。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | New API Web 与 API 访问端口 | 15076 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | New API 数据目录，挂载到容器 `/data` | ./data | 是 |

升级、迁移、切换数据库或启用外部依赖前，请先在 1Panel 中备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 本应用是 AI API 网关，使用前请确认你已合法取得上游 API Key、账号、模型服务和接口权限。
- 如对公网开放访问，请同步配置防火墙、安全组、反向代理、HTTPS 和访问控制。
- 面向公众提供生成式 AI 服务或 API 转售服务时，请自行完成所在司法辖区要求的备案、许可、内容安全、实名、日志留存、税务和上游授权等合规义务。
- 如果需要 MySQL、PostgreSQL、Redis 或多节点部署，请参考官方部署文档后再调整配置。

## 参考资料
- 项目仓库: <https://github.com/QuantumNous/new-api>
- Docker 使用说明: <https://github.com/QuantumNous/new-api#using-docker-commands>
- 部署文档: <https://docs.newapi.pro/en/docs/installation>
