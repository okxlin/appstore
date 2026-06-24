# LobeChat

## 应用简介
现代化设计的开源 ChatGPT/LLMs 聊天应用与开发框架。

英文说明：An open-source, modern-design ChatGPT/LLMs UI/Framework.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`1.143.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40247 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| OPENAI_API_KEY | OpenAI API 密钥 | password | 否 |
| OPENAI_PROXY_URL | OpenAI 代理 URL | https://api.openai.com/v1 | 否 |
| ACCESS_CODE | 访问密码 | - | 否 |
| OPENAI_MODEL_LIST | OpenAI 模型列表 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://lobehub.com>
- 文档: <https://lobehub.com/docs>
- 源码: <https://github.com/lobehub/lobe-chat>
