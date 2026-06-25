# Discourse

## 应用简介
开源讨论平台。

英文说明：Open-source discussion platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`3.4.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40268 | 是 |
| DISCOURSE_EXTERNAL_HTTP_PORT_NUMBER | 外部 HTTP 端口 | 80 | 是 |
| DISCOURSE_EXTERNAL_HTTPS_PORT_NUMBER | 外部 HTTPS 端口 | 443 | 是 |
| DISCOURSE_PORT_NUMBER | Discourse 端口 | 3000 | 是 |
| DISCOURSE_SMTP_PORT_NUMBER | SMTP 端口 | - | 否 |
| PANEL_DB_PORT | 数据库端口号 | 5432 | 是 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DISCOURSE_DATA_TO_PERSIST | 持久化数据 | plugins public/backups public/uploads | 是 |
| DISCOURSE_SITE_NAME | 网站名称 | My site! | 是 |
| POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS | PostgreSQL 客户端创建数据库扩展 | hstore,pg_trgm | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DISCOURSE_ENABLE_HTTPS | 启用 HTTPS | no | 是 |
| DISCOURSE_HOST | Discourse 主机 | www.example.com | 是 |
| DISCOURSE_SKIP_BOOTSTRAP | 跳过引导 | - | 否 |
| DISCOURSE_ENV | 环境 | production | 是 |
| DISCOURSE_PRECOMPILE_ASSETS | 预编译资产 | yes | 是 |
| DISCOURSE_ENABLE_CONF_PERSISTENCE | 启用配置持久化 | no | 是 |
| DISCOURSE_EXTRA_CONF_CONTENT | 额外配置内容 | yes | 是 |
| DISCOURSE_PASSENGER_SPAWN_METHOD | Passenger 启动方法 | direct | 是 |
| DISCOURSE_PASSENGER_EXTRA_FLAGS | Passenger 额外标志 | - | 否 |
| DISCOURSE_USERNAME | 用户名 | siteadmin | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.discourse.org>
- 文档: <https://docs.discourse.org>
- 源码: <https://github.com/discourse/discourse>
