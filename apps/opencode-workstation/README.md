# OpenCode Workstation

## 产品介绍

这是一个按 1Panel v2 应用商店目录组织的 OpenCode 运行环境。容器封装了持久化存储、运行时模式切换、oh-my-opencode 自动安装等能力，可在 1Panel 上快速部署一个带 Web UI 或 ACP 接口的 OpenCode 工作节点。

## 主要功能

- **持久化存储**：工作区、配置、缓存、运行时数据分别独立挂载，容器重建不丢失
- **双模式运行**：`serve`（Web UI）和 `acp`（agent<->agent 协议）两种模式
- **oh-my-opencode 集成**：支持单次执行或持久化安装，配套 DCP / GPT Unlocked 插件可选
- **多 provider 支持**：OpenAI、Anthropic、OpenRouter、Gemini 等 API Key / Base URL 均可通过表单配置
- **Docker 套接字可选**：通过表单可配置是否挂载宿主机 Docker 套接字

## 访问说明

- Web / serve 默认端口：`http://<host>:4096`
- ACP 默认端口：`8765`
- `serve` 模式适合通过 1Panel 反向代理后再对外提供访问
- `acp` 端口用于 ACP transport，不适合用浏览器页面探活

## 环境变量

所有敏感信息（API Key 等）通过表单中的 `password` 字段填写，写入 `.env` 文件。容器启动后由 `entrypoint.sh` 动态注入 OpenCode 配置。

## 内部升级指南

这个镜像的升级分成两部分：

- **OpenCode userland**：升级 `opencode-ai` 本体
- **oh-my-opencode**：刷新插件、安装脚本和相关配置逻辑

### 重建容器会更新什么

重建容器会拉取最新镜像，但**不会保证自动升级已持久化的 OpenCode 本体**。

原因是容器启动时：
- `OPENCODE_BOOTSTRAP=1` 只会在 `opencode` 不存在时执行首次安装
- 如果 `/data/opencode` 里已经有现成的 `opencode`，bootstrap 会直接跳过
- `OMO_AUTO_INSTALL=1` 则会在每次启动时重新执行 `oh-my-opencode` 安装/刷新流程

所以真实效果是：
- **重建容器**：一定会更新镜像层
- **OpenCode 本体**：已存在时默认不会自动升级
- **oh-my-opencode**：开启自动安装时会刷新

### 手动升级 OpenCode userland

如果你要升级已持久化的 OpenCode 本体，应直接在容器内执行：

```bash
docker exec -it <container_name> bash
/app/scripts/update-opencode-userland.sh
```

升级完成后，可检查版本文件：

```bash
cat /data/state/oh-my-opencode-bootstrap/opencode.version
```

### 刷新 oh-my-opencode

如果你希望同步最新的 `oh-my-opencode` 安装逻辑、插件注册和配置刷新，有两种方式：

#### 方式一：重建容器

前提：
- `启动时自动安装 oh-my-opencode = true`

执行：
1. 打开 1Panel → 已安装应用 → OpenCode Workstation
2. 点击 **重建**

#### 方式二：容器内手动刷新

```bash
docker exec -it <container_name> bash
bunx oh-my-opencode install --no-tui ...
bunx oh-my-opencode doctor
```

### 什么时候用哪种方式

- **只更新 OpenCode 本体**：执行 `/app/scripts/update-opencode-userland.sh`
- **只刷新 oh-my-opencode 行为**：重建容器，或手动重新执行 `bunx oh-my-opencode install ...`
- **安装指定版本**：
  - `OpenCode Package` 主要影响首次安装，或清空 `/data/opencode` 后重新安装
  - `oh-my-opencode Package` 可配合重建容器或手动安装流程生效
- **镜像层也要更新**：在 1Panel 里重建容器

### 在 1Panel 里重建容器

1. 1Panel 应用商店 → 已安装应用 → OpenCode Workstation → 参数/重建
2. 按当前表单参数重新创建容器

### 持久化数据说明

容器数据按功能拆分挂载，重建容器不会丢失：
- `APP_DATA_DIR_1`（./data/workspace）：工作区代码
- `APP_DATA_DIR_2`（./data/config）：OpenCode 配置
- `APP_DATA_DIR_3`（./data/cache）：npm/opencode 缓存
- `APP_DATA_DIR_4`（./data/runtime）：运行时数据

销毁容器时若勾选"删除数据目录"才会丢失持久化数据。

## 表单填写指南

### 必填字段

| 字段 | 说明 |
|---|---|
| Serve Port | Web UI 访问端口，默认 4096 |
| ACP Port | ACP 协议端口，默认 8765 |
| 时区 | 容器时区，默认 `Asia/Shanghai` |
| 工作区/配置/缓存/运行时挂载目录 | 四个数据持久化目录，默认挂载到 `./data/` 下 |
| 运行模式 | `serve`（Web UI）或 `acp`（协议模式） |

### oh-my-opencode 选项

| 字段 | 说明 |
|---|---|
| Bootstrap OpenCode on Start | 首次运行此开关打开即自动安装 OpenCode 本体 |
| 启动时自动安装 oh-my-opencode | 默认开启，自动安装 oh-my-opencode 及其配套插件 |
| Install DCP Plugin | 启用 DCP（分布式代码处理）插件，默认开启 |
| Install GPT Unlocked Plugin | 启用 GPT Unlocked 插件，默认开启 |
| Claude / Gemini / Copilot Install Mode | 控制各模型 provider 的安装模式 |
| Extra Install Args | 传递给 oh-my-opencode 安装脚本的额外参数 |
| OpenCode Package | 默认为 `opencode-ai`；可改为 `opencode-ai@版本`，主要用于首次安装或重装 |
| oh-my-opencode Package | 默认为 `oh-my-opencode`；可改为 `oh-my-opencode@版本` |

### API Key 填写

| 字段 | 说明 |
|---|---|
| OpenAI API Key + Base URL | 填写 OpenAI 或兼容第三方接口（vLLM、LiteLLM、Ollama 等）的 Key 与地址 |
| Anthropic / OpenRouter / Gemini | 对应 provider 的 Key 与自定义地址（若有） |
| GitHub Token | 用于 Git 操作（拉取私有仓库等） |
| Git Author / Committer | 容器内 Git 提交的作者信息 |

### 高级选项

| 字段 | 说明 |
|---|---|
| OpenCode Default Model / Small Model | 覆盖 OpenCode 默认使用的模型 ID |
| OpenCode Provider ID Override | 覆盖默认 provider ID |
| OpenCode Extra Plugins | 额外注册的 OpenCode 插件（逗号分隔的 npm 包名） |
| Docker 套接字路径 | 留空等于不挂载 Docker 套接字 |

## Introduction

A persistent OpenCode workstation packaged as a 1Panel v2 app. Supports serve and ACP modes, oh-my-opencode auto-install, and multi-provider LLM configuration through the deployment form.

## Features

- Persistent volumes for workspace, config, cache, and runtime data
- Switchable serve (Web UI) and ACP (agent protocol) modes
- oh-my-opencode integration with DCP and GPT Unlocked plugins
- Multi-provider support via form fields (OpenAI, Anthropic, OpenRouter, Gemini)
- Optional Docker socket mount
- git author identity configuration
