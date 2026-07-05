# NexusPHP

## 产品介绍

NexusPHP 是一个完整的私有 PT 站点建站平台，基于 NexusPHP、Laravel 和 FilamentPHP 构建，适用于自建种子站、论坛和后台管理场景。

## 主要功能

- 提供 Web 安装向导和站点后台
- 内置计划任务、队列工作器和 Nginx/PHP 运行环境
- 支持发种、论坛、签到、审核、插件和多语言等站点能力
- 首次启动自动下载固定版本 release 并安装 PHP 依赖

## 访问说明

- 安装后通过 `http://<服务器IP>:<端口>` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。
- 首次启动需要下载 NexusPHP `v1.10.2` release 并执行 `composer install`，通常要等待数分钟。
- 首次访问会跳转到 `install/install.php` 安装向导；完成安装后请按上游建议删除 `public/install` 目录。
- 安装向导里的 MySQL 和 Redis 连接信息默认已经预填为容器内置服务：`127.0.0.1:3306` / `127.0.0.1:6379`。

## Introduction

NexusPHP is a full private tracker site platform built with NexusPHP, Laravel, and FilamentPHP. This package wraps the owner-maintained Docker image and keeps the bootstrap flow compatible with the upstream installer.

## Features

- Web installer and management backend
- Built-in cron, queue worker, Nginx, PHP-FPM, MySQL, and Redis inside one container
- Supports tracker, forum, plugin, and multilingual site features
- First startup bootstraps a fixed upstream release and installs PHP dependencies

## 部署说明

- 本应用使用项目维护者发布到 Docker Hub 的镜像 `xiaomlove/nexusphp`，当前固定到已验证的镜像 digest `sha256:d8d83c17348fe6204bde4e1146bcec7d90e2a8756c91256c23aa73504a34b819`。
- 应用内部会使用固定的上游 release `v1.10.2` 初始化代码，而不是沿用原镜像“每次重建自动拉取最新 release”的行为。
- 应用分类：Website。
- 支持架构：`amd64`。
- 可选版本：`1.10.2`、`latest`；当前 `latest` 同样固定到 `v1.10.2` 发布线。
- 由于维护者镜像本身内置 MySQL、Redis、cron 和 supervisor，本适配无法复用 1Panel 商店里的 MySQL/Redis runtime，这一点与当前优先策略不完全一致，已在此明确标注。

## 端口

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | NexusPHP Web 访问端口，容器内映射到 `80` | `18084` | 是 |

## 数据持久化

| 变量 / 目录 | 说明 | 默认值 |
| --- | --- | --- |
| `APP_DATA_DIR/app` | NexusPHP 应用代码、`vendor`、安装器和上传目录 | `./data/app` |
| `APP_DATA_DIR/logs` | NexusPHP 默认日志目录，对应容器 `/tmp/nexus` | `./data/logs` |
| `APP_DATA_DIR/backup` | 上游预留的备份导出目录 | `./data/backup` |

另外两个内部 runtime 使用 compose-managed named volume 持久化，而不是 `APP_DATA_DIR` 子目录：

| Docker Volume | 说明 |
| --- | --- |
| `<安装名>_nexusphp-mysql` | 容器内置 MySQL 数据目录 `/var/lib/mysql` |
| `<安装名>_nexusphp-redis` | 容器内置 Redis 数据目录 `/var/lib/redis` |

这样做是为了保持上游镜像的初始化语义，避免空目录挂载覆盖镜像内已准备好的 MySQL/Redis 数据骨架。

升级、迁移或重装前，请同时备份整个 `APP_DATA_DIR` 以及上述两个 Docker volume。

## 参数说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `DOMAIN` | 写入 Nginx `server_name` 和 `.env.example` 的访问域名或 IP | `127.0.0.1` | 是 |
| `TZ` | 容器时区，同时写入 `.env.example` 的 `TIMEZONE` | `Asia/Shanghai` | 是 |

## 风险与升级说明

- 这是一个 all-in-one 镜像：MySQL、Redis、PHP-FPM、Nginx、cron 和 queue worker 都在同一个容器内运行，升级和排障复杂度高于普通多服务拆分应用。
- 当前镜像只有 `amd64` manifest。
- 上游镜像默认只发布 Docker Hub `latest` 标签；为避免容器重建时自动升级到未知版本，本适配改为固定镜像 digest 和固定应用 release。
- 上游 Docker 文档是基于其自带 compose 方案，默认让 MySQL/Redis 跟随容器内部拓扑一起工作；当前适配为了兼容这一前提，保留了内置 MySQL/Redis，而没有改造成复用 1Panel 商店 runtime。
- 当前包默认不做自动 in-place 版本升级。若未来要调整 `APP_IMAGE` 或 `APP_RELEASE_VERSION`，请先备份 `APP_DATA_DIR`，并按专项升级流程验证。
- 本应用不加入 Renovate 自动合并白名单。

## 使用说明

- 如果对公网开放，请把 `DOMAIN` 改为真实域名或公网 IP，并自行配置反向代理、HTTPS 和防火墙。
- 上游 1Panel 文档说明，安装完成后仍应补做 `php artisan passport:keys`，并确认计划任务 / 队列工作器行为符合站点需求。
- 如需查看默认日志，可检查 `APP_DATA_DIR/logs`；若安装器中包含敏感信息，请不要泄露。
- 如果安装后长时间停留在启动中，可先查看容器日志，通常是在下载 release 或执行 `composer install`。

## 参考资料

- 官网: <https://nexusphp.org/>
- 项目仓库: <https://github.com/xiaomlove/nexusphp>
- Docker 安装文档: <https://doc.nexusphp.org/installation_docker.html>
- 1Panel 安装文档: <https://doc.nexusphp.org/installation_1panel.html>
- 上游源码 compose: <https://github.com/xiaomlove/nexusphp/blob/php8/docker-compose.yml>
