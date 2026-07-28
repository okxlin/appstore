# Kaneo

## 产品介绍

Kaneo 是一个轻量级的开源项目管理平台，提供看板、任务、标签、评论、
时间记录、实时更新和多种第三方集成。

## 主要功能

- 使用看板、任务、标签、评论和时间记录管理项目
- 通过 WebSocket 实时同步项目变更
- 支持 GitHub、Gitea、Slack、Discord、Telegram 和通用 Webhook 集成
- 提供 API、MCP 接口和可选的对象存储图片附件

## 访问说明

- Web 端口默认只绑定 `127.0.0.1`。请在 1Panel 中配置 HTTPS 反向代理。
- 安装时的公开访问地址必须填写完整的 HTTP(S) origin，例如
  `https://kaneo.example.com`，不要包含路径或末尾斜杠。
- 第一个注册用户会成为实例管理员。确认管理员账号可用后，可在应用参数中
  将“禁止新用户注册”设为 `true` 并重启应用。

## 安全与数据

- 安装脚本会一次生成数据库密码和认证密钥，并写入权限为 `0600` 的
  `.env`。升级和重启不会自动轮换。
- Kaneo 以官方 UID/GID `1001:1001` 运行；PostgreSQL 以 `70:70`
  直接运行，不执行镜像内的 root/gosu 切换路径。
- 两个容器都丢弃全部 Linux capabilities 并禁止权限提升。PostgreSQL
  仅连接内部 Docker 网络，不发布主机端口。
- PostgreSQL 数据保存在安装版本目录下的 `data/postgres`。卸载不会删除
  该目录；升级前请备份整个数据目录。

## Introduction

Kaneo is a lightweight open-source project management platform with boards,
tasks, labels, comments, time tracking, live updates, and integrations.

## Features

- Manage projects with boards, tasks, labels, comments, and time tracking
- Synchronize project changes in real time over WebSockets
- Integrate with GitHub, Gitea, Slack, Discord, Telegram, and generic webhooks
- Use its API, MCP interface, and optional object storage for image attachments

## Access And First Use

- The web port binds to `127.0.0.1` by default. Publish it through the 1Panel
  reverse proxy with HTTPS.
- Set Public URL to the complete HTTP(S) origin used by browsers, such as
  `https://kaneo.example.com`. Do not include a path or trailing slash.
- The first registered user becomes the instance administrator. After that
  account works, set Disable Registration to `true` and restart if public
  signup is not required.

## Security And Data

- Installation generates the database password and authentication secret once
  and stores them in the mode `0600` `.env`. Restart and upgrade preserve them.
- Kaneo runs as the upstream UID/GID `1001:1001`. PostgreSQL runs directly as
  `70:70`, bypassing the image's root/gosu identity-switch path.
- Both services drop every Linux capability and prevent privilege escalation.
  PostgreSQL is restricted to an internal Docker network and publishes no host
  port.
- PostgreSQL data is stored in `data/postgres` below the installed version.
  Uninstall preserves it. Back up the complete data directory before upgrades.
- Kaneo's root filesystem remains writable because the official startup script
  replaces frontend runtime URLs and nginx discovery metadata in place. The
  service remains non-root and can write only paths owned by its upstream user.

## References

- Source: <https://github.com/usekaneo/kaneo>
- Release: <https://github.com/usekaneo/kaneo/releases/tag/v2.9.9>
- Self-hosting: <https://github.com/usekaneo/kaneo#self-hosting>
