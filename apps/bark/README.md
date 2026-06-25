# Bark

## 应用简介
iOS 消息推送工具。

英文说明：iOS message push tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`、`2.3.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40280 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| BARK_SERVER_URL_PREFIX | Bark 服务器 URL 前缀 | / | 是 |
| BARK_SERVER_DATA_DIR | Bark 服务器数据目录 | /data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| BARK_SERVER_ADDRESS | Bark 服务器地址 | 0.0.0.0 | 是 |
| BARK_SERVER_DSN | Bark 服务器 DSN | - | 否 |
| BARK_SERVER_SERVERLESS | Bark 服务器无服务器 | false | 是 |
| BARK_SERVER_CERT | Bark 服务器证书 | - | 否 |
| BARK_SERVER_KEY | Bark 服务器密钥 | - | 否 |
| BARK_SERVER_CASE_SENSITIVE | Bark 服务器区分大小写 | false | 是 |
| BARK_SERVER_STRICT_ROUTING | Bark 服务器严格路由 | false | 是 |
| BARK_SERVER_REDUCE_MEMORY_USAGE | Bark 服务器减少内存使用 | false | 是 |
| BARK_SERVER_BASIC_AUTH_USER | Bark 服务器基本身份验证用户 | - | 否 |
| BARK_SERVER_BASIC_AUTH_PASSWORD | Bark 服务器基本身份验证密码 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://bark.day.app>
- 源码: <https://github.com/Finb/Bark>
