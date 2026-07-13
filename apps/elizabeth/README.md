# Elizabeth

## 产品介绍

**Elizabeth** 是一款无需注册的自托管实时文件与消息共享工具。用户可通过房间分享
Markdown 消息、文件、图片和链接；Rust 后端以单个容器提供 API、WebSocket 与内嵌
Web 界面。

## 主要功能

- **实时房间**：通过 WebSocket 同步消息和房间状态，并支持可分享的房间链接。
- **文件与消息共享**：支持 Markdown、代码高亮、图片、PDF、文本文件和链接预览。
- **安全与权限**：提供 JWT 会话、房间密码、细粒度权限、过期策略与访问次数限制。
- **轻量部署**：默认使用 SQLite，单容器即可运行，也可连接外部 PostgreSQL。

## 访问说明

- Web 端口由安装表单设置，默认 `4092`。
- 安装后直接打开 Web UI 即可创建房间并分享链接，无需注册账号。
- 健康检查路径：`/api/v1/health`。

## 数据持久化

- `APP_DATA_DIR` 挂载到 `/app/data`，保存 SQLite 数据库等本地状态。
- `APP_STORAGE_DIR` 挂载到 `/app/storage`，保存房间上传文件。
- 升级或迁移前应完整备份这两个目录。
- `JWT_SECRET` 用于签发登录会话；升级时不要更换，否则现有会话会失效。

## 安全说明

- 安装表单会为 `JWT_SECRET` 生成随机后缀；公网部署前请确认密钥足够强。
- 容器启用 `read_only`、`cap_drop: ALL`、`no-new-privileges` 与 `/tmp` tmpfs。
- 对公网开放时应通过 1Panel 反向代理启用 HTTPS，并按需要设置房间密码与权限。

## Introduction

**Elizabeth** is a self-hosted real-time file and message sharing tool that
requires no account registration. Users share Markdown messages, files, images,
and links through rooms, while one Rust container serves the API, WebSocket
endpoint, and embedded web interface.

## Features

- **Real-time rooms**: Synchronizes messages and room state over WebSocket and
  supports shareable room links.
- **File and message sharing**: Supports Markdown, code highlighting, images,
  PDFs, text files, and link previews.
- **Security and permissions**: Provides JWT sessions, room passwords, granular
  permissions, expiry policies, and entry limits.
- **Lightweight deployment**: Runs as a single container with SQLite by default
  and can connect to an external PostgreSQL database.

## Access

- The web port is configured in the install form and defaults to `4092`.
- Open the web UI after install to create rooms and share links without
  registration.
- Health endpoint: `/api/v1/health`.

## Persistence

- `APP_DATA_DIR` mounts to `/app/data` for SQLite and other local state.
- `APP_STORAGE_DIR` mounts to `/app/storage` for room file uploads.
- Back up both directories before upgrades or migrations.
- Keep `JWT_SECRET` stable across upgrades to avoid invalidating sessions.

## Security

- The install form randomizes `JWT_SECRET`; use a strong secret for public
  deployments.
- The container runs with `read_only`, `cap_drop: ALL`, `no-new-privileges`, and
  a `/tmp` tmpfs.
- For public access, terminate TLS with a reverse proxy and configure room
  passwords or permissions as needed.
