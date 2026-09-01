# DeepSeek Harness Workstation

## 产品介绍

DeepSeek Harness Workstation 是带网页登录、持久化开发目录和完整开发工具链的 DeepSeek Harness 工作站。镜像封装 DeepSeek Harness，由 [caddy-security](https://github.com/greenpau/caddy-security) 提供表单登录，并通过 [caddy-ratelimit](https://github.com/mholt/caddy-ratelimit) 在源站侧限制认证请求，适合部署在 1Panel OpenResty HTTPS 反向代理之后。

工作站包含 Node.js、pnpm、Python、Go、C/C++ 工具链，以及 Docker CLI、Compose 和 Buildx，支持 `amd64` 与 `arm64`。

## 主要功能

- 支持浏览器密码管理器的表单登录
- 按客户端 IP 的内置登录限速和可信代理链解析
- DeepSeek Harness Web UI、终端、会话、工具与 WebSocket
- 持久化状态、用户 HOME 和工作区
- Docker CLI、Compose 与 Buildx，宿主 Docker 访问默认禁用

## Introduction

DeepSeek Harness Workstation combines DeepSeek Harness, browser-based form authentication, proxy-aware origin-side login rate limiting, persistent development directories, and a complete multi-language toolchain for deployment behind a 1Panel OpenResty HTTPS reverse proxy.

## Features

- Password-manager-compatible browser login
- Built-in per-client login limits with trusted-proxy parsing
- DeepSeek Harness Web UI, terminals, sessions, tools, and WebSockets
- Persistent state, user home, and workspace directories
- Docker CLI, Compose, and Buildx with host daemon access disabled by default

## 访问说明

安装时填写浏览器使用的完整 HTTPS Origin，例如 `https://dsh.example.com`。请保持 1Panel 的“端口外部访问”关闭；1Panel 会把端口绑定到宿主回环地址：

```text
127.0.0.1:56789 -> container:8080
```

在 1Panel 中创建 HTTPS 网站，并反向代理到：

```text
http://127.0.0.1:56789
```

反向代理需要保留 `Host`、`X-Forwarded-Host`、`X-Forwarded-Proto`、`X-Forwarded-For`，并支持 WebSocket Upgrade。应用内部保持 HTTP，TLS 由 1Panel OpenResty 终止。

端口监听地址由 1Panel 内置控制，不由应用表单重复配置。启用“端口外部访问”后，1Panel 会改为监听所有接口或指定 IP；仅通过 OpenResty 反向代理访问时没有必要开启。

没有域名时也可以使用 IP，但外层代理仍需提供与该 IP 匹配或已被客户端信任的 HTTPS 证书，再把外部地址设置为对应的 `https://<IP>:<端口>`。本应用包不开放纯 HTTP 登录模式。

## 安装参数

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | `56789` | 宿主 Web 端口 |
| `TZ` | `Asia/Shanghai` | 容器时区；不挂载宿主 `/etc/localtime` |
| `DSH_PUBLIC_URL` | 无 | 必填的完整 HTTPS Origin，不支持子路径 |
| `DSH_AUTH_USERNAME` | `admin` | 网页登录用户名 |
| `DSH_AUTH_PASSWORD` | 无（必填） | 至少 12 个字符；请使用密码管理器生成并保存 |
| `DSH_AUTH_TOKEN_LIFETIME` | `604800` | 登录令牌和 Cookie 的有效期，默认 7 天，可选最长 30 天；到期后需要重新登录 |
| `CADDY_TRUSTED_PROXIES` | `private_ranges` | Caddy 解析客户端 IP 时信任的代理 CIDR；空格分隔，客户端直连时可设为 `none` |
| `DSH_TRUSTED_HOSTS` | 空 | 可选的附加可信主机 authority，逗号分隔 |
| `DOCKER_SOCK_PATH` | `/dev/null` | Docker Socket 开关；选择 `/var/run/docker.sock` 后授予宿主 Docker 控制权 |

`AUTH_MODE=caddy-security`、`AUTH_COOKIE_INSECURE=false`、容器入口端口 `8080` 和遥测关闭开关由应用包固定。认证限流次数也由镜像固定，不作为安装表单参数。`AUTH_COOKIE_INSECURE` 不开放为表单选项，因为当前 caddy-security 实现启用该值时会同时移除 Cookie 的 `Secure` 与 `HttpOnly` 属性，容易造成不必要的会话暴露。

## 数据持久化

应用使用一个应用状态 bind mount、一个工作区 bind mount，以及一个 HOME named volume：

| 持久化来源 | 容器路径 | 用途 |
| --- | --- | --- |
| `./data/data` | `/data` | 鉴权数据库、JWT 签名密钥、Caddy 状态和 DeepSeek Harness 状态，随 1Panel 应用目录备份 |
| `./data/workspace` | `/workspace` | 用户项目与工作区；该目录与 `./data/data` 同级，便于通过 1Panel 文件管理和应用备份访问 |
| `dsh-home` | `/home/node` | 用户安装的软件、shell 配置、语言工具链缓存和包管理器缓存 |

鉴权状态位于 `/data/auth`，Caddy 状态位于 `/data/caddy`，DeepSeek Harness 状态位于 `/data/dsh`。`/data`、`/home/node` 与 `/workspace` 都是直接挂载的真实目录，不使用符号链接。

镜像工作目录和 `DSH_WORKSPACE` 都默认是 `/workspace`。网页的 **Add workspace** 对话框会从 `/workspace` 打开，其中的 `Home` 快捷入口也指向 `/workspace`；`/home/node` 仅作为用户 HOME 和工具持久卷，不是默认项目目录。

镜像以 root 启动，用于准备挂载目录权限、执行旧状态迁移和设置可选 Docker Socket 组，然后以 UID/GID `1000:1000` 运行 DeepSeek Harness 与 Caddy。首次启动时入口会把 HOME 和 workspace 准备为该用户可写，因此通常不需要手工执行 `chmod` 或 `chown`。

首次安装不需要预先创建 `./data/data`、`./data/workspace` 或 `dsh-home`。当前 Compose 使用的短语法 bind mount 会在源目录不存在时由 Docker 自动创建目录，`dsh-home` named volume 也会自动创建；镜像入口随后会规范化 bind 根目录和应用子目录的权限。因此不需要在 `init.sh` 中额外添加 `mkdir` 或递归 `chown`。

从旧版工作站布局升级时，如果 `/data/auth` 为空，镜像入口会在首次启动时把 `dsh-home:/home/node/.local/share/deepseek-harness` 中的旧鉴权、Caddy 和 DSH 状态复制到 `/data`。迁移不会删除旧 HOME 数据；请先备份 `./data/data` 和 `dsh-home`，确认新版本启动正常后再自行清理旧副本。

从旧版 AppStore 包升级时，已有 `.env` 通常不包含 `CADDY_TRUSTED_PROXIES`。新 Compose 会自动使用 `private_ranges`，因此标准 1Panel/OpenResty 部署无需手工补写该变量，也不会改变 `/data`、`/home/node` 或 `/workspace` 的挂载和数据。升级后可在应用参数中按实际代理链调整该值。`0.1.2-alpha.2` 使用新的 `ghcr.io/okxlin/deepseek-harness` 工作站镜像，现有安装可以直接执行 1Panel 应用升级；升级前仍建议备份应用目录和 `dsh-home`，不要删除旧卷。

1Panel 的应用备份覆盖应用安装目录，因此会包含 `./data/data` 和 `./data/workspace`。独立的 HOME named volume 不在应用目录内，升级、卸载或迁移前如需保留用户安装的工具和缓存，请停止应用并单独备份 `dsh-home`：

```bash
docker run --rm --entrypoint tar \
  -v dsh-home:/source:ro \
  -v "$PWD":/backup \
  ghcr.io/okxlin/deepseek-harness:workstation \
  -C /source -czf /backup/dsh-home.tar.gz .
```

恢复时应保持应用停止，并优先恢复到空的 HOME 卷：

```bash
docker run --rm --entrypoint tar \
  -v dsh-home:/target \
  -v "$PWD":/backup:ro \
  ghcr.io/okxlin/deepseek-harness:workstation \
  -C /target -xzf /backup/dsh-home.tar.gz
```

本应用的卸载脚本只执行 `docker compose down --remove-orphans`，默认保留 `./data/data`、`./data/workspace` 和 `dsh-home`。手工执行 `docker compose down --volumes` 或删除 `dsh-home` 卷会移除 HOME 中的用户工具、配置和缓存，该操作不可恢复。

## 沙箱与 Docker Socket

在支持 Landlock 的 Linux 内核上，默认的 `no-new-privileges` 配置可运行 DeepSeek Harness 沙箱，不需要 `privileged`、`seccomp=unconfined` 或 `apparmor=unconfined`。工作区写入与完全访问模式由 DSH 在应用内部切换。

Docker Socket 默认通过 `/dev/null` 禁用。启用 `/var/run/docker.sock` 后，容器内 `node` 用户可通过 Docker CLI、Compose 和 Buildx 操作宿主 Docker 守护进程，效果近似宿主 root 权限。只应对可信用户启用，并避免让不可信仓库、脚本或模型工具访问该工作站。

## 鉴权说明

访问外部地址后会跳转到 `/auth/login`。登录表单支持浏览器密码管理器，除 `/healthz` 外的应用页面和 WebSocket 都受鉴权保护。Caddy 本地账号数据库保存 bcrypt 密码哈希，JWT 签名密钥保存在 `/data/auth` 中。为支持 1Panel 密码表单，提交的明文密码仍会存在于 1Panel 生成的 `.env` 和 Docker 容器配置中，宿主 root、1Panel 与 Docker 管理员可读取；镜像会在启动后从 DSH/Caddy 子进程环境中移除该值。

Caddy Security 当前不会自动刷新访问令牌。默认登录有效期为 7 天，可在安装表单中选择最长 30 天；有效期结束后需要重新登录。更长有效期也会延长被盗 Cookie 的可用窗口，公网部署应按实际需要选择尽可能短的有效期。

The local Caddy account database stores a bcrypt password hash and keeps its JWT signing key under `/data/auth`. To support the 1Panel password form, the submitted plaintext password remains in the panel-generated `.env` and Docker container configuration, where host root, 1Panel, and Docker administrators can read it; the image removes the value from the DSH and Caddy child-process environments after startup.

镜像会按解析后的客户端 IP 对用户名阶段 POST 限制为每分钟 30 次，对密码阶段 POST 限制为每 10 分钟 10 次；被拒绝的请求返回 HTTP 429 和 `Retry-After`。这些额度是镜像固定值，修改它们需要自定义构建镜像。仍建议在 Cloudflare、1Panel WAF 或外层 OpenResty 保留同类限速，作为纵深防御。

`CADDY_TRUSTED_PROXIES` 控制 Caddy 从右向左解析 `X-Forwarded-For` 时可以信任的代理节点。默认 `private_ranges` 适用于 1Panel/OpenResty 通过 loopback 或私网转发的部署；客户端直接连接 Caddy 时使用 `none`。如果 Cloudflare 或其他 CDN 位于 OpenResty 前，应在外层代理规范化真实客户端 IP，或在该参数中列出所有可信 CDN 和直接上游代理 CIDR。镜像会拒绝不受限制的 `/0` 范围。

The image limits username-stage POSTs to 30 per minute and password-stage POSTs to 10 per 10 minutes for each resolved client IP, returning HTTP 429 with `Retry-After` when blocked. `CADDY_TRUSTED_PROXIES` defaults to `private_ranges` for the documented 1Panel/OpenResty path; use `none` only for direct client connections, and configure every trusted hop or normalize the client IP when a CDN is present. Keep matching limits in the outer WAF or reverse proxy as defense in depth.

如果 DeepSeek Harness 后续加入原生密码鉴权，镜像保留的 `dsh` 模式会继续 fail-closed，待包装契约明确后再切换，不会自动叠加两套鉴权。

## 镜像与源码

- 应用版本：滚动版本 `latest` 与固定版本 `0.1.2-alpha.2`
- 镜像：`latest` 使用 `ghcr.io/okxlin/deepseek-harness:workstation`，固定版本使用匹配的 `<版本>-workstation` tag
- DeepSeek Harness：<https://github.com/deepseek-ai/deepseek-harness>
- 镜像构建源码：<https://github.com/okxlin/release-factory/blob/main/deepseek-harness-builder/README.md>
