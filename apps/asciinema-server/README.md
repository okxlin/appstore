# asciinema server

## 产品介绍

asciinema server 是 asciinema 生态的服务端组件，用于托管、浏览、分享和搜索终端会话录制，并支持终端直播与 asciinema CLI 上传。

## 主要功能

- 托管、播放、分享和搜索 asciicast 终端录制
- 终端直播、CLI 上传与账户管理
- 录制可见性控制、嵌入和文本转录下载

## 访问说明

- 安装后通过 `http://<服务器地址>:<HTTP 端口>` 访问。安装表单中的公开协议、主机名和端口必须与用户实际访问的 URL 一致，否则登录链接和直播 WebSocket URL 会错误。
- asciinema server 使用无密码登录。未配置 SMTP 时，提交邮箱后在 `asciinema server` 容器日志中查找 `url from email`，打开短期登录链接。
- 第一个完成注册的账户会成为管理员。完成首次注册后，建议在 1Panel 编辑应用，把“禁用公开注册”设为 `true`。
- 管理面板通过已认证主站的 `/admin` 提供。独立管理端口 `4002` 不会发布，也不会绑定到 Compose 网络。

## 安全默认值

- 默认要求 CLI 上传经过认证，避免公开实例接受匿名录制上传。仅在受信任的内网中按需关闭。
- 应用端口默认绑定 `127.0.0.1`，适合由同机 1Panel 网站反向代理；如需直接从远端访问，改为 `0.0.0.0` 并同时配置防火墙和 HTTPS。
- 应用与 PostgreSQL 使用独立内部网络和随机数据库密码。PostgreSQL 不发布宿主机端口。
- 会话签名密钥与数据库密码在首次安装时生成，写入权限为 `0600` 的 `.env`，升级和重启不会轮换。

## 数据与备份

录制文件保存在 `APP_DATA_DIR/asciinema`，账户、元数据和搜索索引保存在 `APP_DATA_DIR/postgres`。卸载不会删除这些目录。升级或迁移前必须同时备份两者；只备份其中一个不能完整恢复实例。

## 镜像安全说明

固定的 asciinema server `20260626` 镜像在交付时报告 `0 Critical / 5 High`。这些发现位于 Alpine OpenSSL 和 Expat 系统库，均已有修复包但最新稳定镜像尚未重建。PostgreSQL 镜像报告的 `1 Critical / 14 High` 全部来自仅用于启动时降权的 `gosu` Go 二进制；数据库不对外提供 TLS/HTTP/邮件处理面。更换任一镜像 digest 时必须重新扫描和复核。

## Introduction

asciinema server hosts, browses, shares, and searches terminal session recordings. It also supports live terminal streaming and uploads from the asciinema CLI.

## Features

- Host, play, share, and search asciicast terminal recordings
- Live terminal streaming, CLI uploads, and account management
- Recording visibility controls, embedding, and transcript downloads

## Access

- Open `http://<server-address>:<HTTP port>` after installation. Public scheme, host, and port must match the URL users actually open because they are used for login links and live-stream WebSocket URLs.
- Authentication is passwordless. Without SMTP, submit your email address, then find `url from email` in the application container logs and open the short-lived link.
- The first registered account becomes the administrator. After registration, edit the app and set **Disable public signup** to `true` for a private instance.
- The authenticated admin panel is available at `/admin`. The separate admin port `4002` is neither published nor bound to the Compose network.

## Security defaults

- Authenticated CLI uploads are required by default. Disable this only for a trusted private network.
- The application binds to `127.0.0.1` by default for a same-host 1Panel reverse proxy. Use `0.0.0.0` only with an appropriate firewall and HTTPS setup.
- PostgreSQL stays on a private network and uses a generated password. Its port is not published.
- Session and database secrets are generated once and retained in the mode `0600` `.env` file across restarts and upgrades.

## Data and backup

Recording files live in `APP_DATA_DIR/asciinema`; accounts, metadata, and search data live in `APP_DATA_DIR/postgres`. Uninstall does not remove them. Back up both directories together before upgrades or migration.

## References

- Project and license: <https://github.com/asciinema/asciinema-server>
- Official self-hosting guide: <https://docs.asciinema.org/manual/server/self-hosting/>
- Official quick start: <https://docs.asciinema.org/manual/server/self-hosting/quick-start/>
- Official configuration reference: <https://docs.asciinema.org/manual/server/self-hosting/configuration/>
