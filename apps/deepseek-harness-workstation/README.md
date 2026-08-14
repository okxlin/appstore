# DeepSeek Harness Workstation

## 产品介绍

DeepSeek Harness Workstation 是带网页登录、持久化开发目录和完整开发工具链的 DeepSeek Harness 工作站。镜像封装 `@deepseek-ai/dsh 0.1.0-rc.6`，由 Caddy Security 提供表单登录，适合部署在 1Panel OpenResty HTTPS 反向代理之后。

工作站包含 Node.js、pnpm、Python、Go、Rust、C/C++ 工具链，以及 Docker CLI、Compose 和 Buildx，支持 `amd64` 与 `arm64`。

## 主要功能

- 支持浏览器密码管理器的表单登录
- DeepSeek Harness Web UI、终端、会话、工具与 WebSocket
- 持久化状态、用户 HOME 和工作区
- Docker CLI、Compose 与 Buildx，宿主 Docker 访问默认禁用

## Introduction

DeepSeek Harness Workstation combines DeepSeek Harness, browser-based form authentication, persistent development directories, and a complete multi-language toolchain for deployment behind a 1Panel OpenResty HTTPS reverse proxy.

## Features

- Password-manager-compatible browser login
- DeepSeek Harness Web UI, terminals, sessions, tools, and WebSockets
- Persistent state, user home, and workspace directories
- Docker CLI, Compose, and Buildx with host daemon access disabled by default

## 访问说明

安装时填写浏览器使用的完整 HTTPS Origin，例如 `https://dsh.toolman.me`。默认端口只绑定到宿主回环地址：

```text
127.0.0.1:56789 -> container:8080
```

在 1Panel 中创建 HTTPS 网站，并反向代理到：

```text
http://127.0.0.1:56789
```

反向代理需要保留 `Host`、`X-Forwarded-Host`、`X-Forwarded-Proto`、`X-Forwarded-For`，并支持 WebSocket Upgrade。应用内部保持 HTTP，TLS 由 1Panel OpenResty 终止。

没有域名时也可以使用 IP，但外层代理仍需提供与该 IP 匹配或已被客户端信任的 HTTPS 证书，再把外部地址设置为对应的 `https://<IP>:<端口>`。本应用包不开放纯 HTTP 登录模式。

## 安装参数

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `PANEL_APP_BIND_ADDRESS` | `127.0.0.1` | OpenResty 反代时保留回环地址；`0.0.0.0` 会扩大网络暴露面 |
| `PANEL_APP_PORT_HTTP` | `56789` | 宿主 Web 端口 |
| `TZ` | `Asia/Shanghai` | 容器时区；不挂载宿主 `/etc/localtime` |
| `DSH_PUBLIC_URL` | 无 | 必填的完整 HTTPS Origin，不支持子路径 |
| `DSH_AUTH_USERNAME` | `admin` | 网页登录用户名 |
| `DSH_AUTH_PASSWORD` | 无（必填） | 至少 12 个字符；请使用密码管理器生成并保存 |
| `DSH_AUTH_TOKEN_LIFETIME` | `3600` | 新签发登录令牌和 Cookie 的有效期 |
| `DSH_TRUSTED_HOSTS` | 空 | 可选的附加可信主机 authority，逗号分隔 |
| `DOCKER_SOCK_PATH` | `/dev/null` | Docker Socket 开关；选择 `/var/run/docker.sock` 后授予宿主 Docker 控制权 |

`AUTH_MODE=caddy-security`、`AUTH_COOKIE_INSECURE=false`、容器入口端口 `8080` 和遥测关闭开关由应用包固定。

## 数据持久化

应用只创建一个名为 `deepseek-harness-workstation-data` 的 Docker 卷，并将它挂载到容器 `/data`。镜像入口会在卷内准备以下目录：

| 卷内目录 | 用途 |
| --- | --- | --- |
| `/data/auth` | 登录账号数据库和 JWT 签名密钥 |
| `/data/caddy` | Caddy 配置与运行状态 |
| `/data/dsh` | DeepSeek Harness 状态 |
| `/data/home` | 用户 HOME、缓存和开发工具状态；`/home/node` 指向此目录 |
| `/data/workspace` | 用户项目与工作区；`/workspace` 指向此目录 |

镜像以 root 启动，仅用于准备卷内目录和可选 Docker Socket 组，然后以 UID/GID `1000:1000` 运行 DeepSeek Harness 与 Caddy。入口会拒绝把 `/data/home` 或 `/data/workspace` 符号链接到其他位置。1Panel 卸载不会删除该卷；升级、卸载或迁移前请备份 `deepseek-harness-workstation-data`。

## 沙箱与 Docker Socket

默认的 `no-new-privileges` 配置可运行 DeepSeek Harness 的 Landlock 沙箱，不需要 `privileged`、`seccomp=unconfined` 或 `apparmor=unconfined`。工作区写入、只读和完全访问模式由 DSH 在应用内部切换。

Docker Socket 默认通过 `/dev/null` 禁用。启用 `/var/run/docker.sock` 后，容器内 `node` 用户可通过 Docker CLI、Compose 和 Buildx 操作宿主 Docker 守护进程，效果近似宿主 root 权限。只应对可信用户启用，并避免让不可信仓库、脚本或模型工具访问该工作站。

## 鉴权说明

访问外部地址后会跳转到 `/auth/login`。登录表单支持浏览器密码管理器，除 `/healthz` 外的应用页面和 WebSocket 都受鉴权保护。Caddy 本地账号数据库保存 bcrypt 密码哈希，JWT 签名密钥保存在 `/data/auth` 中。为支持 1Panel 密码表单，提交的明文密码仍会存在于 1Panel 生成的 `.env` 和 Docker 容器配置中，宿主 root、1Panel 与 Docker 管理员可读取；镜像会在启动后从 DSH/Caddy 子进程环境中移除该值。

The local Caddy account database stores a bcrypt password hash and keeps its JWT signing key under `/data/auth`. To support the 1Panel password form, the submitted plaintext password remains in the panel-generated `.env` and Docker container configuration, where host root, 1Panel, and Docker administrators can read it; the image removes the value from the DSH and Caddy child-process environments after startup.

镜像不额外内置登录限速插件。公网部署请在 Cloudflare、1Panel WAF 或外层 OpenResty 对 `/auth/login` 和 `/auth/sandbox/*` 设置限速；使用基于客户端 IP 的规则前，请先正确配置可信真实客户端 IP 转发链。

The image does not add a separate login rate-limit plugin. For public deployments, rate-limit `/auth/login` and `/auth/sandbox/*` in Cloudflare, the 1Panel WAF, or the outer OpenResty layer, and configure the trusted real-client-IP chain before applying IP-based limits.

如果 DeepSeek Harness 后续加入原生密码鉴权，镜像保留的 `dsh` 模式会继续 fail-closed，待包装契约明确后再切换，不会自动叠加两套鉴权。

## 镜像与源码

- 应用版本：`latest`
- 镜像：`moelin/deepseek-harness:workstation`
- DeepSeek Harness：<https://github.com/deepseek-ai/deepseek-harness>
- 镜像构建源码：<https://github.com/okxlin/release-factory/tree/da111a430655c96ee31c9d97a19180511ded25ea/deepseek-harness-builder>
