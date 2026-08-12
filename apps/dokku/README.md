# Dokku

## 产品介绍

Dokku 是面向单机服务器的开源 PaaS，可通过 Git 推送、Dockerfile、Buildpack 和插件构建、部署与管理应用，并由内置 Nginx/OpenResty 提供路由。

## 主要功能

- 通过 Git SSH 推送代码并自动构建、发布应用。
- 使用 Dockerfile、Herokuish、Nixpacks、Railpack 等构建器。
- 管理应用配置、域名、进程、存储、证书和定时任务。
- 通过插件扩展 PostgreSQL、Redis 等服务。

## 访问说明

- Dokku 没有管理 WebUI，主要通过 SSH、Git 和 `dokku` 命令管理。
- HTTP/HTTPS 端口用于访问 Dokku 部署的应用，SSH 端口用于 Git 推送和管理。
- `DOKKU_HOSTNAME` 应设置为解析到服务器的域名；测试值 `dokku.me` 仅适合临时体验。
- 添加 SSH 公钥需要进入容器执行 `dokku ssh-keys:add`，具体命令见上游用户管理文档。

## 数据持久化

- Dokku 按官方容器部署契约固定使用宿主机 `/var/lib/dokku`，并将其挂载到容器内 `/mnt/dokku`。
- 该目录保存 Git 仓库、插件、配置、服务数据和 SSH 状态。为避免不同 Dokku 实例共享并覆盖同一状态，本应用限制为单实例，且不提供自定义数据目录表单。
- 升级前应备份整个 `/var/lib/dokku`，并同时备份 Dokku 创建的应用容器、卷和数据库插件数据。

### 旧版自定义路径迁移

早期包允许通过 `APP_DATA_DIR` 指定其他宿主机路径。新版本不会自动移动这类持久化数据，也不会在路径不一致时静默启动一个空的 `/var/lib/dokku`。

升级前请停止 Dokku，完整备份旧目录，将其中的全部内容迁移到 `/var/lib/dokku`，并确认属主、权限以及插件和 SSH 状态无误。然后在当前旧版本的 1Panel 应用参数中，将“数据目录”改为 `/var/lib/dokku`，确认当前实例可正常启动后再选择升级。不要只手工修改安装目录的 `.env`，因为 1Panel 在升级时会从已保存的应用参数重写该文件。若检测到其他非空路径，`upgrade.sh` 会明确中止。

## 高风险权限说明

Dokku 的核心功能必须挂载宿主机 `/var/run/docker.sock`。这相当于授予容器宿主机 root 级控制能力：Dokku 及其插件可以创建、删除、检查或挂载任意 Docker 容器、镜像、网络和卷，也可能影响 1Panel 管理的其他应用。

仅在专用或充分受信任的服务器上安装。不要向不受信任用户开放 Dokku SSH 权限，不要安装来源不明的插件。卸载 Dokku 应用不会自动删除它创建的子容器、镜像、网络和卷，需要管理员按上游流程审计后手工清理。

## 镜像安全提示

当前镜像的 Docker 相关工具包含 Trivy 标记为 High 的 Moby/Docker 与 Go 标准库问题，其中包括授权插件绕过、针对恶意容器镜像执行 `docker cp`/压缩归档上传时的宿主机代码执行或文件覆盖风险，以及符号链接目录遍历风险。由于 Dokku 必须直接访问宿主机 Docker Socket，这些问题不能按普通低权限容器处理。

仅部署受信任镜像和应用源码；不要对不受信任容器执行 `docker cp` 或压缩归档上传；不要向不受信任用户授予 Dokku SSH、插件安装或 Docker 操作权限。后续 Dokku 镜像包含已修复的 Docker/Go 工具链后应尽快升级。

## 端口与网络风险

- Dokku 部署的应用可能创建额外端口和 Docker 网络，这些资源不会自动出现在当前应用包的 Compose 文件中。
- 内置路由会占用应用 HTTP/HTTPS 端口。使用 1Panel 网站反向代理时，应规划好域名、端口和 TLS 终止位置，避免与现有服务冲突。
- 官方容器使用 Docker 默认 bridge 网络，本适配保留该行为以保证 Dokku 的应用路由和容器管理逻辑。

## Introduction

Dokku is a Docker-powered single-server PaaS for building, deploying, and managing applications through Git pushes, buildpacks, and plugins.

## Features

- Deploy applications through Git SSH pushes.
- Build with Dockerfiles and multiple buildpack-style builders.
- Manage domains, processes, storage, certificates, and scheduled jobs.
- Extend the platform with database and service plugins.

## Links

- Website: https://dokku.com
- Project: https://github.com/dokku/dokku
- Docker installation: https://dokku.com/docs/getting-started/install/docker/
- Image: https://hub.docker.com/r/dokku/dokku
