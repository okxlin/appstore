# PicoClaw

## 产品介绍

PicoClaw 是轻量级个人 AI 助手和多渠道网关。它提供 Web 控制台、模型与工具配置、会话记录、技能管理，并可接入 Telegram、Discord、飞书、企业微信、微信、WhatsApp、LINE、Matrix、Slack、QQ、OneBot 等渠道。

## 主要功能

- 在浏览器中配置模型、渠道、工具、技能和定时任务
- 通过 WebSocket Web 控制台与个人助手对话
- 对接常见聊天平台的出站连接与 Webhook
- 持久化工作区、会话、记忆和安全凭据
- 管理网关生命周期、日志和运行状态

## 访问说明

- Web 控制台地址为 `http://<服务器 IP>:<Web 控制台端口>`，端口由 `PANEL_APP_PORT_HTTP` 设置。
- 首次访问必须在 `/launcher-setup` 创建至少 8 位的控制台密码。密码创建前，任何能访问 Web 控制台端口的人都可能抢先完成初始化；安装后应立即在可信管理网络中设置密码。
- 当前版本使用持久化 bcrypt 密码和进程内会话 cookie；上游 Compose 中关于 `PICOCLAW_LAUNCHER_TOKEN` 环境变量的注释已过时，该变量不会在 `v0.3.1` 设置控制台密码。
- PicoClaw 不附带任何模型或渠道凭据。请登录控制台后自行配置，凭据保存在 `APP_DATA_DIR` 中；升级、迁移或卸载前请备份该目录，卸载不会删除绑定目录中的数据。

## 双端口说明

- `PANEL_APP_PORT_HTTP` 映射 Web 控制台 `18800`。控制台的 API 和 Pico WebSocket 由登录会话保护，浏览器聊天通过控制台内部代理完成。
- `PANEL_APP_PORT_GATEWAY` 映射网关 `18790`。配置可用的默认模型后网关才会启动；LINE、企业微信等基于 Webhook 的渠道需要直接访问此端口，Telegram、Discord、飞书等主动出站连接通常不需要对公网开放它。
- 网关的 `/health` 与 `/ready` 端点无需认证，Webhook 依赖各渠道自己的签名或令牌校验。仅在确实使用 Webhook 渠道时开放网关端口，并通过 HTTPS 反向代理、来源限制和防火墙只允许所需平台或可信网络访问。不要把 Web 控制台或网关端口直接暴露到不受信任的公网。

## 安全与漏洞警告

- 2026-07-28 对固定镜像的 Trivy 扫描结果为 `0 Critical / 20 High`。两个 Go 二进制各重复报告同一组 10 个漏洞：Go 标准库 `CVE-2026-39822`，以及 `golang.org/x/crypto` 的 `CVE-2026-39828`、`CVE-2026-39829`、`CVE-2026-39830`、`CVE-2026-39831`、`CVE-2026-39832`、`CVE-2026-39835`、`CVE-2026-42508`、`CVE-2026-46595`、`CVE-2026-46597`。所有项目均已有修复版本。
- 9 个 `x/crypto` 漏洞影响 SSH 客户端、服务器、代理或 known-hosts 路径；PicoClaw 镜像只使用该 SSH 包在本地生成和序列化 Ed25519 密钥，不建立 SSH 客户端或服务器，因此默认服务不进入这些受影响路径。
- `CVE-2026-39822` 位于文件工具使用的 Go `os.Root` 路径，具有实际可达性：如果工作区中已经存在指向工作区外部的符号链接，且工具以 `/` 结尾访问该链接，边界检查可能被绕过。容器的只读根文件系统把写入限制在 PicoClaw 自己的 `/data` 卷，但同卷中的模型或渠道凭据仍可能被读取。不要在工作区放置外链符号链接，不要安装不可信技能，并只允许受信任用户和渠道使用工具。
- 容器根文件系统只读，只持久化 `/data`，并丢弃全部 capabilities。入口仅使用 `CHOWN`、`SETUID` 和 `SETGID` 修正数据目录并切换身份；实际 PicoClaw 进程以 `nobody:nogroup` 运行、无有效 capabilities，且启用 `no-new-privileges`。
- 应限制管理访问、使用 HTTPS、保护备份，并在上游发布包含 Go `1.25.12` 或更新版本及 `golang.org/x/crypto v0.52.0` 或更新版本的已验证镜像后尽快升级。

