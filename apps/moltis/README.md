# Moltis

## 产品介绍

Moltis 是使用 Rust 构建的持久化个人 AI 代理服务器，提供 Web 对话、会话与记忆、定时任务、多渠道接入、语音、技能和模型提供商配置。

## 主要功能

- 在 Web 界面中进行 AI 对话并管理会话、记忆和定时任务
- 配置模型提供商、消息渠道、语音、技能和安全凭据
- 使用持久化数据目录保存认证、配置和运行状态
- 在受限 WASM/WASI 沙箱中执行 agent 命令

## 访问说明

- Web 服务端口默认为 `13131`，OAuth 回调端口默认为 `1455`。
- 应用默认只绑定 `127.0.0.1`，请通过 1Panel 的 HTTPS 反向代理远程访问。容器内部使用 HTTP，由反向代理负责公网 TLS。
- 安装表单会生成登录密码；也可以输入 16 至 128 位的安全密码。首次启动时密码会迁移到 Moltis 的凭据存储。
- 本应用不预置模型提供商或 API 密钥。登录后在设置页面配置所需提供商。

## 运行环境提示

在部分较旧的 x86_64 主机上，Moltis 镜像可能使用主机不支持的 CPU 指令集，并在启动阶段以 `SIGILL`（退出码 132）退出。若容器启动后反复重启且无法访问，请先确认主机 CPU 指令集与当前镜像兼容，必要时回退到可运行版本；这类现象通常不是 1Panel 表单配置错误。

## 数据与备份

`DATA_PATH` 下的 `config` 保存 `moltis.toml`、认证和证书配置，`data` 保存数据库、会话、记忆和运行状态。升级或迁移前应备份整个目录。卸载只移除容器，不删除绑定目录。

## 受限安全模式

此应用包有意采用比上游默认 Docker 示例更严格的部署模式：

- 命令执行由最高优先级环境变量固定为内置 WASM/WASI 沙箱，不挂载 Docker 或 Podman socket。
- 浏览器自动化和宿主 Web 终端由环境变量硬性禁用。
- MCP 变更和远程节点选择的 deny 列表同样由环境变量固定，agent 不能自行绕过。
- 容器根文件系统只读，以 `1000:1001` 运行，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。
- WASM 模式仅支持内置命令和沙箱内的 `.wasm` 程序，不提供任意宿主 Shell。这是本应用通过安全门禁的必要限制。

不要手动启用浏览器、宿主终端、stdio MCP、SSH/节点执行或其他沙箱后端；这些操作会改变已审计边界。初始化和升级脚本会检查规范 TOML 表中的必要设置，而容器环境变量是最终的强制策略，即使现有配置使用 TOML 的其他合法表语法也不能覆盖它们。

## 镜像漏洞说明

2026-07-28 对已审计 amd64 与 arm64 镜像快照的 Trivy 扫描均报告 `9 Critical / 124 High / 0 secrets`。Critical 项来自未被当前进程加载或调用的系统 Perl、SQLite、GLib、libxml2 与 npm CLI node-tar 路径，以及 zlib 中未随 Debian `zlib1g` 运行库提供的 MiniZip 路径；其中 `CVE-2026-8376` 只影响 32 位 Perl。两个重点 Chromium High 需要浏览器进程，而本包不注册 Browser 工具且运行时没有 Chromium 进程。

该例外仅适用于已审计镜像快照、WASM 实际初始化成功、浏览器关闭、无容器运行时 socket、无 enabled stdio MCP 的配置。`latest` 标签解析到新镜像后必须重新审计。启动日志必须包含 `sandbox backend: wasm`；出现 `restricted-host` 或 fallback 日志时应停止使用并重新审计。

## 版本

- `latest` 直接跟随上游移动标签，不固定 digest，以便 Watchtower 等工具拉取更新。
- 固定版本目录中的 `20260723.03` 保留上游同名版本及已审计 digest。评估时两个标签指向同一多架构 OCI index。

## 参考资料

- 项目主页：<https://moltis.org/>
- 项目仓库：<https://github.com/moltis-org/moltis>
- 官方文档：<https://docs.moltis.org/>
- Docker 文档：<https://docs.moltis.org/docker.html>
- 固定版本：<https://github.com/moltis-org/moltis/releases/tag/20260723.03>
- 许可证：<https://github.com/moltis-org/moltis/blob/20260723.03/LICENSE>（MIT）

## Introduction

Moltis is a persistent personal AI agent server written in Rust. It provides web chat, sessions and memory, scheduled tasks, messaging channels, voice features, skills, and model-provider configuration.

## Features

- Chat with an AI agent and manage sessions, memory, and scheduled tasks in the web UI
- Configure model providers, messaging channels, voice, skills, and security credentials
- Persist authentication, configuration, and runtime state in a dedicated data directory
- Execute agent commands inside the restricted WASM/WASI sandbox

## Access

- The web service defaults to port `13131`; the OAuth callback defaults to port `1455`.
- The package binds to `127.0.0.1` by default. Use a 1Panel HTTPS reverse proxy for remote access. Moltis uses HTTP inside the container and the reverse proxy terminates public TLS.
- The installation form generates a login password, or accepts a safe password from 16 to 128 characters. Moltis migrates it into its credential store on first start.
- No model provider or provider API key is bundled. Configure a provider in Settings after signing in.

## Data And Backup

Under `DATA_PATH`, `config` stores `moltis.toml`, authentication, and certificate configuration; `data` stores databases, sessions, memory, and runtime state. Back up the complete directory before upgrades or migration. Uninstall removes containers but preserves the bind-mounted data.

## Restricted Security Mode

This package uses highest-precedence environment overrides to fix command execution to the built-in WASM/WASI sandbox, disable browser automation and the host terminal, and deny MCP mutation and remote-node selection. It does not mount a Docker or Podman socket. The container uses a read-only root filesystem, UID/GID `1000:1001`, no Linux capabilities, and `no-new-privileges`.

Do not enable the browser, host terminal, stdio MCP, SSH/node execution, or another sandbox backend. Initialization and upgrade check the canonical TOML controls, while the container environment remains the authoritative hard lock even when an existing file uses alternative valid TOML table syntax.

## Image Vulnerability Notice

On 2026-07-28, Trivy scans of the audited amd64 and arm64 image snapshots each reported `9 Critical / 124 High / 0 secrets`. The accepted exceptions are bound to those exact images and the restricted topology documented above. The `latest` package follows a moving tag and must be re-audited after it resolves to a new image. Startup logs must contain `sandbox backend: wasm`; stop and re-audit if logs report `restricted-host` or any fallback.

## References

- Website: <https://moltis.org/>
- Repository: <https://github.com/moltis-org/moltis>
- Documentation: <https://docs.moltis.org/>
- Docker documentation: <https://docs.moltis.org/docker.html>
- Pinned release: <https://github.com/moltis-org/moltis/releases/tag/20260723.03>
- License: <https://github.com/moltis-org/moltis/blob/20260723.03/LICENSE> (MIT)
