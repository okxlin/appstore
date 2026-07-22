# Immich

## 产品介绍
Immich 是一个高性能的开源照片和视频管理平台，可将移动设备媒体备份到自托管服务器，并提供时间线、相册、搜索、人脸识别和机器学习功能。

## 主要功能
- 自动备份和管理照片、视频
- 支持时间线、相册、分享和地图
- 提供人脸识别、智能搜索和机器学习服务
- 使用 PostgreSQL、VectorChord 和 Valkey 保存索引与任务状态

## 访问说明
- Web 入口：安装后通过 `http://<服务器 IP>:<HTTP 端口>` 访问。
- 实际端口以安装时填写的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Immich is a high-performance open source photo and video management platform for backing up mobile media to a self-hosted server. It includes timelines, albums, search, facial recognition and machine-learning features.

## Features
- Automatically backs up and manages photos and videos
- Supports timelines, albums, sharing and maps
- Provides facial recognition, smart search and machine learning
- Uses PostgreSQL, VectorChord and Valkey for indexes and job state

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本以应用商店页面为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40194 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| UPLOAD_LOCATION | 上传用文件夹路径 | ./data/upload | 是 |
| CACHE_PATH | 缓存文件夹路径 | ./data/cache | 是 |
| DB_PATH | 数据库文件夹路径 | ./data/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

从 `1.132.3` 升级到 `3.x` 前请特别注意：

- 必须先备份 `UPLOAD_LOCATION`，并通过 PostgreSQL 导出方式备份数据库；运行中的 `DB_PATH` 热拷贝不能作为可靠数据库备份。
- 数据库镜像会从已弃用的 `pgvecto-rs` 切换到官方 VectorChord 兼容镜像。首次启动会执行扩展迁移和索引重建，大型图库可能需要较长时间。
- 完成 VectorChord 迁移后不可降级到低于 `1.133.0` 的 Immich 版本。
- v3 包含 API 等破坏性变更，依赖 Immich API 的第三方工具需要按官方 v3 migration guide 检查兼容性。
- 移动客户端应在服务器升级前更新到与服务器主版本兼容的版本。

从 `3.0.2` 升级到 `3.0.3` 不改变表单、持久化路径、Valkey 或 PostgreSQL 镜像。首次启动会自动执行数据库迁移；升级前仍需备份数据库和上传目录，并等待服务恢复健康后再执行其他操作。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | immich | 是 |
| PANEL_DB_USER | Postgres 数据库用户 | postgres | 是 |
| PANEL_DB_USER_PASSWORD | Postgres 数据库用户密码 | immich | 是 |
| DB_STORAGE_TYPE | 数据库存储介质类型 | SSD | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 数据库位于机械硬盘时将 `DB_STORAGE_TYPE` 设为 `HDD`，SSD 或 NVMe 保持 `SSD`。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://immich.app>
- 文档: <https://docs.immich.app>
- v3 迁移指南: <https://immich.app/blog/v3-migration>
- VectorChord 升级说明: <https://docs.immich.app/install/upgrading/#migrating-to-vectorchord>
- 源码: <https://github.com/immich-app/immich>
