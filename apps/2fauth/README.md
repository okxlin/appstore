# 2FAuth

## 应用简介
开源双因素认证管理器。

英文说明：Open-source two-factor authentication manager.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：安全。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`7.0.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40273 | 是 |
| MAIL_PORT | 邮件端口 | - | 否 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SITE_OWNER | 站点拥有者 | admin@localhost.com | 是 |
| DB_DATABASE | 数据库路径 | /srv/database/database.sqlite | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_NAME | 应用名 | 2FAuth | 是 |
| APP_ENV | 应用环境 | local | 是 |
| APP_TIMEZONE | 时区 | Asia/Shanghai | 是 |
| APP_DEBUG | 调试模式 | false | 是 |
| APP_KEY | 应用密钥 (32 位字符) | yuBiR9dlyokasPeguSPl8oPRLpHiqAbr | 是 |
| APP_URL | 应用网址 (外部访问地址) | http://localhost:40273 | 是 |
| IS_DEMO_APP | 演示模式 | false | 是 |
| LOG_CHANNEL | 日志通道 | daily | 是 |
| LOG_LEVEL | 日志级别 | notice | 是 |
| CACHE_DRIVER | 缓存驱动 | file | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://docs.2fauth.app>
- 源码: <https://github.com/Bubka/2FAuth>
