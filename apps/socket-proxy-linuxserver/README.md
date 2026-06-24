# Socket Proxy LinuxServer

## 产品介绍

Socket Proxy LinuxServer 使用 LinuxServer.io 维护的 `linuxserver/socket-proxy` 镜像，提供带访问规则的 Docker API 代理。

## 主要功能

- 通过 TCP 代理 Docker socket API
- 默认仅启用 `_ping`、`version` 和 `events`
- 默认禁止 POST 请求，并关闭容器、镜像、网络和卷等 API 分组
- 以只读 Docker socket、只读容器文件系统和 `/run` tmpfs 运行

## 访问说明

本适配不向宿主机暴露端口。需要使用该代理的应用应连接到同一个 `1panel-network`，并将 Docker endpoint 指向 `tcp://socket-proxy:2375`。请勿把该服务暴露到公网；它应按 Docker socket 同等级别保护。

## 运行说明

该应用需要挂载宿主机 Docker socket，默认使用只读挂载 `/var/run/docker.sock:/var/run/docker.sock:ro`。只有在明确理解风险后，才开启更多 API 分组或允许 POST 请求。

## Introduction

Socket Proxy LinuxServer uses the LinuxServer.io maintained `linuxserver/socket-proxy` image to provide a rule-based Docker API proxy.

## Features

- Proxy Docker socket API over TCP
- Enable only `_ping`, `version`, and `events` by default
- Disable POST requests and container, image, network, and volume API groups by default
- Run with a read-only Docker socket, read-only container filesystem, and `/run` tmpfs

## Access

This package does not expose a host port. Applications that use the proxy should join the same `1panel-network` and point their Docker endpoint to `tcp://socket-proxy:2375`. Do not expose this service to the public Internet; protect it like the Docker socket itself.

## Runtime Notes

This app mounts the host Docker socket and defaults to the read-only mount `/var/run/docker.sock:/var/run/docker.sock:ro`. Enable more API groups or POST requests only after understanding the risk.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-socket-proxy/>
- Project website: <https://www.linuxserver.io/>
