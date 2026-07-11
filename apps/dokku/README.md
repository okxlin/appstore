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

- `APP_DATA_DIR` 必须是宿主机绝对路径，默认 `/var/lib/dokku`。
- 该目录挂载到 `/mnt/dokku`，保存 Git 仓库、插件、配置、服务数据和 SSH 状态。
- 升级前应备份整个目录，并同时备份 Dokku 创建的应用容器、卷和数据库插件数据。

## 高风险权限说明

Dokku 的核心功能必须挂载宿主机 `/var/run/docker.sock`。这相当于授予容器宿主机 root 级控制能力：Dokku 及其插件可以创建、删除、检查或挂载任意 Docker 容器、镜像、网络和卷，也可能影响 1Panel 管理的其他应用。

仅在专用或充分受信任的服务器上安装。不要向不受信任用户开放 Dokku SSH 权限，不要安装来源不明的插件。卸载 Dokku 应用不会自动删除它创建的子容器、镜像、网络和卷，需要管理员按上游流程审计后手工清理。

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
