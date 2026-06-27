# Databasus

## 产品介绍
Databasus 是自托管数据库备份工具，支持备份、恢复校验、保留策略和多种存储目的地，适合管理数据库备份工作流。

## 主要功能
- 管理数据库备份任务和保留策略
- 通过真实恢复校验备份可用性
- 支持本地和多种远程存储目的地

## 访问说明
安装后通过 `http://<服务器 IP>:4005` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Databasus is a self-hosted tool for database backups, restore verification and retention policies.

## Features
- Manage database backup jobs and retention policies
- Verify backups by performing real restores
- Support local and multiple remote storage destinations

## 部署说明
- 本应用使用官方 Docker 镜像 `databasus/databasus` 部署。
- 应用分类：DevOps。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Databasus Web 端口 | 4005 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Databasus 数据目录，挂载到容器 `/databasus-data` | ./data | 是 |

Databasus 会在该目录内保存自身数据库、备份数据、配置和加密相关文件。升级、迁移、清理备份或重置账号前，请先备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- Databasus 会处理数据库连接、备份和恢复校验，请只连接自己拥有或已授权管理的数据库。
- 首次安装后请在 Web 界面完成账号和备份目标配置。
- 备份工具涉及敏感凭据和数据恢复能力，如需对外开放访问，请同步检查防火墙、安全组、反向代理和账号安全。

## 参考资料
- 官网: <https://databasus.com/>
- 项目仓库: <https://github.com/databasus/databasus>
- Docker 部署说明: <https://github.com/databasus/databasus#option-2-simple-docker-run>
