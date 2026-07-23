# SeaTable

## 产品介绍

SeaTable 是基于智能表格的协作与数据管理平台。本适配使用官方 `seatable/seatable-developer` 镜像，并复用 1Panel 中已有的 MySQL/MariaDB 与 Redis 应用。

## 主要功能

- 表格化数据管理、协作和视图管理。
- API、自动化与扩展能力。
- 通过 1Panel 服务选择器接入现有数据库和 Redis 运行时。

## 访问说明

- 安装后通过表单配置的 HTTP 端口访问 Web 界面。
- 数据库和 Redis 应用必须已安装、运行，并与本应用加入 `1panel-network`。
- `SERVER_HOSTNAME` 只填写域名或 IP，不要包含协议和路径；HTTPS 建议由 1Panel 反向代理终止。

## Introduction

SeaTable is a collaborative data management platform built around smart spreadsheets. This package uses the official `seatable/seatable-developer` image and reuses existing MySQL/MariaDB and Redis apps managed by 1Panel.

## Features

- Spreadsheet-based data management, collaboration, and views.
- APIs, automation, and extensibility.
- Existing database and Redis runtimes can be selected through 1Panel service selectors.

## 应用简介
一款以智能表格为基础的新型数字化平台。

英文说明：A spreadsheet/database like Airtable.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`6.1.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40154 | 是 |

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
| SEATABLE_MYSQL_DB_USER | SeaTable 数据库用户 | seatable | 是 |
| SEATABLE_MYSQL_DB_PASSWORD | SeaTable 数据库密码 | 随机生成 | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| REDIS_PORT | Redis 端口 | 6379 | 是 |
| JWT_PRIVATE_KEY | JWT 私钥，至少 32 个字符 | 随机生成 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| SERVER_HOSTNAME | 服务端主机名 | example.seatable.com | 是 |

## 使用说明
SeaTable 首次启动需要创建三个数据库，因此本包按上游流程使用所选数据库 runtime 的 root 凭据创建库和最小范围的 SeaTable 数据库用户。1Panel 不会为这三库建立独立资源记录，卸载应用也不会清理数据库数据或用户；请单独备份并限制数据库网络访问。

新安装会使用 `seatable_ccnet_db`、`seatable_seafile_db` 和 `seatable_dtable_db`，避免与同一 MySQL runtime 中的 Seafile 等应用发生库名冲突。`LocalMySQL` 仅用于兼容直接选择本地商店 runtime 的场景；它不是 1Panel 的数据库生命周期类型，必须手工保证 root 密码和端口与所选 runtime 一致。

旧安装升级时，`upgrade.sh` 不覆盖已有 `.env` 值；缺少数据库名时会保留旧的 `ccnet_db`、`seafile_db` 和 `dtable_db`，缺少数据库用户或密码时会使用旧 root 配置保持兼容，不会改动旧数据库认证；缺少 `PANEL_DB_PORT` 时会优先迁移旧 `SEAFILE_DB_PORT`，否则使用 `3306`，并在缺少 JWT 时生成新的 64 位十六进制私钥。无效的 Memcached 表单已移除，因为 6.1.0 镜像实际使用 Redis。

`latest` 目录固定到已验证的 `6.1.0` 镜像，避免浮动标签改变部署参数。已验证 MySQL 8.0.40 的 `mysql_native_password` 认证；SeaTable 6.1.0 容器内 MariaDB 客户端不兼容 MySQL 8.4 默认的 `caching_sha2_password`，请使用 1Panel MySQL 8.0/MariaDB runtime，不要选择 MySQL 8.4。升级前请备份数据目录和三个数据库；该应用不加入自动镜像更新白名单。

容器入口会自动启动 SeaTable 服务。首次安装后仍需连接容器终端创建管理员账号：

容器管理功能页面，连接容器终端，执行以下命令

- 创建一个管理员帐户
```bash
/shared/seatable/scripts/seatable.sh superuser  
```

## 参考资料
- 官网: <https://seatable.cn>
- 文档: <https://docs.seatable.cn>
- 源码: <https://github.com/seatable/seatable>
- 官方部署仓库: <https://github.com/seatable/seatable-release>
