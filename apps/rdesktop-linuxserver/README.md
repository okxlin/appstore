# RDesktop
## 产品介绍

RDesktop 使用 LinuxServer.io 维护的 `linuxserver/rdesktop` Ubuntu XFCE 镜像，提供可通过 RDP 访问的远程桌面环境。

## 主要功能

- 提供 RDP 远程桌面访问
- 持久化保存用户配置和桌面数据
- 使用安装表单配置 RDP 端口和数据路径
- 支持自定义时区

## 访问说明

安装完成后，通过 RDP 客户端连接配置的 RDP 端口。本适配不启用 Docker socket、GPU 设备或 privileged 模式；仅保留 LinuxServer 官方 Ubuntu XFCE 文档中用于桌面应用兼容的 `seccomp:unconfined`。

## 运行说明

LinuxServer 已将旧的默认 rdesktop image 路径标记为 deprecated，并建议迁移到 Ubuntu-based tag。本适配使用 `ubuntu-xfce` 变体。

## Introduction

RDesktop uses the LinuxServer.io maintained `linuxserver/rdesktop` Ubuntu XFCE image for an RDP-accessible desktop environment.

## Features

- Provide RDP remote desktop access
- Persist user configuration and desktop data
- Configure the RDP port and data path from the install form
- Configure the container time zone

## Access

After installation, connect with an RDP client to the configured RDP port. This adapter does not enable Docker socket, GPU devices, or privileged mode; it only keeps `seccomp:unconfined` from LinuxServer's Ubuntu XFCE documentation for desktop application compatibility.

## Runtime Notes

LinuxServer marks the old default rdesktop image path as deprecated and recommends Ubuntu-based tags. This package uses the `ubuntu-xfce` variant.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-rdesktop/>
- Project website: <https://www.linuxserver.io/>
