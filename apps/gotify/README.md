# Gotify

## 应用简介
自托管通知服务器。

英文说明：Self-hosted notification server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`、`2.9.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40266 | 是 |
| GOTIFY_SERVER_PORT | 容器内部端口 | 80 | 是 |
| GOTIFY_SERVER_SSL_PORT | SSL 端口 | 443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| GOTIFY_SERVER_SSL_REDIRECTTOHTTPS | 重定向到 HTTPS | true | 是 |
| GOTIFY_SERVER_SSL_LETSENCRYPT_CACHE | Let's Encrypt 缓存目录 | certs | 是 |
| GOTIFY_DATABASE_DIALECT | 数据库方式 | sqlite3 | 是 |
| GOTIFY_DATABASE_CONNECTION | 数据库连接 | data/gotify.db | 是 |
| GOTIFY_UPLOADEDIMAGESDIR | 上传的图片目录 | data/images | 是 |
| GOTIFY_PLUGINSDIR | 插件目录 | data/plugins | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| GOTIFY_DEFAULTUSER_NAME | 默认用户名 | admin | 是 |
| GOTIFY_DEFAULTUSER_PASS | 默认用户密码 | password | 否 |
| GOTIFY_REGISTRATION | 允许注册 | false | 是 |
| GOTIFY_PASSSTRENGTH | 最低密码强度 | 10 | 是 |
| GOTIFY_SERVER_KEEPALIVEPERIODSECONDS | 保持活跃时间（秒） | 0 | 是 |
| GOTIFY_SERVER_LISTENADDR | 监听地址 | - | 否 |
| GOTIFY_SERVER_SSL_ENABLED | 启用 SSL | false | 是 |
| GOTIFY_SERVER_SSL_LISTENADDR | SSL 监听地址 | - | 否 |
| GOTIFY_SERVER_SSL_CERTFILE | SSL 证书文件 (容器内部) | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://gotify.net>
- 文档: <https://gotify.net/docs/>
- 源码: <https://github.com/gotify/server>
