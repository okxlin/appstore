# NetBox

## 产品介绍
NetBox 是一款用于 IP 地址管理（IPAM）与机房基础设施管理（DCIM）的开源平台，这里使用 LinuxServer.io 提供的容器镜像进行部署。

## 主要功能
- 管理 IP 地址、VLAN、VRF、机柜与设备等基础设施数据
- 依赖内置 PostgreSQL 与 Redis 组件完成数据存储和任务队列
- 支持通过 Web UI 进行日常运维与资产管理

## 访问说明
安装完成后，通过 `http://<服务器 IP>:<PANEL_APP_PORT_HTTP>` 访问 Web UI，实际端口以安装表单或 1Panel 展示为准。

## Introduction
NetBox is an open source IPAM and DCIM platform, deployed here with the LinuxServer.io container image.

## Features
- Manage IP addresses, VLANs, VRFs, racks and device inventory
- Bundle PostgreSQL and Redis sidecars for storage and background jobs
- Provide a Web UI for day-to-day infrastructure operations

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`4.6.4`。
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

说明：如果为 `REDIS_PASSWORD` 设置了值，内置 Redis 会同步启用密码认证；留空则以内网无密码方式运行。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/netbox-community/netbox>
- 文档: <https://docs.linuxserver.io/images/docker-netbox/>
- 源码: <https://github.com/linuxserver/docker-netbox>
