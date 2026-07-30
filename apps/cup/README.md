# Cup

## 产品介绍

Cup 是一个轻量级容器镜像更新检查器。它读取本机 Docker 中正在使用的镜像，查询 Docker Hub、GHCR、Quay 等镜像仓库，并在 Web 面板中显示当前版本和可用更新。

## 主要功能

- 自动发现正在运行和已停止容器使用的镜像
- 区分主要、次要、补丁、摘要和其他更新类型
- 支持 Docker Hub、GHCR、Quay、Gitea 等常见 OCI 镜像仓库
- 提供 JSON API、Prometheus 指标和可自动刷新的 Web 面板

## 访问说明

- 默认地址：`http://127.0.0.1:8000`
- Cup 没有内置 Web 身份认证。默认仅绑定回环地址；需要远程访问时，请先配置带身份认证和 HTTPS 的反向代理，再按需修改绑定地址。
- 默认每 30 分钟刷新一次镜像状态。刷新计划使用包含秒字段的六段 Cron 表达式。

## Docker Socket 安全边界

自动发现镜像需要访问宿主机 `/var/run/docker.sock`。能够访问 Docker Socket 的进程通常可以控制宿主机容器，并可能获得等同于宿主机 root 的权限。只读文件挂载不能限制 Docker API 方法，因此本包仍将该挂载视为高权限边界。

本包使用上游官方 scratch 镜像，将 Socket 固定为只读挂载，根文件系统设为只读，删除全部 Linux capabilities，并启用 `no-new-privileges`。固定版本源码只调用列出容器、列出 Swarm 服务、列出镜像和读取镜像详情的 Docker API，不包含创建、启动、停止、删除或执行容器的调用。即使如此，也应只安装可信镜像，不要向不受信任的用户开放 1Panel 应用配置、容器管理或 Cup 面板。

## 数据与卸载

Cup 默认不写入持久数据。镜像检查结果保存在内存中，并在重启后重新发现和查询。卸载只删除 Cup 容器及其 Compose 资源，不会停止、删除或修改其他容器和镜像。

`latest` 跟随上游移动标签；需要可重复部署时请选择商店中的固定版本。

## Introduction

Cup is a lightweight container image update checker. It discovers images used by the local Docker daemon, queries registries such as Docker Hub, GHCR, Quay, and Gitea, and presents current versions and available updates in a web dashboard.

## Features

- Discover images used by running and stopped containers
- Classify major, minor, patch, digest, and other update types
- Query common OCI registries
- Expose a web dashboard, JSON API, and Prometheus metrics with scheduled refreshes

The dashboard listens on `http://127.0.0.1:8000` by default and has no built-in authentication. Configure an authenticated HTTPS reverse proxy before changing the bind address for remote access. The refresh schedule uses a six-field Cron expression that includes seconds.

Automatic discovery requires `/var/run/docker.sock`. Any process with Docker Socket access should be treated as host-privileged because a read-only bind mount does not restrict Docker API methods. This package uses the official scratch image, a read-only root filesystem, drops every Linux capability, and enables `no-new-privileges`. Source review of the fixed release found only list and inspect Docker API calls; no create, start, stop, delete, or exec calls are present. Install only trusted images and restrict access to 1Panel and the Cup dashboard.

Cup keeps results in memory and writes no persistent application data by default. Uninstall removes only the Cup container and its Compose resources; it does not stop, remove, or modify any other container or image.

Use the fixed store version for reproducible deployments; `latest` follows the upstream moving tag.

## References

- Website: <https://cup.sergi0g.dev>
- Documentation: <https://cup.sergi0g.dev/docs>
- Source: <https://github.com/sergi0g/cup>
- Stable release: <https://github.com/sergi0g/cup/releases/tag/v3.5.1>
- Official image: <https://github.com/sergi0g/cup/pkgs/container/cup>
- License: <https://github.com/sergi0g/cup/blob/v3.5.1/LICENSE> (AGPL-3.0)
