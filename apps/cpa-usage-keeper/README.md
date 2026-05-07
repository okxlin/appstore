# CPA Usage Keeper

## 产品介绍

CPA Usage Keeper 是一个独立的 Cli-Proxy-API 用量追踪与展示服务，内置 SQLite 持久化和 Dashboard。它依赖 CLIProxyAPI（CPA）作为后端数据来源，在 CPA 之上补充持久化存储与统计分析能力。

## 主要功能

- CPA usage 数据持久化到 SQLite
- usage 聚合 API 与 pricing API
- 内置 React Dashboard
- 可选密码登录保护
- SQLite 数据库本地备份与保留策略

## 访问说明

- 默认通过 PANEL_APP_PORT_HTTP（8080）端口访问
- 安装后访问地址：http://<server-ip>:<port>
- 如需启用登录保护，设置 AUTH_ENABLED=true 并配置 LOGIN_PASSWORD

## 配置说明

| 变量 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `CPA_BASE_URL` | 是 | - | CPA 服务地址 |
| `CPA_MANAGEMENT_KEY` | 是 | - | CPA management key |
| `AUTH_ENABLED` | 否 | `false` | 是否启用登录保护 |
| `LOGIN_PASSWORD` | 鉴权启用时必填 | - | 登录密码 |
| `AUTH_SESSION_TTL` | 否 | `168h` | 登录会话有效时长 |
| `REDIS_QUEUE_ADDR` | 否 | `CPA_BASE_URL` 主机名 + `8317` | CPA Redis 地址 |
| `REDIS_QUEUE_TLS` | 否 | `false` | Redis TLS 连接 |
| `REDIS_QUEUE_BATCH_SIZE` | 否 | `1000` | Redis 每次拉取批次大小 |
| `REDIS_QUEUE_IDLE_INTERVAL` | 否 | `1s` | Redis 空闲检查间隔 |
| `REQUEST_TIMEOUT` | 否 | `30s` | 请求 CPA 接口超时 |
| `TLS_SKIP_VERIFY` | 否 | `false` | 跳过 TLS 证书验证 |
| `APP_BASE_PATH` | 否 | - | 子路径部署前缀，例如 `/cpa` |
| `APP_DATA_DIR` | 否 | `./data` | 数据目录 |
| `TZ` | 否 | `Asia/Shanghai` | 时区 |
| `LOG_LEVEL` | 否 | `info` | 日志级别 |
| `LOG_FILE_ENABLED` | 否 | `true` | 是否写入持久化日志 |
| `LOG_RETENTION_DAYS` | 否 | `7` | 日志保留天数 |
| `BACKUP_ENABLED` | 否 | `true` | 是否启用 SQLite 备份 |
| `BACKUP_INTERVAL` | 否 | `24h` | 备份间隔 |
| `BACKUP_RETENTION_DAYS` | 否 | `7` | 备份保留天数 |

## Introduction

CPA Usage Keeper is a standalone Cli-Proxy-API usage tracker with SQLite persistence and built-in dashboard. It relies on CLIProxyAPI (CPA) as the backend data source, adding persistent storage and statistical analysis capabilities on top of CPA.

## Features

- CPA usage data persistence to SQLite
- Usage aggregation API and pricing API
- Built-in React Dashboard
- Optional password-based login protection
- SQLite database local backup and retention policy

## 相关链接

- [GitHub 仓库](https://github.com/Willxup/cpa-usage-keeper)
- [官方文档](https://github.com/Willxup/cpa-usage-keeper/blob/main/README.md)
