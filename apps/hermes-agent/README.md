# Hermes Agent

## 应用简介
Hermes Agent 消息网关。

英文说明：Hermes Agent messaging gateway.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2026.6.19`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_API | 网关 API 端口 | 8642 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIPS | 提示 | 安装后容器会以 gateway run 常驻运行。容器默认不再以 root 身份运行，而是使用 HERMES_UID / HERMES_GID（默认 10000:10000）映射到宿主机数据目录。升级脚本会在旧 .env 缺失时自动补入这两个变量，并把 APP_DATA_DIR 现有目录权限迁移到对应 UID/GID；若你有自定义用户，请在升级前先调整为自己的值。至少需要配置 1 个模型提供商 Key；若要直接接入 Telegram，再补 TELEGRAM_BOT_TOKEN。对于第三方 OpenAI-compatible 供应商，建议把 API Key 放到 /opt/data/.env 的 OPENAI_API_KEY 中，并手动在 /opt/data/config.yaml 里设置 model.default、provider: custom、base_url；不要把密钥直接写进 config.yaml。 | 是 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| GITHUB_APP_PRIVATE_KEY_PATH | GitHub App 私钥路径 | - | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HERMES_UID | Hermes 运行用户 UID | 10000 | 是 |
| HERMES_GID | Hermes 运行用户 GID | 10000 | 是 |
| GATEWAY_STATIC_IP | 网关静态 IP | 172.18.0.240 | 是 |
| OPENAI_API_KEY | OpenAI / OpenAI-compatible API 密钥 | - | 否 |
| OPENROUTER_API_KEY | OpenRouter API 密钥 | - | 否 |
| ANTHROPIC_TOKEN | Anthropic API 密钥 | - | 否 |
| ANTHROPIC_BASE_URL | Anthropic 基础地址 | - | 否 |
| GOOGLE_API_KEY | Google API 密钥 | - | 否 |
| DEEPSEEK_API_KEY | DeepSeek API 密钥 | - | 否 |
| MISTRAL_API_KEY | Mistral API 密钥 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hermes-agent.nousresearch.com/docs/>
- 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/docker>
- 源码: <https://github.com/NousResearch/hermes-agent>
