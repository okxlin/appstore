# slskd

## 产品介绍

slskd 是一个面向 Soulseek 文件共享网络的现代客户端与服务端应用。它以守护进程运行，并通过 Web 界面提供搜索、下载、上传、用户浏览和聊天功能。

本应用直接运行未修改的 slskd 官方镜像，并使用官方默认的 `/app` 应用目录保存配置、日志、SQLite 数据库、下载文件、不完整文件和共享目录。

## 主要功能

- 在浏览器中搜索 Soulseek 网络并管理下载与上传
- 浏览用户共享、加入聊天室并收发私聊消息
- 通过令牌保护的 Web API 和界面管理运行状态
- 将应用配置、传输记录、下载文件和共享内容持久化到本地目录

## 访问说明

- Web 界面：`http://<主机>:<HTTP 端口>/`
- Soulseek 入站端口：安装表单中的 Soulseek 监听端口，仅使用 TCP
- 默认 Web 用户名为安装表单中的值，Web 密码由 1Panel 随机生成
- Soulseek 用户名和密码可在安装时填写，也可在登录 Web 界面后通过设置页面配置

安装后先使用 Web 用户名和随机 Web 密码登录。若安装时没有填写 Soulseek 凭据，请打开设置页面补充凭据并保存，然后确认状态页显示已连接。Soulseek 服务需要能够主动访问 `vps.slsknet.org:2271`；为了获得完整的搜索和传输能力，还应在防火墙、安全组和 NAT 中放行并转发安装时选择的 Soulseek TCP 监听端口。

## 数据目录

应用版本目录中的 `./data` 挂载到容器 `/app`，其中包含：

- `slskd.yml`：运行配置
- `downloads/`：已完成下载
- `incomplete/`：未完成下载
- `shared/`：默认共享目录
- 日志和 SQLite 数据库等运行数据

容器以 UID/GID `1000:1000` 运行应用进程。初始化脚本只准备本应用的 `./data` 子目录；卸载应用会移除容器和 Compose 资源，但不会删除该持久数据。

升级前应备份整个 `./data` 目录，包括 `slskd.yml`、数据库文件及其 `-wal`/`-shm` 旁路文件。`latest` 是移动标签；需要可重复部署时请选择固定版本 `0.26.0`。

## 安全说明

Web 认证默认启用，本包不会使用上游默认的 `slskd/slskd` 凭据。JWT 签名密钥由上游在每次启动时安全随机生成，因此容器重启后现有登录会话会失效，需要重新登录。远程配置功能默认启用，以便在 Web 界面完成 Soulseek 设置；它允许已认证的管理员读取和修改 YAML 配置，因此不应把明文 HTTP 直接暴露到不受信任网络。公网访问应通过可信的 HTTPS 反向代理，并限制入口来源。

slskd 使用 GNU AGPL v3 及上游附加条款。本包不修改、重建或重新发布 slskd 镜像，只引用官方镜像；完整许可证与源码可从上游仓库获取。

## Introduction

slskd is a modern client-server application for the Soulseek file-sharing network. It runs as a daemon and provides a web interface for search, transfers, user browsing, and chat.

This package runs the unmodified official image. Web authentication remains enabled, and 1Panel generates the Web password instead of using upstream's default credentials. Upstream generates a fresh JWT signing key at each start, so existing sessions must sign in again after a restart. The application directory, configuration, databases, downloads, incomplete transfers, and default shared directory persist under `./data`.

## Features

- Browser-based Soulseek search, download, upload, user browsing, and chat workflows
- Authenticated Web UI and token-protected API with generated credentials
- Persistent configuration, transfer databases, downloads, incomplete files, and shared content
- Configurable inbound Soulseek TCP port for complete peer connectivity

Open `http://<host>:<HTTP port>/` after installation and sign in with the configured Web username and generated password. Supply Soulseek credentials during installation or from the authenticated settings page. For full connectivity, allow and forward the selected Soulseek TCP listening port. Internet-facing deployments should place the Web UI behind a trusted HTTPS reverse proxy because authenticated remote configuration is enabled.

Back up the entire `./data` directory before upgrades. Uninstall removes runtime resources but preserves bind-mounted application data.

## References

- Website: <https://slskd.org/>
- Source: <https://github.com/slskd/slskd>
- Docker guide: <https://github.com/slskd/slskd/blob/master/docs/docker.md>
- Configuration: <https://github.com/slskd/slskd/blob/master/docs/config.md>
- Official image: <https://hub.docker.com/r/slskd/slskd>
