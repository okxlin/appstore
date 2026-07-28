# OpenCode

## 产品介绍

OpenCode 是一个自托管 AI 编程助手，可通过浏览器管理 AI 编程会话。

## 主要功能

- 通过浏览器运行 OpenCode 的无头服务。
- 为服务配置独立的 HTTP Basic Auth 凭据。
- 在持久化数据目录中保存 OpenCode 状态。

## 访问说明

- 默认 Web 端口：`4096`
- 容器内部端口：`4096`
- 安装时必须设置服务器用户名和随机生成的密码。OpenCode 使用 HTTP Basic Auth 保护服务。
- 直接端口访问使用 HTTP；公开访问前请在 1Panel 中配置 HTTPS 反向代理。

## 数据与备份

- `Data Directory` 映射到容器的 `/home/opencode`，其中包含 OpenCode 配置、会话和已配置的模型提供商凭据。
- 升级或迁移前备份整个 `Data Directory`。
- 卸载会停止并移除容器，但不会删除数据目录。

## 安全边界

- 此包不挂载 Docker socket、宿主机工作区或其他宿主机敏感路径。
- 在 OpenCode 中配置的模型提供商凭据保存在持久化数据目录中；请将备份视为敏感数据。

## 版本

- `1.18.7` 固定到上游 OpenCode `v1.18.7` 镜像。
- `latest` 跟随上游 OpenCode 的最新镜像。

## 参考资料

- 上游仓库：<https://github.com/anomalyco/opencode>
- 官方文档：<https://opencode.ai/docs>
- 服务命令与认证实现：<https://github.com/anomalyco/opencode/blob/v1.18.7/packages/opencode/src/cli/cmd/serve.ts>

## Introduction

OpenCode is a self-hosted AI coding agent that manages AI-assisted coding sessions in the browser.

## Features

- Run OpenCode's headless service in the browser.
- Configure dedicated HTTP Basic Auth credentials for the service.
- Persist OpenCode state in a dedicated data directory.

## Access

- Default web port: `4096`
- Container port: `4096`
- Installation requires a server username and generated password. OpenCode protects the service with HTTP Basic Auth.
- Direct port access uses HTTP. Configure an HTTPS reverse proxy in 1Panel before public exposure.

## Data and Backup

- `Data Directory` maps to `/home/opencode` in the container and stores OpenCode configuration, sessions, and configured model-provider credentials.
- Back up the complete `Data Directory` before upgrades or migrations.
- Uninstall stops and removes the container but keeps the data directory.

## Security Boundary

- This package does not mount the Docker socket, a host workspace, or other sensitive host paths.
- Model-provider credentials configured in OpenCode live in the persistent data directory. Treat its backups as sensitive.

## Versions

- `1.18.7` is pinned to the upstream OpenCode `v1.18.7` image.
- `latest` follows the upstream OpenCode latest image.

## Sources

- Upstream repository: <https://github.com/anomalyco/opencode>
- Official documentation: <https://opencode.ai/docs>
- Serve command and authentication: <https://github.com/anomalyco/opencode/blob/v1.18.7/packages/opencode/src/cli/cmd/serve.ts>
