# Sub-Store

## 产品介绍
Sub-Store 是适用于 Quantumult X、Loon、Surge、Stash、Egern 和 Shadowrocket 等客户端的高级订阅管理器。

本应用提供 `latest` 和 `http-meta` 两个镜像标签版本，均使用同一数据目录持久化配置。

## 主要功能
- 管理、转换和组合多种代理订阅格式。
- 支持订阅格式化、节点过滤、重命名和脚本处理。
- 支持定时同步订阅和推送通知。
- 可按需求选择 `latest` 或 `http-meta` 镜像标签。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问：

```text
http://<服务器 IP>:<HTTP 端口>
```

`SUB_STORE_BACKEND_SYNC_CRON` 用于后端定时同步。旧变量 `SUB_STORE_CRON` 和 `SUB_STORE_BACKEND_CRON` 已被上游弃用。

## Introduction
Sub-Store is an advanced subscription manager for Quantumult X, Loon, Surge, Stash, Egern, Shadowrocket, and related clients.

This app provides both `latest` and `http-meta` image-tag variants and persists configuration in the configured data directory.

## Features
- Manage, convert, and combine multiple proxy subscription formats.
- Format subscriptions, filter nodes, rename entries, and run script processors.
- Schedule backend sync jobs and push notifications.
- Choose either the `latest` or `http-meta` image tag variant.

## 应用简介
适用于 QX、Loon、Surge、Stash 和 Shadowrocket 的高级订阅管理器。

英文说明：Advanced Subscription Manager for QX, Loon, Surge, Stash and Shadowrocket.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`http-meta`。
- 安装后按应用表单中的 HTTP 端口访问 Web UI。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40232 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUB_STORE_FRONTEND_BACKEND_PATH | 前端后端路径 | /2cXaAxRGfddmGz2yx1wA | 是 |
| DATA_PATH | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUB_STORE_PUSH_SERVICE | 推送服务 URL | https://api.day.app/XXXXXXXXXXXX/[推送标题]/[推送内容]?group=SubStore&autoCopy=1&isArchive=1&sound=shake&level=timeSensitive&icon=https%3A%2F%2Fraw.githubusercontent.com%2F58xinian%2Ficon%2Fmaster%2FSub-Store1.png | 是 |
| SUB_STORE_BACKEND_SYNC_CRON | Cron 定时任务 | 55 23 * * * | 是 |

旧版本使用的 `SUB_STORE_CRON`、`SUB_STORE_BACKEND_CRON` 会在升级脚本中迁移为 `SUB_STORE_BACKEND_SYNC_CRON`；Compose 同时保留旧变量 fallback，避免同版本 `latest` 刷新时定时同步值丢失。升级或迁移前仍建议备份 `DATA_PATH`。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hub.docker.com/r/xream/sub-store>
- 文档: <https://www.notion.so/Sub-Store-6259586994d34c11a4ced5c406264b46>
- 源码: <https://github.com/sub-store-org/Sub-Store>
