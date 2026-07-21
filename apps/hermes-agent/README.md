# Hermes Agent

## 产品介绍

Hermes Agent 是一个可自托管的 AI Agent 与消息网关，可连接模型提供商，并通过 Telegram、Discord、Slack 等渠道持续运行。

## 主要功能

- 以 `gateway run` 模式常驻运行消息网关。
- 支持多种模型提供商和 OpenAI-compatible 接口。
- 支持消息平台、搜索、抓取、GitHub、Home Assistant 等可选集成。
- 将配置、凭据和运行数据持久化到独立数据目录。

## 访问说明

- 网关 API 默认使用 `8642` 端口，主要供 Hermes Dashboard 和其他客户端连接；除公开健康检查外，请求需要使用 `API_SERVER_KEY`。
- Hermes Agent 本身不是普通网页应用；安装后应在 1Panel 中确认容器运行状态和日志，再通过已配置的消息渠道或客户端使用。
- 至少配置一个模型提供商凭据。未启用的集成请保持对应字段为空。

## Introduction

Hermes Agent is a self-hosted AI agent and messaging gateway. It connects to model providers and can run continuously through channels such as Telegram, Discord, and Slack.

## Features

- Persistent `gateway run` service.
- Multiple model providers and OpenAI-compatible endpoints.
- Optional messaging, search, crawling, GitHub, and Home Assistant integrations.
- Persistent configuration, credentials, and runtime data.

## 部署说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 支持 `amd64`、`arm64` 架构。
- 提供滚动更新的 `latest` 和与主镜像标签一致的数字版本目录；实际版本以当前目录中的 Compose 配置为准。
- 容器使用 `HERMES_UID` / `HERMES_GID` 映射数据目录权限，默认值为 `10000:10000`。
- 升级脚本会为旧安装补充缺失的 UID/GID，并迁移数据目录权限；已有自定义值不会被覆盖。

## 参数

| 参数 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_API | 网关 API 端口 | 8642 | 是 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| HERMES_UID | Hermes 运行用户 UID | 10000 | 是 |
| HERMES_GID | Hermes 运行用户 GID | 10000 | 是 |
| GATEWAY_STATIC_IP | 1Panel 网络中的固定 IP | 172.18.0.240 | 是 |
| API_SERVER_KEY | 网关 API 密钥 | 随机生成 | 是 |
| API_SERVER_CORS_ORIGINS | 允许访问网关的浏览器 Origin | * | 是 |
| OPENAI_API_KEY | OpenAI / OpenAI-compatible API 密钥 | - | 否 |
| OPENROUTER_API_KEY | OpenRouter API 密钥 | - | 否 |
| TELEGRAM_BOT_TOKEN | Telegram Bot Token | - | 否 |

## 安全提示

- API Key、Token 和密码属于敏感信息。只填写实际启用的集成，不要在容器日志、截图或公开配置中暴露。
- `API_SERVER_CORS_ORIGINS=*` 便于浏览器客户端接入，但范围较宽；有固定前端域名时应改为明确的 Origin。
- 从旧版本升级时，脚本只会为缺失或空白的 `API_SERVER_KEY` 生成随机值，不会覆盖已有配置。升级后可在 1Panel 应用参数中改成自己管理的强密钥。
- 对第三方 OpenAI-compatible 服务，优先将密钥保存在数据目录的 `.env` 中，并在 `config.yaml` 中只保存模型、Provider 和 `base_url` 等非秘密配置。
- 升级、迁移或修改 UID/GID 前，请先备份 `APP_DATA_DIR`。

## 参考资料

- 官网: <https://hermes-agent.nousresearch.com/docs/>
- Docker 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/docker>
- 源码: <https://github.com/NousResearch/hermes-agent>
