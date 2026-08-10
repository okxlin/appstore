# Codex Claude Workstation

## 产品介绍

Codex Claude Workstation - 浏览器可访问的 Codex + Claude AI 编程工作站。

英文说明：Browser-accessible Codex + Claude AI workstation.

## 主要功能

- 通过 code-server 在浏览器中使用 VS Code、Codex CLI 和 Claude Code
- 持久化工作区、用户 HOME、Codex、Claude 和 Paseo 配置
- 通过 Paseo Web UI 在手机上查看并继续 Codex 会话
- 保留 Docker CLI、Docker Socket、sudo 和 Codex 沙箱所需的现有运行权限

## Introduction

Codex Claude Workstation provides a browser-accessible VS Code environment with Codex CLI, Claude Code, persistent developer state, and an HTTPS-ready Paseo endpoint for mobile session control.

## Features

- Browser-based VS Code through code-server
- Codex CLI and Claude Code preinstalled
- Persistent workspace and agent configuration
- Password-protected Paseo Web UI for mobile Codex sessions
- Existing Docker Socket, sudo, seccomp, and AppArmor behavior retained

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 访问说明

- code-server：访问 `http://<服务器地址>:<PANEL_APP_PORT_HTTP>`，使用 `CODE_SERVER_PASSWORD` 登录
- Paseo：先配置 HTTPS 反向代理到 `127.0.0.1:<PANEL_APP_PORT_PASEO>`，再从手机访问反向代理域名
- Paseo daemon 的内部端口 `6768` 不对外提供服务

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 访问端口 | 8080 | 是 |
| PANEL_APP_PORT_PASEO | Paseo 本机反向代理端口，仅绑定 `127.0.0.1` | 6767 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOCKER_SOCK_SRC | Docker 套接字路径（留空禁用） | /var/run/docker.sock | 否 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| CUSTOM_ENV_FILE | 自定义环境变量文件 | ./data/custom.env | 否 |

`/home/dev` 使用 `codex-home` 命名卷持久化。卸载脚本会保留该命名卷和上述绑定目录；如需彻底删除，请先确认其中不再有 Codex、Claude、Paseo 会话或配置数据，再手动清理。

升级或迁移前，请在 1Panel 中备份上述数据目录和 `codex-home` 卷。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CODE_SERVER_PASSWORD | code-server 密码 | change-me | 是 |
| PASEO_PASSWORD | Paseo 手机远程访问密码；留空时沿用 code-server 密码 | 空（仅兼容旧安装） | 否 |
| ROOT_PASSWORD | Root 密码 | codex2024 | 否 |
| FIX_WORKSPACE_OWNERSHIP_RECURSIVE | 递归修复工作区权限 | false | 是 |
| GITHUB_TOKEN | GitHub 访问令牌 | - | 否 |
| GIT_AUTHOR_NAME | Git 作者名 | - | 否 |
| GIT_AUTHOR_EMAIL | Git 作者邮箱 | - | 否 |
| GIT_COMMITTER_NAME | Git 提交者名 | - | 否 |
| GIT_COMMITTER_EMAIL | Git 提交者邮箱 | - | 否 |

## 使用说明
### 首次登录

安装完成后进入容器执行 Codex 登录：

```bash
docker exec -it ${CONTAINER_NAME} bash
codex login --device-auth
```

### 手机远程 Codex

Paseo 在容器内由安全代理监听 `6767`，Compose 只把该端口发布到宿主机回环地址。公网服务器不要直接开放 6767；请在 1Panel 中创建 HTTPS 反向代理：

- 上游地址：`http://127.0.0.1:<PANEL_APP_PORT_PASEO>`，默认是 `http://127.0.0.1:6767`
- 开启 WebSocket，并保留 HTTP/1.1 的 `Upgrade` 与 `Connection` 请求头
- 为长时间 Codex 会话设置较长的代理读取和发送超时
- 使用 `openssl rand -hex 24` 生成独立密码，粘贴到 `PASEO_PASSWORD`
- 手机访问反向代理的 HTTPS 域名，并输入该密码

