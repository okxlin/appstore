# Sub2API

## 产品介绍
Sub2API 是一个提供 OpenAI 兼容接口的 AI 网关服务，可集中管理上游账号、订阅配额、访问令牌和用量统计。

## 主要功能
- 提供 OpenAI 兼容 API 和统一管理界面
- 管理账号、用户、令牌、配额与用量统计
- 支持 PostgreSQL 持久化和 Redis 缓存
- 支持多种 AI 服务的转发与兼容处理

## 访问说明
安装完成后，通过 1Panel 显示的 Web 端口访问管理界面。首次安装会根据表单参数初始化管理员账号、数据库和 Redis 连接。

## Introduction
Sub2API is an AI gateway with OpenAI-compatible APIs for managing upstream accounts, subscriptions, access tokens, quotas, and usage.

## Features
- OpenAI-compatible APIs and a centralized administration interface
- Account, user, token, quota, and usage management
- PostgreSQL persistence and Redis caching
- Forwarding and compatibility support for multiple AI providers

## 部署说明
- 安装前需要在 1Panel 中准备 PostgreSQL 和 Redis 服务。
- `JWT_SECRET` 和 `TOTP_ENCRYPTION_KEY` 留空时，生命周期脚本会生成 64 位十六进制密钥并写入 `.env`。
- 升级时会保留长度不少于 32 字节的自定义 `JWT_SECRET`；旧版生成的过短值会被替换，因此现有登录会话可能需要重新登录。
- 已配置的 TOTP 加密密钥不会在升级时覆盖，避免破坏现有双因素认证。

## 反向代理说明
如果在 Nginx 后面反代 Sub2API，并需要兼容 Codex CLI 等依赖下划线请求头的客户端，请在 Nginx 的 `http` 块中开启：

```nginx
underscores_in_headers on;
```

否则部分带下划线的请求头可能被 Nginx 丢弃，影响会话粘性和部分 CLI 场景。

## 数据持久化
| 路径 | 说明 |
| --- | --- |
| `${APP_DATA_DIR_1}` | Sub2API 应用数据目录 |
| PostgreSQL 服务 | 业务数据和配置 |
| Redis 服务 | 缓存和运行状态 |

升级或迁移前，请备份应用数据目录和 PostgreSQL 数据库。

## 参考资料
- 项目仓库: <https://github.com/Wei-Shaw/sub2api>
- 部署文档: <https://github.com/Wei-Shaw/sub2api/blob/main/deploy/README.md>
