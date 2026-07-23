# Seafile

## 产品介绍

Seafile 是面向个人与团队的开源文件同步、共享和协作平台。本适配使用官方 `seafileltd/seafile-mc` 镜像，并复用 1Panel 中已有的 MySQL/MariaDB 与 Redis 应用。

## 主要功能

- 文件同步、共享、版本管理和团队资料库。
- Web 管理界面、用户与权限管理。
- 通过 1Panel 服务选择器接入现有数据库和 Redis 运行时。

## 访问说明

- 安装后通过表单配置的 HTTP 端口访问 Web 界面。
- 数据库和 Redis 应用必须已安装、运行，并与本应用加入 `1panel-network`。
- `SERVER_HOSTNAME` 只填写域名或 IP，不要包含协议和路径；HTTPS 建议由 1Panel 反向代理终止。

## Introduction

Seafile is an open source file sync, sharing, and collaboration platform. This package uses the official `seafileltd/seafile-mc` image and reuses existing MySQL/MariaDB and Redis apps managed by 1Panel.

## Features

- File synchronization, sharing, versioning, and team libraries.
- Web administration plus user and permission management.
- Existing database and Redis runtimes can be selected through 1Panel service selectors.

## 应用简介
具有隐私保护和团队合作功能的开源云存储系统。

英文说明：An open source cloud storage system with privacy protection and teamwork features.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`13.0.25`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40130 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_ROOT_PASSWORD | 数据库 root 密码 | mysql_root_password | 是 |
| PANEL_DB_PORT | 数据库端口 | 3306 | 是 |
| ADMIN_EMAIL | 管理员邮箱 | admin@localhost.com | 是 |
| ADMIN_PASSWORD | 管理员密码 | seafile | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| CACHE_PROVIDER | 缓存类型，新安装使用 Redis | redis | 是 |
| REDIS_HOST | Redis 服务 | - | 是 |
| REDIS_PORT | Redis 端口 | 6379 | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码，无密码时留空 | - | 否 |
| MEMCACHED_HOST | 旧安装兼容用 Memcached 主机 | memcached | 否 |
| MEMCACHED_PORT | 旧安装兼容用 Memcached 端口 | 11211 | 否 |
| JWT_PRIVATE_KEY | JWT 私钥，至少 32 个字符 | 随机生成 | 是 |
| SERVER_HOSTNAME | 服务端主机名 (域名 或 IP) | localhost.com | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、管理员账号、数据库 root 密码、Redis 连接和数据目录等参数。
- Seafile 首次启动需要创建三个数据库，因此本包按上游流程使用所选数据库 runtime 的 root 凭据。1Panel 不会为这三库建立独立资源记录，卸载应用也不会清理数据库数据；请单独备份并限制数据库网络访问。
- 新安装会使用 `seafile_ccnet_db`、`seafile_seafile_db` 和 `seafile_seahub_db`，避免与同一 MySQL runtime 中的 SeaTable 等应用发生库名冲突。旧安装升级时会保留原有 `ccnet_db`、`seafile_db` 和 `seahub_db` 名称，不会自动迁移数据库。
- `LocalMySQL` 仅用于兼容直接选择本地商店 runtime 的场景；它不是 1Panel 的数据库生命周期类型，必须手工保证 root 密码和端口与所选 runtime 一致。
- 旧安装升级时，`upgrade.sh` 不覆盖任何已有 `.env` 值；仅在字段缺失时保留旧数据库名、补 `PANEL_DB_PORT=3306`、保留旧 Memcached 缓存路径，并生成新的 64 位十六进制 JWT 私钥。升级前仍应备份数据目录和三个数据库。
- `latest` 目录已固定到 `13.0.25`，避免 Docker Hub 上长期滞后的浮动 `latest` 标签落到 11.x 镜像。历史 `latest` 安装跨主版本升级前必须按 Seafile 官方升级顺序确认中间版本并完整备份；不要依赖自动镜像更新直接跨主版本。
- 新安装使用 Redis。`MEMCACHED_HOST` 与 `MEMCACHED_PORT` 仅保留给历史安装迁移，不建议新部署继续使用 Memcached。
- 官方 `seafileltd/seafile-mc:13.0.25` CE 镜像仍包含 `pro` 目录，初始化会被上游脚本误判为专业版并重复创建 Seahub 表，容器重建后也可能误启专业版组件。本适配在每次容器启动时仅将镜像可写层内的该目录改名为临时路径，随后按 CE 流程启动；不修改 `/shared` 数据，升级和重启会保留现有数据，也不会执行数据库删表。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.seafile.com>
- 文档: <https://manual.seafile.com>
- Docker 13 部署文档: <https://manual.seafile.com/13.0/setup/setup_ce_by_docker/>
- 源码: <https://github.com/haiwen/seafile>
