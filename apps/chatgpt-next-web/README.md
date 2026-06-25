# ChatGPT-Next-Web

## 应用简介
一键免费部署你的跨平台私人 ChatGPT 应用。

英文说明：One-Click to get well-designed cross-platform ChatGPT web UI.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`2.16.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40042 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| API_KEY | OPENAI API KEY | sk-xxx | 是 |
| SECRET_KEY | 访问权限密钥，可选(强烈建议填写) | chatgptnextweb | 否 |
| PROXY | 代理地址(例子：http://127.0.0.1:7890 user password) | - | 否 |
| API_BASE_URL | API接口地址 | https://api.openai.com | 是 |

## 使用说明
### 配置页面访问密码

> 配置密码后，用户需要在设置页手动填写访问码才可以正常聊天，否则会通过消息提示未授权状态。

> **警告**：请务必将密码的位数设置得足够长，最好 7 位以上，否则[会被爆破](https://github.com/Yidadaa/ChatGPT-Next-Web/issues/518)。

本项目提供有限的权限控制功能，请在 Vercel 项目控制面板的环境变量页增加名为 `CODE` 的环境变量，值为用英文逗号分隔的自定义密码：

```
code1,code2,code3
```

增加或修改该环境变量后，请**重新部署**项目使改动生效。

## 参考资料
- 官网: <https://github.com/Yidadaa/ChatGPT-Next-Web>
