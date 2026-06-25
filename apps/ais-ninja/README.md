# ais-ninja

## 应用简介
基于 ChatGPT 的 Web 应用程序。

英文说明：ChatGPT-based web applications.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`1.0.8`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |
| PANEL_APP_PORT_HTTP | 端口 | 40043 | 是 |
| SMTP_PORT | SMTP 端口 | 587 | 否 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AIS_PLATFORM | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | ais-ninja | 是 |
| PANEL_DB_USER | 数据库用户 | ais-ninja | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | ais-ninja | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| REDIS_PASS | Redis服务密码 | - | 是 |
| SMTP_HOST | SMTP 主机 | - | 否 |
| EMAIL_SENDER | 邮箱服务发送方邮箱地址 | - | 否 |
| SMTP_USER | 邮箱服务用户名 | - | 否 |
| SMTP_PASSWORD | 邮箱服务密码 | - | 否 |

## 使用说明
- 管理员账户密码请通过查看容器日志获取；
- 访问地址加`/admin`即是管理员面板。

## 参考资料
- 官网: <https://github.com/jarvis2f/ais-ninja>
