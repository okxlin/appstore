# Wastebin

## 产品介绍

Wastebin 是使用 Rust 编写的极简 Pastebin。它通过单个无 shell 的容器提供网页和 JSON API，使用 SQLite 保存压缩后的文本内容，不依赖外部数据库。

## 主要功能

- 通过网页或 JSON API 创建和读取文本片段
- 支持语法高亮、Markdown 渲染、二维码和多种主题
- 支持有效期、阅后即焚、密码加密和创建者删除令牌
- 使用 SQLite 持久化文本内容

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。默认绑定 `127.0.0.1`；需要远程访问时，应通过 HTTPS 反向代理发布，或在确认网络边界后修改绑定地址。`WASTEBIN_BASE_URL` 只用于二维码链接，公开地址变化后应同步更新。

Wastebin 不提供用户认证或管理后台，也不包含完整的拒绝服务防护。公开部署必须在反向代理或防火墙层配置访问控制、请求速率和正文大小限制。

## 数据与安全

- `APP_DATA_DIR` 映射到容器内 `/data`，SQLite 数据库为 `/data/state.db`。
- 容器固定以 UID/GID `10001:10001` 运行，根文件系统只读，并丢弃全部 Linux capabilities。
- 生命周期脚本会为短于 64 字符的 `WASTEBIN_SIGNING_KEY` 和短于 32 字符的 `WASTEBIN_PASSWORD_SALT` 生成稳定的随机值并写回 `.env`。升级和迁移时必须保留这两个值，否则创建者删除令牌或密码加密数据会失效。
- 默认的 `./data` 位于 1Panel 应用安装目录内。卸载前请备份；如需跨卸载保留数据，可选择预先规划的绝对目录，并将既有目录所有权设置为 `10001:10001`。

## Introduction

Wastebin is a minimal Pastebin written in Rust. A single shell-free container serves the web interface and JSON API, while SQLite stores compressed text entries without an external database.

## Features

- Create and retrieve text pastes through the browser or JSON API
- Syntax highlighting, Markdown rendering, QR codes, and multiple themes
- Expiration, burn-after-reading, password encryption, and owner deletion tokens
- Persistent SQLite storage

## Usage And Security

- Access the service at `http://<server-ip>:<port>`. The default bind address is `127.0.0.1`; use an HTTPS reverse proxy for remote access, or change the bind address only after reviewing the network boundary.
- `APP_DATA_DIR` is mounted at `/data`, with the SQLite database stored as `/data/state.db`.
- The container runs as UID/GID `10001:10001`, uses a read-only root filesystem, drops all Linux capabilities, and receives only a small writable `/tmp` tmpfs for SQLite migrations.
- Wastebin has no user authentication, administration interface, or comprehensive denial-of-service protection. Public deployments require access control, rate limiting, and request-size controls at the reverse proxy or firewall.
- Back up the data directory and preserve both generated secrets before upgrades or migration.

## References

- Project: <https://github.com/matze/wastebin>
- Stable release: <https://github.com/matze/wastebin/releases/tag/3.7.0>
- Docker documentation: <https://github.com/matze/wastebin#run-a-docker-image>
- License: <https://github.com/matze/wastebin/blob/3.7.0/LICENSE> (MIT)
