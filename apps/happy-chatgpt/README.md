# Happy-ChatGPT

## 应用简介
ChatGPT 国粹版，和 GPT 一起学习地道的中国话吧。

英文说明：ChatGPT (swear version), learn "authentic" Chinese with GPT.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40117 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| API_KEY | OPENAI API KEY | sk-xxx | 是 |
| SECRET_KEY | 访问权限密钥，可选(强烈建议填写) | happychatgpt | 否 |
| HTTPS_PROXY | HTTPS代理 (http://127.0.0.1:7890) | - | 否 |
| API_BASE_URL | API接口地址 (https://api.openai.com) | - | 否 |
| API_MODEL | API模型，可选 (https://platform.openai.com/docs/models) | - | 否 |
| HEAD_SCRIPTS_VAULE | 在页面的 之前注入分析或其他脚本 | - | 否 |
| PUBLIC_SECRET_KEY_VAULE | 项目的秘密字符串。用于生成 API 调用的签名 | - | 否 |

## 使用说明
### 常见问题

Q: TypeError: fetch failed (can't connect to OpenAI Api)

A: 配置环境变量 `HTTPS_PROXY`，参考：https://github.com/ddiu8081/chatgpt-demo/issues/34

Q: throw new TypeError(${context} is not a ReadableStream.)

A: Node 版本需要在 `v18` 或者更高，参考：https://github.com/ddiu8081/chatgpt-demo/issues/65

Q: Accelerate domestic access without the need for proxy deployment tutorial?

A: 你可以参考此教程：https://github.com/ddiu8081/chatgpt-demo/discussions/270

## 参考资料
- 官网: <https://happy-chat-gpt.vercel.app>
- 文档: <https://github.com/vastxie/Happy-ChatGPT>
