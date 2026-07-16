# Kilo Code

## 产品介绍

Kilo Code 是一个开源 AI 编程代理。本应用部署其官方容器中的无界面服务器模式，供本地 Kilo CLI 通过认证连接，并在指定工作区中管理会话、分析代码和执行开发任务。

## 主要功能

- 运行 Kilo 官方 headless server，并通过 HTTP Basic Auth 保护远程连接。
- 持久化 Kilo 配置、认证信息、会话、数据库和用户指定的代码工作区。
- 支持固定版本与 `latest` 之间的 1Panel 原生升级。
- 不需要 Docker Socket、特权模式、主机网络或额外设备。

## 访问说明

当前官方容器未包含 Kilo Console 的静态资源，因此本应用不提供浏览器 Web UI。请在客户端安装 Kilo CLI，并连接已部署的服务器：

```bash
kilo attach http://<服务器地址>:<服务端口> \
  --username <服务用户名> \
  --password <服务密码> \
  --dir /workspace
```

`--dir /workspace` 指向容器内的持久化工作区。模型提供商和 Kilo 账户配置可通过连接后的 CLI 完成，并保存在 Kilo 数据目录中。

## 配置项

| 变量 | 说明 | 默认值 |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Kilo 服务端口 | `4096` |
| `KILO_SERVER_USERNAME` | HTTP Basic Auth 用户名 | `kilo` |
| `KILO_SERVER_PASSWORD` | HTTP Basic Auth 密码，安装时随机生成 | 随机值 |
| `APP_DATA_DIR` | 配置、认证信息、会话和数据库目录 | `./data` |
| `APP_WORKSPACE_DIR` | 允许 Kilo 读取和修改的代码工作区 | `./workspace` |
| `TZ` | 容器时区 | `Asia/Shanghai` |

## 数据与升级

- 升级前请备份 `APP_DATA_DIR` 和 `APP_WORKSPACE_DIR`。
- 固定版本和 `latest` 使用相同的数据布局，可通过 1Panel 原生升级。
- 默认相对目录 `./data` 和 `./workspace` 位于 1Panel 应用安装目录内，卸载应用时会一并删除；卸载前必须备份。若需独立保留，请在安装时改用应用安装目录之外的专用宿主机绝对路径，并自行管理其权限和备份。

## 安全提示

- 官方镜像中的 Kilo 进程以 root 身份运行。认证用户可以在挂载的工作区内执行命令并修改文件，因此只应挂载明确交给 Kilo 管理的代码目录。
- 请保留随机生成的强密码，不要将服务以无认证方式暴露到公网。
- 远程访问建议通过 1Panel 反向代理启用 HTTPS，并限制可信来源。

## Introduction

Kilo Code is an open-source AI coding agent. This package runs the official image in headless server mode so a local Kilo CLI can connect with authentication and work in the selected persistent workspace.

## Features

- Runs the official Kilo headless server behind HTTP Basic Auth.
- Persists Kilo configuration, authentication state, sessions, database files, and the selected code workspace.
- Supports native 1Panel upgrades between the fixed release and `latest`.
- Requires no Docker Socket, privileged mode, host networking, or device access.

Connect from a local Kilo CLI with `kilo attach`, using `/workspace` as the remote directory. Back up both configured bind directories before upgrades. The default relative `./data` and `./workspace` directories live inside the 1Panel app installation directory and are removed when the app is uninstalled; use dedicated absolute host paths outside that directory if the data must survive uninstall, and manage their permissions and backups yourself. The official image runs as root and authenticated agents can execute commands in the mounted workspace, so mount only intended source code and use TLS plus a strong password for remote access.

## 参考资料

- 项目：<https://github.com/Kilo-Org/kilocode>
- CLI 文档：<https://kilo.ai/docs/code-with-ai/platforms/cli>
- CLI 命令参考：<https://kilo.ai/docs/code-with-ai/platforms/cli-reference>
