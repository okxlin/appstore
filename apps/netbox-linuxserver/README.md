# NetBox

## 应用简介
NetBox IPAM 与机房资产管理。

英文说明：IPAM and DCIM platform maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`4.6.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| BASE_PATH | 基础路径 | - | 否 |
| DB_DATA_PATH | 数据库数据目录 | ./data/db | 是 |
| REDIS_DATA_PATH | Redis 数据目录 | ./data/redis | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUPERUSER_EMAIL | 管理员邮箱 | admin@example.com | 是 |
| SUPERUSER_PASSWORD | 管理员密码 | netbox-change-me | 是 |
| ALLOWED_HOST | 允许访问主机 | * | 是 |
| DB_HOST | 数据库主机 | netbox-db | 是 |
| DB_PORT | 数据库端口 | 5432 | 是 |
| DB_USER | 数据库用户名 | netbox | 是 |
| DB_NAME | 数据库名称 | netbox | 是 |
| DB_PASSWORD | 数据库密码 | netbox-change-me | 是 |
| REDIS_HOST | Redis 主机 | netbox-redis | 是 |
| REDIS_PORT | Redis 端口 | 6379 | 是 |
| REDIS_USERNAME | Redis 用户名 | - | 否 |
| REDIS_PASSWORD | Redis 密码 | - | 否 |
| REDIS_DB_TASK | Redis 任务数据库 | 0 | 是 |
| REDIS_DB_CACHE | Redis 缓存数据库 | 1 | 是 |
| CSRF_TRUSTED_ORIGINS | CSRF 可信来源 | - | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/netbox-community/netbox>
- 文档: <https://docs.linuxserver.io/images/docker-netbox/>
- 源码: <https://github.com/linuxserver/docker-netbox>
