# Tianji

## 应用简介
Tianji 是一款开源的 all-in-one 数据洞察中心。

英文说明：Tianji = Website Analytics + Uptime Monitor + Server Status.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.32.6`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40205 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_HOST | 数据库服务 | - | 是 |
| PANEL_DB_NAME | 数据库名 | tianji | 是 |
| PANEL_DB_USER | 数据库用户 | tianji | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | tianji | 是 |
| JWT_SECRET | 秘钥 | any-random-text | 是 |
| ALLOW_OPENAPI | 是否开启OpenAPI | true | 是 |
| ALLOW_REGISTER | 是否允许注册 | false | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://tianji.msgbyte.com/>
- 文档: <https://github.com/msgbyte/tianji>
