# Snipe-IT

## 应用简介
Snipe-IT 资产管理系统。

英文说明：Asset management system maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`8.0.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8080 | 是 |
| MAIL_PORT | SMTP 端口 | - | 否 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DB_DATA_PATH | 数据库数据目录 | ./data/db | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_KEY | 应用密钥 | base64:K4tN8COBEIginakyKQ4SGfoAskVW1leA/A0qSEDucFQ= | 是 |
| APP_URL | 应用访问 URL | http://localhost:8080 | 是 |
| APP_FORCE_TLS | 强制 TLS | false | 否 |
| MYSQL_PORT_3306_TCP_ADDR | 数据库主机 | snipe-it-db | 是 |
| MYSQL_PORT_3306_TCP_PORT | 数据库端口 | 3306 | 是 |
| MYSQL_DATABASE | 数据库名称 | snipeit | 是 |
| MYSQL_USER | 数据库用户名 | snipeit | 是 |
| DB_PASSWORD | 数据库密码 | snipeit-change-me | 是 |
| APP_LOCALE | 应用语言 | - | 否 |
| MAIL_HOST | SMTP 主机 | - | 否 |
| MAIL_FROM | 邮件发件地址 | - | 否 |
| MAIL_FROM_NAME | 邮件发件名称 | - | 否 |
| MAIL_ENCRYPTION | 邮件加密方式 | - | 否 |
| MAIL_USERNAME | SMTP 用户名 | - | 否 |
| MAIL_PASSWORD | SMTP 密码 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/grokability/snipe-it>
- 文档: <https://docs.linuxserver.io/deprecated_images/docker-snipe-it/>
- 源码: <https://github.com/linuxserver/docker-snipe-it>