容器内部的 Paseo daemon 端口 `6768` 仅监听回环地址，不应映射或反向代理。Paseo relay、语音模式和本地语音模型自动下载默认关闭。

`PASEO_SERVICE_PROXY_ENABLED=false` 不会移除 Paseo 内置的 localhost Service Proxy 路由分类；真正的隔离边界是容器内 6767 端口上的固定 Host Nginx。不要绕过 6767 直接连接、映射或反向代理 6768。

Paseo 浏览器客户端会把密码直接放进 WebSocket 子协议，因此不能使用任意符号组合。最简单可靠的格式是 40-128 位十六进制字符串；空格以及 `@`、`:`、`/`、`=`、逗号等 HTTP 分隔字符不兼容。1Panel 新安装会在 Compose 启动前拒绝非空但不兼容或少于 20 位的 Paseo 密码。此字段特意不使用 1Panel 的通用 `random: true`，因为当前 `dev-v2@1b76c91e` 实现[固定只追加 6 个字符](https://github.com/1Panel-dev/1Panel/blob/1b76c91e1b92705ed6662d0a361230ff0f7fb817/frontend/src/views/app-store/detail/params/index.vue#L219-L224)，且[生成器使用 `Math.random()`](https://github.com/1Panel-dev/1Panel/blob/1b76c91e1b92705ed6662d0a361230ff0f7fb817/frontend/src/utils/id.ts#L3-L9)，不能作为公网强密码来源。

旧安装升级后若 `.env` 中没有 `PASEO_PASSWORD`，升级脚本会补充空值并继续沿用原有 `CODE_SERVER_PASSWORD`，不会重写旧密码。如果旧密码包含上述不兼容字符，code-server 仍可访问，但 Paseo 健康检查会显示异常，手机连接也会失败；在 1Panel 中设置独立、兼容的 `PASEO_PASSWORD` 并重建容器即可恢复。

新安装只接受应用目录内的相对 `APP_DATA_DIR` 和 `CUSTOM_ENV_FILE`。升级脚本会在修改 `.env` 前拒绝符号链接、目录或绝对 `CUSTOM_ENV_FILE`；旧安装若曾配置绝对自定义环境文件，请先把该文件迁移到应用目录内（例如 `./data/custom.env`）并更新配置，再执行升级。已有 `codex-home` 卷和工作区数据不会由升级或卸载脚本删除。

### 注意事项

- 不支持 Chat Completions-only API（必须支持 OpenAI Responses API）
- 首次安装后需在 code-server 终端执行 `codex login` 认证
- 不默认启动 Codex App Server
- 容器以 `dev` 用户运行（非 root），可通过 ROOT_PASSWORD 切换至 root
- 代理默认不启动，按需通过 `supervisorctl start clash-meta|sing-box|xray` 启用
- Paseo 使用单一密码鉴权，不提供 MFA、RBAC 或独立设备令牌；公网使用时必须启用 HTTPS，并使用与 code-server 不同的强密码
- Compose 保留 Docker Socket、`seccomp=unconfined` 和 `apparmor=unconfined`，以维持现有 Docker/Codex 沙箱能力；这会扩大容器对宿主机的控制面，请只授予可信用户访问权限
- 使用第三方 LLM provider 或中转站时，不要让模型直接处理未脱敏的密钥、token、私有配置；保留或启用 Docker Socket 前请确认你接受宿主 Docker 控制权暴露给容器内工具链的风险

## 参考资料
- 官网: <https://github.com/openai/codex>
- 源码: <https://github.com/okxlin/release-factory>
- Paseo WebSocket 密码传递: <https://github.com/getpaseo/paseo/blob/bfec7ac3adc5e8835e873ee75c7b325af6c7a8c3/packages/client/src/daemon-client.ts#L1255>
- WebSocket/HTTP token 语法: <https://www.rfc-editor.org/rfc/rfc6455.html#section-11.3.4>、<https://www.rfc-editor.org/rfc/rfc9110.html#section-5.6.2>
