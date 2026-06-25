# Healthchecks

## 应用简介
Healthchecks 定时任务监控。

英文说明：Cron job monitor maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`4.2.20260622`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8000 | 是 |
| PANEL_APP_PORT_SMTP | Smtp 端口 | 2525 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| SITE_ROOT | 站点根 URL | http://127.0.0.1:8000 | 是 |
| SITE_NAME | 站点名称 | Healthchecks | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SECRET_KEY | 密钥 | - | 是 |
| ALLOWED_HOSTS | 允许的主机名 | - | 否 |
| APPRISE_ENABLED | 启用 Apprise | False | 否 |
| CSRF_TRUSTED_ORIGINS | CSRF 可信来源 | - | 否 |
| HEALTHCHECKS_DEBUG | 调试模式 | False | 否 |
| PING_EMAIL_DOMAIN | Ping 邮件域名 | - | 否 |
| RP_ID | WebAuthn RP ID | - | 否 |
| SITE_LOGO_URL | 站点 Logo URL | - | 否 |
| SUPERUSER_EMAIL | 管理员邮箱 | admin@example.com | 是 |
| SUPERUSER_PASSWORD | 管理员密码 | - | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://healthchecks.io/>
- 文档: <https://docs.linuxserver.io/images/docker-healthchecks/>
- 源码: <https://github.com/linuxserver/docker-healthchecks>
