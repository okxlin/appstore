# iSrvd

## 产品介绍

iSrvd 是基于 Go 和 Vue 3 的一体化服务器管理工具，提供文件管理、Web 终端、Docker、Swarm、Compose、计划任务、SSH 远程管理和系统监控等功能。

本应用使用上游 `slim` 单服务镜像。上游 `caddy` 和 `apisix` 多进程一体化镜像未包含在本适配中。

## 主要功能

- 文件管理、Web 终端和系统状态监控
- Docker 容器、镜像、网络、存储卷和 Compose 项目管理
- Docker Swarm、计划任务和 SSH 远程主机管理
- Passkey、OIDC 和可信请求头认证配置

## 安装说明

- 安装时必须设置管理员用户名和高强度密码。
- 数据目录默认是应用安装目录下的 `./data`，也可以填写自定义相对路径或绝对路径。
- 如需从其他设备访问，请开启端口外部访问或在 1Panel 中配置 HTTPS 反向代理。
- 默认不会初始化 Docker Swarm；需要 Swarm 功能时，请由管理员在宿主机上单独初始化。

## 访问说明

安装完成后，通过 `http://服务器地址:安装端口` 访问，并使用安装表单中设置的管理员账号和密码登录。首次启动时，iSrvd 会自动将管理员密码转换为 bcrypt 哈希并生成 JWT 签名密钥。

首次安装或从旧适配升级时，启动脚本会先让管理端仅监听容器内的 `127.0.0.1`，使用一次性本地引导把表单密码写入 iSrvd 的 bcrypt 配置，然后删除临时密码文件并切换到正常监听。临时默认凭据不会暴露到应用端口，也不会写入容器日志。

管理员密码至少 8 位，可以使用普通可打印字符，但不能包含制表符或换行符。

该页面具备管理宿主机 Docker 的高权限能力。请勿直接暴露到互联网或不可信网络，建议通过 1Panel 网站反向代理启用 HTTPS，并额外配置网络访问控制。

## 高风险权限

> **高风险：本应用会挂载 `/var/run/docker.sock`。**

iSrvd 的 Docker、Swarm、Compose、容器终端和计划任务功能依赖 Docker Socket，因此该权限属于核心功能要求，不能移除。获得 Docker Socket 访问权的容器实际上可以取得宿主机 root 级控制能力。

- 仅在可信服务器上安装，并限制 iSrvd 管理员账号的使用范围。
- 不要将管理端口直接暴露到不可信网络；优先使用 HTTPS、访问控制和二次验证。
- 不要导入或运行不可信的镜像、Compose 文件、归档文件和 Shell 命令。
- 定期更新 iSrvd、Docker Engine 和宿主机系统。

## 数据持久化

安装脚本会将 `APP_DATA_DIR` 解析为绝对路径，并同时挂载到容器内 `/data` 和相同的绝对路径。第二个挂载用于保证 iSrvd 创建 Compose 项目时，容器内项目路径与 Docker 守护进程看到的宿主路径一致。

备份时应完整备份数据目录，其中包括：

- `conf/isrvd.yml`：账户、认证和应用配置
- `container/`：由 iSrvd 管理的 Compose 项目文件
- 用户文件、审计记录和其他运行数据

应用首次启动会将管理员明文密码转换为 bcrypt 哈希，并自动生成 JWT 签名密钥。升级脚本不会覆盖已经存在的配置文件。

## Introduction

iSrvd is an all-in-one server management tool built with Go and Vue 3. It provides file management, a web terminal, Docker, Swarm, Compose, scheduled jobs, SSH management, and system monitoring.

This package uses the upstream single-service `slim` image. The multi-process `caddy` and `apisix` images are not included.

## Features

- File management, web terminal, and system monitoring
- Docker container, image, network, volume, and Compose management
- Docker Swarm, scheduled jobs, and remote SSH host management
- Passkey, OIDC, and trusted-header authentication options

## Access

Open `http://server-address:installed-port` and sign in with the administrator credentials supplied during installation. On first startup, iSrvd converts the administrator password to a bcrypt hash and generates a JWT signing secret.

During a fresh install or an upgrade from the older package, the bootstrap script temporarily binds the management service to container-local `127.0.0.1`, applies the form password through the local API, removes the one-time password file, and then restores normal listening. The temporary default credential is not exposed through the published application port or written to container logs.

The administrator password must contain at least 8 printable characters and must not contain tabs or line breaks.

The web interface can control the host Docker daemon. Do not expose it directly to the public Internet or an untrusted network. Prefer an HTTPS reverse proxy in 1Panel together with network access controls.

Mounting `/var/run/docker.sock` gives the container effective root-level control over the host. Install this app only on a trusted server and do not run untrusted images, Compose files, archives, or shell commands through iSrvd.

## References

- Source: <https://github.com/rehiy/isrvd>
- Documentation: <https://github.com/rehiy/isrvd/blob/master/README.md>
- Docker image: <https://hub.docker.com/r/rehiy/isrvd>
- Docker workflow: <https://github.com/rehiy/isrvd/blob/master/.github/workflows/docker.yml>
