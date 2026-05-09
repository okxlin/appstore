# OpenCode Workstation

## 产品介绍

这是一个面向 1Panel 的 OpenCode Workstation 应用，提供可持久化的 OpenCode 运行环境，支持 Web UI（`serve`）和 ACP 接口（`acp`）两种运行模式，并可按需集成 `oh-my-opencode`、DCP、GPT Unlocked 等扩展能力。

## 主要功能

- **官方 HOME 路径持久化**：直接按 OpenCode 官方目录模型运行，减少兼容问题
- **双模式运行**：支持 `serve`（Web UI）和 `acp`（协议模式）
- **oh-my-opencode 集成**：支持自动安装与扩展刷新
- **多 provider 支持**：OpenAI、Anthropic、OpenRouter、Gemini 等可通过表单配置
- **Docker 套接字可选**：可按需挂载宿主机 Docker 套接字

## 访问说明

- Web / serve 默认端口：`http://<host>:4096`
- ACP 默认端口：`8765`
- `serve` 模式适合通过 1Panel 反向代理后再对外访问
- `acp` 端口用于 ACP transport，不适合直接用浏览器访问

## 运行时目录模型

当前应用按 OpenCode 官方 HOME 路径运行：

- `~/.config/opencode`
- `~/.agents`
- `~/.claude`
- `~/.opencode`
- `~/.local/share/opencode`
- `~/.local/share/oh-my-opencode`
- `/workspace`

这样做的原因：

- 与 OpenCode upstream 源码目录发现逻辑一致
- `skills` / `agents` / `claude-compatible` 扩展不需要额外路径翻译
- 避免旧版 `/config -> HOME` 单文件同步漂移
- 后续 upstream 扩展 HOME 目录扫描时兼容风险更低

## 持久化数据说明

应用数据按用途拆分挂载，重建容器不会丢失：

- `APP_DATA_DIR_1`（`./data/workspace`）→ `/workspace`
- `APP_DATA_DIR_2`（`./data/home-config`）→ `/home/opencode/.config`
- `APP_DATA_DIR_3`（`./data/home-share`）→ `/home/opencode/.local/share`
- `APP_DATA_DIR_4`（`./data/home-agents`）→ `/home/opencode/.agents`
- `APP_DATA_DIR_5`（`./data/home-claude`）→ `/home/opencode/.claude`
- `APP_DATA_DIR_6`（`./data/home-opencode`）→ `/home/opencode/.opencode`

其中：

- `home-config`：OpenCode 配置、skills、插件配置
- `home-share`：OpenCode 安装本体、数据库、日志、运行时数据
- `home-agents`：agent-compatible skills / agents
- `home-claude`：claude-compatible skills
- `home-opencode`：OpenCode HOME / project-style 兼容目录

## 表单填写指南

### 必填字段

| 字段 | 说明 |
|---|---|
| Serve Port | Web UI 访问端口，默认 4096 |
| ACP Port | ACP 协议端口，默认 8765 |
| 时区 | 容器时区，默认 `Asia/Shanghai` |
| 各挂载目录 | OpenCode HOME 及工作区持久化目录 |
| 运行模式 | `serve`（Web UI）或 `acp`（协议模式） |

### oh-my-opencode 选项

| 字段 | 说明 |
|---|---|
| Bootstrap OpenCode on Start | 首次运行时自动安装 OpenCode 本体 |
| Auto Install oh-my-opencode | 启动时自动安装 / 刷新 oh-my-opencode |
| Install DCP Plugin | 启用 DCP 插件 |
| Install GPT Unlocked Plugin | 启用 GPT Unlocked 插件 |
| Claude / Gemini / Copilot Install Mode | 控制对应 provider 的安装模式 |
| Extra Install Args | 传递给 oh-my-opencode 安装脚本的额外参数 |

### API Key 填写

| 字段 | 说明 |
|---|---|
| OpenAI API Key + Base URL | OpenAI 或兼容第三方接口的 Key / 地址 |
| Anthropic / OpenRouter / Gemini | 对应 provider 的 Key 与可选自定义地址 |
| GitHub Token | 用于 Git 操作（如拉取私有仓库） |
| Git Author / Committer | 容器内 Git 提交作者信息 |

## 配置分层

推荐按三层使用：

1. **部署级环境变量层**
   - 通过 `.env` / 1Panel 表单注入
   - 适合：`OPENCODE_MODEL`、`OPENCODE_SMALL_MODEL`、`OPENCODE_PROVIDER_ID`、`OPENCODE_EXTRA_PLUGINS`、各类 `*_BASE_URL` / `*_API_KEY`
2. **生成配置层**
   - `~/.config/opencode/opencode.json`
   - 由启动脚本和 `update_opencode_config.py` 动态生成
3. **用户覆盖层**
   - `~/.config/opencode/opencode.user.json` 或 `~/.config/opencode/opencode.user.jsonc`
   - 适合手工追加 provider、models、plugin 高级配置、额外 MCP 条目

## 内部升级说明

重建容器会更新镜像层，但是否重新安装 / 刷新 OpenCode 与 oh-my-opencode，取决于当前表单开关和持久化目录状态。

常见场景：

- **镜像层更新**：在 1Panel 中重建容器
- **刷新 OpenCode 本体**：进入容器执行 `/app/scripts/update-opencode-userland.sh`
- **刷新 oh-my-opencode 行为**：重建容器，或手动重新执行 `bunx oh-my-opencode install --no-tui ...`

## 注意事项

- 不要把真实密钥硬编码进 `opencode.user.json`，优先使用环境变量
- `~/.config/opencode/opencode.json` 是生成产物，不建议长期手工维护
- 若不需要容器内调用 Docker，请将 Docker Socket 路径留空
