# Mastodon

## 应用简介
Mastodon ActivityPub 社交网络服务。

英文说明：ActivityPub social network server maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`4.6.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 443 | 是 |
| SMTP_PORT | SMTP 端口 | 25 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DB_DATA_PATH | 数据库数据目录 | ./data/db | 是 |
| REDIS_DATA_PATH | Redis 数据目录 | ./data/redis | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LOCAL_DOMAIN | 实例域名 | - | 是 |
| WEB_DOMAIN | Web 域名 | - | 否 |
| MASTODON_PROMETHEUS_EXPORTER_ENABLED | Prometheus 导出器 | false | 否 |
| DB_HOST | 数据库主机 | mastodon-db | 是 |
| DB_PORT | 数据库端口 | 5432 | 是 |
| DB_USER | 数据库用户名 | mastodon | 是 |
| DB_NAME | 数据库名称 | mastodon | 是 |
| REDIS_HOST | Redis 主机 | mastodon-redis | 是 |
| REDIS_PORT | Redis 端口 | 6379 | 是 |
| DB_PASSWORD | 数据库密码 | 安装时自动生成 | 是 |
| ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY | 密钥值 | 安装时自动生成 | 是 |
| ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY | 密钥值 | 安装时自动生成 | 是 |
| ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT | 密钥值 | 安装时自动生成 | 是 |
| SECRET_KEY_BASE | 密钥值 | 安装时自动生成 | 是 |
| OTP_SECRET | 密钥值 | 安装时自动生成 | 是 |
| VAPID_PRIVATE_KEY | 密钥值 | 安装时自动生成 | 是 |
| VAPID_PUBLIC_KEY | 密钥值 | 安装时自动生成 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次安装时请填写 `LOCAL_DOMAIN`、SMTP、数据库/Redis 与数据目录等参数；密钥类字段可留空由脚本按上游格式自动生成。
- 对外访问时，请确保反向代理、DNS 与 `LOCAL_DOMAIN` 保持一致，否则首页可能返回 403 或跳转异常。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://joinmastodon.org/>
- 文档: <https://docs.linuxserver.io/images/docker-mastodon/>
- 源码: <https://github.com/linuxserver/docker-mastodon>
