# DooTask

## 产品介绍

DooTask 是一个开源团队协作与任务管理平台，提供项目、任务、消息、文件和 WebSocket 实时协作能力。

## 主要功能

- 项目、任务、聊天和文件协作一体化
- 基于 Laravel Swoole 的实时 Web 与 WebSocket 服务
- 支持通过 1Panel 服务选择器接入外部 MySQL 与 Redis 依赖
- 首次启动自动拉取固定上游源码与发布版 `vendor` 依赖

## 访问说明

- 安装后通过 `http://<服务器IP>:<端口>` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。
- 首次启动需要下载固定的 DooTask `v1.8.64` 源码包和官方发布的 `vendor.tar.gz`，通常需要等待数分钟。
- 初始化完成后会自动执行数据库迁移，并在数据库为空时创建首个管理员账号。

## Introduction

DooTask is an open source team collaboration and task management platform with projects, tasks, chat, files, and realtime WebSocket features.

## Features

- Unified projects, tasks, chat, and file collaboration
- Laravel plus Swoole realtime web and WebSocket stack
- External MySQL and Redis dependency support through 1Panel service selectors
- First startup bootstraps the fixed upstream source tarball and released vendor bundle

## 部署说明

- 本应用基于上游仓库 `kuaifan/dootask` 的官方发布线 `v1.8.64` 适配。
- PHP 运行镜像使用维护者发布的 `kuaifan/php:swoole-8.4@sha256:4f69395d5b8a72256338aa6042a6caaaf598bb5cc0b4ab30a84ef9cc4c5e61e2`。
- Nginx 使用官方镜像 `nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10`。
- 上游官方 compose 还包含 `mariadb`、`redis` 和 `appstore` sidecar；其中 `appstore` sidecar 依赖 `privileged` 与 Docker Socket，但它不是主站启动必需组件，因此本适配明确移除。
- 数据库与 Redis 表单都按 1Panel 服务实例/服务名接入设计：MySQL 使用数据库服务选择器，Redis 使用 `key: redis` 的服务选择器；运行时仍保持 `PANEL_DB_HOST` / `REDIS_HOST` 等既有环境变量，避免升级时破坏老用户现有 `.env`。
- 上游 `v1.8.64` 有少量历史 migration 与现代 MySQL 8 严格模式不兼容，包括 `TEXT default ''` 和一条 `distinct + chunk` 查询排序问题；本适配会在首次解包源码后仅对这些已确认 migration 做幂等兼容修补，再继续官方迁移流程。

## 端口

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | DooTask Web 访问端口 | `28080` | 是 |

## 数据持久化

| 变量 / 目录 | 说明 | 默认值 |
| --- | --- | --- |
| `APP_DATA_DIR/app` | DooTask 源码、`.env`、`vendor`、上传文件和 Laravel `storage` | `./data/app` |
| `APP_DATA_DIR/logs/supervisor` | supervisor 日志 | `./data/logs/supervisor` |

升级、迁移或重装前，请至少备份整个 `APP_DATA_DIR`、外部 MySQL 数据库以及外部 Redis 数据。

## 参数说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_DB_TYPE` | 1Panel 数据库服务类型 | `mysql` | 是 |
| `PANEL_DB_HOST` | 1Panel MySQL 服务实例 | 空 | 是 |
| `DB_PORT` | MySQL 端口 | `3306` | 是 |
| `PANEL_DB_NAME` | DooTask 数据库名 | `dootask` | 是 |
| `PANEL_DB_USER` | DooTask 数据库用户 | `dootask` | 是 |
| `PANEL_DB_USER_PASSWORD` | DooTask 数据库密码 | 随机生成 | 是 |
| `DB_PREFIX` | 数据表前缀 | `pre_` | 是 |
| `REDIS_HOST` | 1Panel Redis 服务实例 | 空 | 是 |
| `REDIS_PORT` | Redis 端口 | `6379` | 是 |
| `PANEL_REDIS_ROOT_PASSWORD` | Redis 密码；无密码时填字面量 `null` | `null` | 是 |
| `REDIS_DB` | Redis 逻辑库编号 | `0` | 是 |
| `TIMEZONE` | 容器与应用时区 | `Asia/Shanghai` | 是 |
| `DOOTASK_ADMIN_EMAIL` | 首个管理员邮箱 | `admin@example.com` | 是 |
| `DOOTASK_ADMIN_PASSWORD` | 首个管理员密码 | 随机生成 | 是 |
| `DOOTASK_ADMIN_NICKNAME` | 首个管理员昵称 | `Administrator` | 是 |

## 使用说明

- 数据库为空时，安装脚本会自动创建首个管理员；如果数据库里已经有用户，则不会覆盖已有账号。
- `PANEL_REDIS_ROOT_PASSWORD` 需要与目标 Redis 实例实际配置一致；如果 Redis 没启用密码认证，请填写字面量 `null`。
- 若安装界面暂时没有可选 Redis 服务，请先在当前 1Panel 中安装并确认可复用的 Redis 应用实例。
- 如需公网访问，请在首次启动后按实际域名或反向代理情况检查 `APP_DATA_DIR/app/.env` 中的 `APP_URL`，必要时手动改为真实外部 URL。
- `/health` 可用于基础存活检查；计划任务由容器内 cron 继续调用上游 `/crontab` 路由。
- 如果目标是 local app 数据库或 Redis，请先确认该服务实例在当前面板中能被其他应用实际访问；本包当前审计重点验证的是 1Panel 依赖服务选择链路，而不是手工填写主机名的旁路安装。

## 风险与升级说明

- 这是一个上游源码首启下载型包，而不是纯镜像即开即用包；首次安装耗时明显高于普通应用。
- 当前包固定到 `v1.8.64` 发布线，`latest` 目录也同样固定到这一版本。
- 为兼容现代 MySQL 8 安装，入口脚本会对上游少量已确认的历史 migration 做一次性本地修补；这不会自动升级到其他上游版本。
- Redis 服务选择器这次只修正了安装表单元数据，未改动实际运行时 envKey，因此老用户已有 `REDIS_HOST` / `REDIS_PORT` / `PANEL_REDIS_ROOT_PASSWORD` 配置仍可直接沿用。
- 自动 in-place 源码升级暂未放开；`upgrade.sh` 只输出明确提醒，不会做破坏性迁移。
- 直接更换到未来版本前，请先完整备份 `APP_DATA_DIR/app`、外部 MySQL 数据库和 Redis 数据，并先做专项升级 smoke。
- 当前包仍不加入 Renovate 自动合并白名单。

## 参考资料

- 官网: <https://www.dootask.com/>
- 项目仓库: <https://github.com/kuaifan/dootask>
- 官方 README: <https://github.com/kuaifan/dootask/blob/pro/README.md>
- 官方 compose: <https://github.com/kuaifan/dootask/blob/v1.8.64/docker-compose.yml>
- 官方发布: <https://github.com/kuaifan/dootask/releases/tag/v1.8.64>
