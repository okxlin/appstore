# Pandora

## 应用简介
潘多拉，一个让你呼吸顺畅的 ChatGPT。

英文说明：Pandora, a ChatGPT that helps you breathe smoothly.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`1.3.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40040 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PROXY | 指定代理，格式：protocol://user:pass@ip:port。 | - | 否 |
| API_BASE_URL | OpenAI API接口地址 | https://ai.fakeopen.com | 是 |
| REVERSE_PROXY | ChatGPT API反向代理 | https://ai.fakeopen.com | 是 |

## 使用说明
可以国际互联的可以访问官方链接获取`ACCESS_TOKEN`

[官方链接获取 AccessToken](https://chat.openai.com/api/auth/session)

## 参考资料
- 官网: <https://github.com/zhile-io/pandora>
- 文档: <https://github.com/zhile-io/pandora/blob/master/doc/wiki.md>
