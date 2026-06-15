# Codex Claude Workstation

## 产品介绍

浏览器可访问的 Codex AI 编程工作站，集成 code-server (VS Code) 和丰富的开发工具链。

## 主要功能

- **code-server (VS Code)** — 浏览器内完整 VS Code 体验
- **Codex CLI** — OpenAI Codex AI 编程助手
- **Claude Code** — Anthropic Claude Code CLI
- **开发工具链** — Go, Rust, Bun, Docker CLI, yq, gh, shellcheck 等 30+ 工具
- **代理支持** — 通过 supervisord 按需启用 Clash.Meta/sing-box/Xray

## Introduction

Browser-accessible Codex AI development workstation with code-server (VS Code) and rich dev toolchain.

## Features

- **code-server (VS Code)** — Full VS Code experience in browser
- **Codex CLI** — OpenAI Codex AI coding assistant
- **Claude Code** — Anthropic Claude Code CLI
- **Dev Toolchain** — Go, Rust, Bun, Docker CLI, yq, gh, shellcheck, 30+ tools
- **Proxy Support** — On-demand Clash.Meta/sing-box/Xray via supervisord

## 安装说明

镜像由 `codex-claude-workstation-builder` 预先编译，发布在：

```
ghcr.io/okxlin/codex-claude-workstation:latest
```

1Panel 安装时自动拉取，无需手动构建。

## 参数填写指南

### 必填参数

**`PANEL_APP_PORT_HTTP`** — Web 访问端口
- code-server 对外暴露的访问端口
- 默认 `8080`，可改为任意未占用端口
- 安装后通过 `http://你的IP:此端口` 访问

**`CODE_SERVER_PASSWORD`** — code-server 密码
- 登录 code-server 时使用的密码
- 默认 `change-me`，请务必修改

**`ROOT_PASSWORD`** — Root 用户密码
- 容器 root 用户的密码（可通过 `su - root` 切换登录）
- 默认 `codex2024`，建议修改为更强的密码

**`APP_DATA_DIR`** — 数据目录
- 工作区文件存放的宿主机目录
- 默认 `./data`，建议填写绝对路径如 `/data/codex-workstation

### 可选参数

**`DOCKER_SOCK_SRC`** — Docker 套接字路径
- 挂载宿主机 Docker Socket 到容器内 `/var/run/docker.sock`
- 默认 `/var/run/docker.sock`，留空则禁用 Docker CLI
- 必须先通过 ROOT_PASSWORD 切换至 root 才可使用 Docker CLI

**`TZ`** — 时区
- 默认 `Asia/Shanghai`
- 可选，留空使用系统默认

### 不在安装表单中的参数

**`PROXY_ENABLED`** — 代理 (手动启用)
- 默认不启动；内置 clash-meta / sing-box / xray 二进制
- 通过 `supervisorctl start clash-meta|sing-box|xray` 按需启用
- 代理配置文件放入 `/home/dev/proxy/`（持久化），如 `clash-meta.yaml` / `sing-box.json` / `xray.json`

## 访问说明

安装完成后通过分配的端口访问：

- `http://IP:端口` — code-server (VS Code)，集成终端在 VS Code 内使用

## 首次登录

安装完成后进入容器执行 Codex 登录：

```bash
docker exec -it ${CONTAINER_NAME} bash
codex login --device-auth
```

## 认证说明

code-server 密码认证（单层）：

1. **code-server 密码** — VS Code 登录时使用的密码

## 数据持久化

| 数据 | 路径 | 持久化方式 |
|------|------|-----------|
| 工作区 | `/workspace` | 绑定挂载到数据目录 |
| Codex 配置 | `/home/dev/.codex` | Named volume `codex-home` |
| 代理配置 | `/home/dev/proxy/` | Named volume `codex-home` |
| code-server 配置 | `/home/dev/.config/code-server/` | Named volume `codex-home` |
| 本地二进制 | `/home/dev/.local/bin/` | Named volume `codex-home` |

## 注意事项

- 不支持 Chat Completions-only API（必须支持 OpenAI Responses API）
- 首次安装后需在 code-server 终端执行 `codex login` 认证
- 不默认启动 Codex App Server
- 容器以 `dev` 用户运行（非 root），可通过 ROOT_PASSWORD 切换至 root
- 代理默认不启动，按需通过 `supervisorctl start clash-meta|sing-box|xray` 启用
