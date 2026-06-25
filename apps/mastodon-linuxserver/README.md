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
| LOCAL_DOMAIN | 实例域名 | example.com | 是 |
| WEB_DOMAIN | Web 域名 | - | 否 |
| DB_PASSWORD | 数据库密码 | mastodon-change-me | 是 |
| ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY | 密钥值 | fGWkJDBwyRYhILyO7akZGLSSz0gAjPpo | 是 |
| ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY | 密钥值 | Z8BE3tc3XnmUr0MbRexRiPN7vcP52VX0 | 是 |
| ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT | 密钥值 | 3hRwOaLRCikUCsxd19cUcO5EgXCN6ig1 | 是 |
| SECRET_KEY_BASE | 密钥值 | ae3ab77b9a041a4d760126dba8c4e24a33bdfcec7fdbadf3d973baf92017ee0d0b988d62c040aca882ee8030ea22adb04d9c26a9541c918a434029840c8719b0 | 是 |
| OTP_SECRET | 密钥值 | b3d6069b87df718c733a1b17a9adcbd7705b76ba0b48dd3f3ce58870dd52bed0d32d947a43a4eadac4230d508e11df0cee6f59ed85e40670134a52545f1131ac | 是 |
| VAPID_PRIVATE_KEY | 密钥值 | 1eF670mQsgs_-W_eb06ZZ46apD4qVDYNvFWu9eGWc7E= | 是 |
| VAPID_PUBLIC_KEY | 密钥值 | BOOqXKvCVA9tb8Bas05sdez6fGavnA5SrDJe88s7FMeIu7txiQ5sOqOZqKIpTSS_xmm5Wkd_MKHqj2UCQIwl9_8= | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://joinmastodon.org/>
- 文档: <https://docs.linuxserver.io/images/docker-mastodon/>
- 源码: <https://github.com/linuxserver/docker-mastodon>
