# DeepSeek Harness Workstation

## 产品介绍

DeepSeek Harness Workstation 是带网页登录、持久化开发目录和完整开发工具链的 DeepSeek Harness 工作站。镜像封装 `@deepseek-ai/dsh 0.1.0-rc.6`，由 Caddy Security 提供表单登录，并针对 1Panel OpenResty HTTPS 反向代理进行了配置。

## 主要功能

- 浏览器表单登录，用户名和密码字段支持浏览器密码管理器
- DeepSeek Harness Web UI、终端、会话、工具和 WebSocket
- Python、Go、Rust、C/C++ 编译器及常用开发 CLI
- Docker CLI、Compose 和 Buildx；Docker Socket 默认禁用，可显式启用
- `/data`、`/workspace` 和 `/home/node` 持久化
- 支持 `amd64` 和 `arm64`

## Introduction

DeepSeek Harness Workstation packages DeepSeek Harness with browser-based form login, persistent development directories, and a complete developer toolchain. It is designed to run behind a 1Panel OpenResty HTTPS reverse proxy.

## Features

- Password-manager-compatible browser login
- DeepSeek Harness Web UI, terminal, sessions, tools, and WebSocket support
- Python, Go, Rust, C/C++, and common development CLIs
- Docker CLI, Compose, and Buildx, with host Docker access disabled by default
- Persistent `/data`, `/workspace`, and `/home/node`
- `amd64` and `arm64` images

## 部署说明

本应用面向“外层 HTTPS、内层 HTTP”的反向代理部署：

1. 在 1Panel 中安装应用，默认监听 `127.0.0.1:56789`。
2. 填写完整的公网 HTTPS Origin，例如 `https://dsh.toolman.me`。不支持子路径。
3. 在 1Panel 网站中把该域名反向代理到 `http://127.0.0.1:56789`。
4. 保留 Host、`X-Forwarded-Proto` 和 WebSocket Upgrade/Connection 转发。

1Panel OpenResty 使用 host 网络时，`127.0.0.1` 会指向宿主机，默认配置可直接使用。如果外层反向代理运行在普通容器网络中，应改用可达的宿主地址，或把绑定地址调整为 `0.0.0.0` 并配合防火墙限制来源。

## 安装参数

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | `56789` | 宿主 Web 端口 |
| `BIND_ADDRESS` | `127.0.0.1` | 默认只允许宿主反向代理访问；`0.0.0.0` 会扩大网络暴露面 |
| `APP_TIMEZONE` | `Asia/Shanghai` | 映射为容器内 `TZ`，供终端和开发工具使用的 IANA 时区 |
| `PUBLIC_URL` | 无 | 必填的完整 HTTPS Origin，例如 `https://dsh.example.com` |
| `AUTH_USERNAME` | `admin` | 网页登录用户名 |
| `AUTH_PASSWORD` | 无 | 必填，至少 12 个字符；镜像会存储 bcrypt 哈希而非明文 |
| `AUTH_TOKEN_LIFETIME` | `3600` | 新签发登录令牌和 Cookie 的有效期，可选 1、8 或 24 小时 |
| `DOCKER_SOCK_SRC` | `/dev/null` | Docker Socket 开关；选择 `/var/run/docker.sock` 后授予宿主 Docker 控制权 |

`AUTH_MODE=caddy-security`、`AUTH_COOKIE_INSECURE=false`、外层端口 `8080` 和 DSH 内部回环端口 `3080` 由应用包固定，不需要在安装表单中配置。

## 访问说明

访问 `PUBLIC_URL` 后会跳转到 `/auth/` 登录页。输入安装表单中的用户名和密码即可进入 DeepSeek Harness。密码更新后重建容器，镜像入口会幂等更新持久化的本地账号数据库；JWT 签名密钥保存在 `/data` 中，重启不会旋转。会话有效期变更会用于之后新签发的登录令牌和 Cookie。

健康检查地址为 `/healthz`，该路径不要求登录；其他应用页面及 WebSocket 均受鉴权保护。

## 通过 IP 访问

应用包默认要求 HTTPS，并保留 `Secure`、`HttpOnly` 和 `SameSite=Strict` Cookie。没有域名时，可以在外层反向代理上为 IP 配置 HTTPS；若使用自签证书，需要先让访问设备信任该证书，再把 `PUBLIC_URL` 设置为对应的 `https://<IP>:<端口>` Origin。

本应用包故意不开放纯 HTTP 模式。当前 caddy-security 在 `AUTH_COOKIE_INSECURE=true` 时不仅移除 `Secure`，还会移除 `HttpOnly`，因此不适合作为公网默认配置。

## Docker Socket

Docker Socket 默认通过 `/dev/null` 禁用。启用 `/var/run/docker.sock` 后，容器内 `node` 用户可通过 Docker CLI、Compose 和 Buildx 操作宿主 Docker 守护进程，效果近似宿主 root 权限。只应对可信用户启用，并避免让不可信仓库、脚本或模型工具访问该工作站。

## 数据持久化

| 宿主或卷 | 容器路径 | 内容 |
| --- | --- | --- |
| `deepseek-harness-workstation-state` | `/data` | 鉴权数据库、JWT、Caddy 和 DSH 状态 |
| `deepseek-harness-workstation-workspace` | `/workspace` | 用户项目与工作区 |
| `deepseek-harness-workstation-home` | `/home/node` | 用户 HOME、缓存和开发工具状态 |

镜像以 root 启动，仅用于准备上述目录和可选 Docker Socket 组，然后以 UID/GID `1000:1000` 运行 DeepSeek Harness 与 Caddy。三个卷均使用固定名称；卸载脚本只停止并移除容器和网络，不删除这些持久卷。

升级、卸载或迁移前，请备份 `deepseek-harness-workstation-state`、`deepseek-harness-workstation-workspace` 和 `deepseek-harness-workstation-home`。

## 资源说明

经过鉴权的 amd64 空闲运行约占用 `170-180 MiB` 内存和约 20 个 PID。workstation 工具链空闲时不会显著增加内存，但镜像未压缩本地尺寸约为 `2.6 GB`，首次拉取需要相应磁盘和网络空间。

## 安全边界

- DeepSeek Harness 仅监听容器回环地址 `127.0.0.1:3080`，Caddy 是容器唯一公开监听器。
- Compose 启用 `no-new-privileges`，阻止工作站进程通过 setuid 或文件 capability 获得新权限。
- 登录密钥不会传递给 DeepSeek Harness 子进程。
- 伪造 Bearer 或身份转发头不能绕过 Caddy Security。
- 镜像构建移除了未使用的 OpenPGP 解析器，并对 pnpm、Caddy Go 依赖和最终镜像执行安全门禁。
- 如果 DeepSeek Harness 以后加入原生密码鉴权，镜像的保留 `dsh` 模式会先保持 fail-closed，待包装契约明确后再切换，不会自动叠加两套登录。

## 镜像与版本

- 应用版本：`latest`
- 发布镜像：`moelin/deepseek-harness:workstation`
- 当前验证版本：`@deepseek-ai/dsh 0.1.0-rc.6`
- 镜像构建源码：<https://github.com/okxlin/release-factory/tree/2ad944e6e60a357fc752ab8135e3422512296b21/deepseek-harness-builder>

## 参考资料

- DeepSeek Harness：<https://github.com/deepseek-ai/deepseek-harness>
- 镜像文档：<https://github.com/okxlin/release-factory/blob/2ad944e6e60a357fc752ab8135e3422512296b21/deepseek-harness-builder/README.md>
- 构建 PR：<https://github.com/okxlin/release-factory/pull/38>
