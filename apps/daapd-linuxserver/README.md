# DAAPD
## 产品介绍

DAAPD 使用 LinuxServer.io 维护的 `linuxserver/daapd` 镜像，提供 DAAPD/OwnTone 媒体服务器 能力。

## 主要功能

- 提供 音乐库共享与 Web 管理 能力
- 持久化保存配置和业务数据
- 使用安装表单配置服务端口和数据路径
- 支持自定义时区

## 访问说明

安装完成后，通过 HTTP 端口访问 Web UI。默认账号为 admin，密码为 changeme。

## 运行说明

LinuxServer 已将该镜像标记为 deprecated，并建议迁移到 OwnTone 官方容器。本适配保留 `28.10.20250118` numbered tag。该包使用 bridge 网络暴露 Web UI；局域网发现、AirPlay 等场景可能需要按官方文档改用 host network。

## Introduction

DAAPD uses the LinuxServer.io maintained `linuxserver/daapd` image for music library sharing and web management.

## Features

- Provide music library sharing and web management
- Persist configuration and application data
- Configure service ports and data paths from the install form
- Configure the container time zone

## Access

After installation, open the web UI from the HTTP port. The default username is admin and the password is changeme.

## Runtime Notes

LinuxServer marks this image as deprecated and recommends migrating to the official OwnTone container. This package keeps the `28.10.20250118` numbered tag. It uses bridge networking for the web UI; LAN discovery, AirPlay and similar use cases may require switching to host networking as described in the upstream documentation.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-daapd/>
- Project website: <https://owntone.github.io/owntone-server/>
