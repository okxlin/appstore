# LibreChat

## 产品介绍
LibreChat 是一个开源多用户 AI 聊天平台，支持多模型供应商、智能体、文件上传、搜索、RAG 和自托管部署。

## 主要功能
- 提供类似 ChatGPT 的多用户 Web 聊天界面
- 支持 OpenAI、Anthropic、Google、OpenRouter、Groq 等模型供应商
- 支持智能体、搜索、文件上传、RAG 和独立管理面板

## 访问说明
- Web 入口：安装后通过 `http://<服务器 IP>:18088` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。
- 管理面板：安装后通过 `http://<服务器 IP>:18089` 访问，实际端口以 `PANEL_APP_PORT_ADMIN` 为准。

## Introduction
LibreChat is an open source multi-user AI chat platform with model provider integrations, agents, uploads, search, RAG and self-hosted deployment.

## Features
- Provides a ChatGPT-like multi-user web chat interface
- Supports model providers such as OpenAI, Anthropic, Google, OpenRouter and Groq
- Includes agents, search, uploads, RAG and a separate admin panel

## 部署说明
- 本应用基于 LibreChat 官方 Docker Compose 拓扑适配，包含 LibreChat API/Web、Admin Panel、MongoDB、Meilisearch、pgvector PostgreSQL 和 RAG API。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。LibreChat 官方主镜像当前使用 moving `latest` 标签，本应用使用 `tag@sha256` 固定已测试镜像摘要，并关闭跨版本自动升级。
- 内部服务名使用 `librechat-*` 前缀，避免主服务和管理面板同时加入 `1panel-network` 时解析到其他应用的同名服务。
- 本应用不会把供应商 API Key 作为安装必填项；安装完成后请在 LibreChat 内按需配置模型供应商。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | LibreChat Web 访问端口 | 18088 | 是 |
| PANEL_APP_PORT_ADMIN | LibreChat Admin Panel 访问端口 | 18089 | 是 |

## 数据持久化
| 路径 | 说明 |
| --- | --- |
| `${APP_DATA_DIR}/images` | Web 静态图片 |
| `${APP_DATA_DIR}/uploads` | 用户上传文件 |
| `${APP_DATA_DIR}/logs` | LibreChat 日志 |
| `${APP_DATA_DIR}/skill` | Skills 目录 |
| `${APP_DATA_DIR}/mongodb` | MongoDB 数据 |
| `${APP_DATA_DIR}/meilisearch` | Meilisearch 数据 |
| `${APP_DATA_DIR}/pgvector` | RAG pgvector 数据 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOMAIN_CLIENT | LibreChat 对外 Web 地址 | http://127.0.0.1:18088 | 是 |
| DOMAIN_SERVER | LibreChat 对外 API 地址 | http://127.0.0.1:18088 | 是 |
| ADMIN_PANEL_URL | 管理面板对外地址 | http://127.0.0.1:18089 | 是 |
| LIBRECHAT_APP_SECRET | 用于派生 JWT、凭据加密和管理面板会话密钥 | 随机生成 | 是 |
| MEILI_MASTER_KEY | Meilisearch 主密钥 | 随机生成 | 是 |
| VECTOR_DB_PASSWORD | RAG 向量数据库密码 | 随机生成 | 是 |
| ALLOW_REGISTRATION | 是否允许新用户注册 | true | 是 |

## 使用说明
- 首次公开部署时，请把 `DOMAIN_CLIENT`、`DOMAIN_SERVER` 和 `ADMIN_PANEL_URL` 改为真实外部访问地址。
- 如需关闭开放注册，请将 `ALLOW_REGISTRATION` 设置为 `false`。
- 模型供应商 Key、OAuth、SMTP、对象存储等高级配置请在应用内或后续自定义配置中维护，不建议在安装表单中暴露大量可选密钥。
- 当前包不加入 Renovate 自动合并白名单：LibreChat 使用多个数据库/检索服务，官方主镜像来源仍是 moving tag，升级前需要查看上游变更、更新摘要并备份数据。

## 参考资料
- 官网: <https://librechat.ai/>
- 项目仓库: <https://github.com/danny-avila/LibreChat>
- 官方 Docker Compose: <https://github.com/danny-avila/LibreChat/blob/main/docker-compose.yml>
- 官方环境变量示例: <https://github.com/danny-avila/LibreChat/blob/main/.env.example>