## Introduction

PicoClaw is a lightweight personal AI assistant and multi-channel gateway. It provides a web console, model and tool configuration, session history, skill management, and integrations for Telegram, Discord, Feishu, WeCom, WeChat, WhatsApp, LINE, Matrix, Slack, QQ, OneBot, and other channels.

## Features

- Configure models, channels, tools, skills, and scheduled tasks in a browser
- Chat through the WebSocket-based web console
- Connect outbound chat platforms and inbound webhook channels
- Persist the workspace, sessions, memory, and security credentials
- Manage gateway lifecycle, logs, and runtime status

## Access And Initialization

- Open `http://<server-ip>:<web-console-port>`, configured by `PANEL_APP_PORT_HTTP`.
- The first visit requires creating a dashboard password of at least eight characters at `/launcher-setup`. Until setup is complete, anyone who can reach the console port could claim the initial password. Complete setup immediately from a trusted management network.
- This release persists a bcrypt password and uses a per-process session cookie. The upstream Compose comment about `PICOCLAW_LAUNCHER_TOKEN` is stale; that environment variable does not initialize the `v0.3.1` dashboard password.
- No model or channel credentials are bundled. Configure them after login. They are persisted under `APP_DATA_DIR`; back up that directory before upgrades or migration. Uninstall does not remove the bind-mounted data.

## Two-Port Model

- `PANEL_APP_PORT_HTTP` maps the web console on `18800`. Its APIs and Pico WebSocket require the dashboard session, and browser chat uses the console's internal proxy.
- `PANEL_APP_PORT_GATEWAY` maps the gateway on `18790`. The gateway starts only after a usable default model is configured. Webhook channels such as LINE and WeCom need direct access to this port; outbound channels such as Telegram, Discord, and Feishu normally do not require public inbound exposure.
- Gateway `/health` and `/ready` are unauthenticated, while webhook handlers rely on channel-specific signatures or tokens. Publish the gateway port only when a webhook channel requires it, and restrict it with an HTTPS reverse proxy, source allowlists, and firewall rules. Do not expose either port directly to an untrusted public network.

## Security And Vulnerability Warning

- A 2026-07-28 Trivy scan of the pinned image reports `0 Critical / 20 High`. The two Go binaries each report the same ten findings: Go standard library `CVE-2026-39822`, plus `golang.org/x/crypto` `CVE-2026-39828`, `CVE-2026-39829`, `CVE-2026-39830`, `CVE-2026-39831`, `CVE-2026-39832`, `CVE-2026-39835`, `CVE-2026-42508`, `CVE-2026-46595`, and `CVE-2026-46597`. Fixed upstream versions exist for every finding.
- The nine `x/crypto` findings affect SSH client, server, agent, or known-hosts paths. PicoClaw only uses the SSH package to generate and serialize a local Ed25519 key; it does not expose an SSH client or server, so the default service does not enter the affected paths.
- `CVE-2026-39822` is reachable in the Go `os.Root` implementation used by file tools. If a workspace already contains a symlink pointing outside the workspace and a tool accesses it with a trailing `/`, the workspace boundary may be bypassed. The read-only container root limits writes to PicoClaw's own `/data` volume, but model or channel credentials in that volume could still be read. Do not place outward symlinks in the workspace, do not install untrusted skills, and grant tool access only to trusted users and channels.
- The container has a read-only root filesystem and persists only `/data`. All capabilities are dropped. The entrypoint uses only `CHOWN`, `SETUID`, and `SETGID` to prepare the data directory and switch identity; the PicoClaw process runs as `nobody:nogroup` with no effective capabilities and `no-new-privileges` enabled.
- Restrict administrative access, use HTTPS, protect backups, and upgrade promptly after upstream publishes a verified image built with Go `1.25.12` or newer and `golang.org/x/crypto v0.52.0` or newer.

## References

- Website: <https://picoclaw.io/>
- Project: <https://github.com/sipeed/picoclaw>
- Docker guide: <https://docs.picoclaw.io/docs/docker>
- Release: <https://github.com/sipeed/picoclaw/releases/tag/v0.3.1>
- License: <https://github.com/sipeed/picoclaw/blob/v0.3.1/LICENSE> (MIT)
- Logo: <https://github.com/sipeed/picoclaw/blob/v0.3.1/web/backend/icon.png> (official project asset from the MIT-licensed source tree)
