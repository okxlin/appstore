# go-chatgpt-api

## 应用简介
一个尝试绕过 Cloudflare 来使用 ChatGPT 接口的程序。

英文说明：A program that attempts to bypass Cloudflare to use the ChatGPT interface.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40041 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| API_PANDORA | 潘多拉API模式 | 1 | 否 |
| ARKOSE_TOKEN_URL | ARKOSE_TOKEN 链接 | - | 否 |
| OPENAI_EMAIL | OpenAI账户邮箱 | - | 否 |
| OPENAI_PASSWORD | OpenAI账户密码 | - | 否 |

## 使用说明
- 一个例子

当搭配本机`chatgpt-web`使用时，`API反向代理`可以填写如下

```
http://go-chatgpt-api:8080/chatgpt/backend-api/conversation
```

## 参考资料
- 官网: <https://github.com/linweiyuan/go-chatgpt-api>
