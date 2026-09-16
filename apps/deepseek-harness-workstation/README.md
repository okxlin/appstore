# DeepSeek Harness Workstation

## 产品介绍

DeepSeek Harness Workstation 为 DeepSeek Harness 提供带网页登录的浏览器工作站，适合部署在 1Panel OpenResty HTTPS 反向代理之后。工作站同时提供持久化的应用状态、用户 HOME、项目工作区和常用开发工具链。

镜像支持 amd64 与 arm64，内置 Node.js、pnpm、Python、Go、C/C++ 工具链，以及 Docker CLI、Compose 和 Buildx。

## 主要功能

- 浏览器密码管理器可用的网页登录
- 源站登录限速与可信代理链解析
- DeepSeek Harness Web UI、终端、会话、工具和 WebSocket
- 持久化应用状态、用户 HOME 与项目工作区
- Docker CLI、Compose 和 Buildx；宿主 Docker 守护进程访问默认关闭

## 访问说明

安装时填写浏览器实际使用的完整 HTTPS Origin，例如 `https://dsh.example.com`。不支持子路径部署。

建议保持 1Panel 的“端口外部访问”关闭，让应用只通过宿主回环地址访问。然后在 1Panel 中创建 HTTPS 网站，反向代理到：

```text
http://127.0.0.1:<应用端口>
```

反向代理需要保留 `Host`、`X-Forwarded-Host`、`X-Forwarded-Proto` 和 `X-Forwarded-For`，并支持 WebSocket Upgrade。应用容器内部使用 HTTP，TLS 由 1Panel OpenResty 终止。

`/healthz` 可用于无登录健康检查；其他页面和 WebSocket 需要登录。没有域名时可以使用 IP Origin，但外层代理仍需提供客户端信任的 HTTPS 证书。

### 安装参数

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | `56789` | 宿主 Web 端口 |
| `TZ` | `Asia/Shanghai` | 容器时区 |
| `DSH_PUBLIC_URL` | 无 | 必填的完整 HTTPS Origin，不支持子路径 |
| `DSH_AUTH_USERNAME` | `admin` | 网页登录用户名 |
| `DSH_AUTH_PASSWORD` | 无（必填） | 至少 12 个字符，建议使用密码管理器生成 |
| `DSH_AUTH_TOKEN_LIFETIME` | `604800` | 登录令牌和 Cookie 有效期，需按实际需要设置 |
| `CADDY_TRUSTED_PROXIES` | `private_ranges` | 可信代理 CIDR；客户端直连时可设为 `none` |
| `DSH_TRUSTED_HOSTS` | 空 | 可选的附加可信主机 authority，逗号分隔 |
| `DOCKER_SOCK_PATH` | `/dev/null` | Docker Socket 开关；启用时填写 `/var/run/docker.sock` |

## 数据持久化

| 持久化来源 | 容器路径 | 用途 |
| --- | --- | --- |
| `./data/data` | `/data` | 鉴权、Caddy 和 DeepSeek Harness 应用状态 |
| `./data/workspace` | `/workspace` | 项目文件与默认工作区 |
| `dsh-home` | `/home/node` | 用户安装的软件、Shell 配置和工具缓存 |

首次安装不需要手工创建这些目录。升级或迁移前请备份 `./data/data`、`./data/workspace` 和 `dsh-home`。卸载脚本默认只移除 Compose 运行资源并保留这些持久化数据；不要在未确认备份的情况下执行 `docker compose down --volumes` 或删除 `dsh-home`。

## 安全与部署风险

- `DOCKER_SOCK_PATH` 默认指向 `/dev/null`。启用宿主 Docker Socket 后，工作站内的 Docker CLI、Compose 和 Buildx 可以控制宿主 Docker 守护进程，等效风险接近宿主 root；仅应为可信用户启用。
- Compose 固定使用 `no-new-privileges`，不需要 `privileged`、`seccomp=unconfined` 或 `apparmor=unconfined` 才能运行默认沙箱功能。
- 不要把应用端口直接暴露到公网；公网访问应由 HTTPS 反向代理和外层认证/限速策略保护。
- 1Panel、Docker 管理员可以读取面板生成的环境变量，其中包含登录密码明文；请按服务器管理员边界管理该应用。

## 源码

- DeepSeek Harness：<https://github.com/deepseek-ai/deepseek-harness>
- 镜像构建源码：<https://github.com/okxlin/release-factory/tree/main/deepseek-harness-builder>
