# CPA Usage Keeper

## 应用简介
独立的 Cli-Proxy-API 用量追踪与展示服务。

英文说明：Standalone Cli-Proxy-API usage tracker.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.11.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_BASE_PATH | 子路径前缀 | - | 否 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CPA_BASE_URL | CPA 服务地址 | - | 是 |
| CPA_MANAGEMENT_KEY | CPA 管理密钥 | - | 是 |
| REDIS_QUEUE_ADDR | CPA Redis 地址 | - | 否 |
| AUTH_ENABLED | 启用登录保护 | false | 否 |
| LOGIN_PASSWORD | 登录密码 | - | 否 |
| LOG_LEVEL | 日志级别 | info | 否 |
| AUTH_SESSION_TTL | 登录会话时长 | 168h | 否 |
| REDIS_QUEUE_TLS | Redis TLS | false | 否 |
| REDIS_QUEUE_BATCH_SIZE | Redis 批次大小 | 1000 | 否 |
| REDIS_QUEUE_IDLE_INTERVAL | Redis 空闲间隔 | 1s | 否 |

## 使用说明
### 配置说明

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

## 参考资料
- 官网: <https://github.com/Willxup/cpa-usage-keeper>
- 文档: <https://github.com/Willxup/cpa-usage-keeper/blob/main/README.md>
