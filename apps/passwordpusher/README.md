# Password Pusher

## 应用简介
一个通过网络传递密码的开源应用程序。

英文说明：An opensource application to communicate passwords over the web.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`release`、`2.7.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40180 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | passwordpusher | 是 |
| PANEL_DB_USER | 数据库用户 | passwordpusher | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | passwordpusher | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://pwpush.com>
- 文档: <https://github.com/pglombardo/PasswordPusher/wiki>
- 源码: <https://github.com/pglombardo/PasswordPusher>
