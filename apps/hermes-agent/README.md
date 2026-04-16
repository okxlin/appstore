# Hermes Agent

Hermes Agent 是一个可长期运行的 AI Agent 消息网关，适合把同一个助手接入 Telegram、Discord、Slack、WhatsApp、Signal、Email 等消息入口。这个应用现在只保留 **gateway** 主功能，dashboard 已拆分为可选附属应用 `hermes-dashboard`。

## 应用内容

本产物默认安装一个容器：

- **hermes-agent**：常驻消息网关，命令为 `gateway run`

其中：

- `8642`：Hermes 网关 API / health 端口
- `GATEWAY_STATIC_IP`：给 gateway 指定 1Panel 网络内的固定 IP，方便附属 dashboard 或其它容器稳定访问
- `/opt/data`：统一持久化目录，保存 `.env`、`config.yaml`、会话、记忆、技能、日志等数据

## 版本说明

产物同时保留两个安装入口：

| 目录 | 说明 |
| --- | --- |
| `latest/` | 跟随上游最新镜像 |
| 数字版本目录 | 保留一个最新的稳定数字版本，便于需要固定版本部署时使用 |

## 安装前建议

建议至少准备以下一类配置：

- 一个模型提供商密钥：如 `OPENAI_API_KEY`、`OPENROUTER_API_KEY`、`ANTHROPIC_TOKEN`、`GOOGLE_API_KEY`
- 一个消息入口凭据：如 `TELEGRAM_BOT_TOKEN`

若两个都不配，容器可以启动，但不会形成可直接使用的聊天入口。

## 安装后访问

- API / Health 地址：`http://服务器IP:面板里填写的 Gateway API 端口`

若后续要安装 `hermes-dashboard`，建议先给本应用设置独立的 `GATEWAY_STATIC_IP`，再在 dashboard 里把 `GATEWAY_HEALTH_URL` 写成对应完整地址。

## 持久化目录

统一数据目录挂载到 `/opt/data`，常见内容如下：

- `/opt/data/.env`：环境变量与密钥
- `/opt/data/config.yaml`：Hermes 主配置
- `/opt/data/sessions/`：会话数据
- `/opt/data/memories/`：记忆数据
- `/opt/data/skills/`：技能目录
- `/opt/data/logs/`：运行日志

## 配置建议

1Panel 首屏表单保留了较完整的环境变量集合，方便直接在面板里配置；clone 下来手工部署时，也可以直接使用版本目录中的 `.env.sample`。

对于 OpenAI-compatible 供应商，推荐做法：

- API Key 写入 `/opt/data/.env` 的 `OPENAI_API_KEY`
- 模型、provider、base_url 写入 `/opt/data/config.yaml`

## 可选附属应用

如果你需要 Web Dashboard，请额外安装 `hermes-dashboard`。它是独立附属应用，不装也不影响 gateway 正常工作。

## 上游项目

- GitHub：https://github.com/NousResearch/hermes-agent
- 文档：https://hermes-agent.nousresearch.com/docs/
- Docker 文档：https://hermes-agent.nousresearch.com/docs/user-guide/docker
