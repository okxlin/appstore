# Modmanager
## 产品介绍

Modmanager 使用 LinuxServer.io 维护的 `linuxserver/modmanager` 镜像，提供 LinuxServer Docker Mods 缓存更新服务 能力。

## 主要功能

- 提供 Docker Mods 缓存下载与定期更新 能力
- 持久化保存配置和业务数据
- 使用安装表单配置服务端口和数据路径
- 支持自定义时区

## 访问说明

Modmanager 没有 Web 界面。安装完成后，它会按 `DOCKER_MODS` 下载并维护 `/modcache` 缓存。

## 运行说明

本适配默认不挂载 Docker socket。需要自动发现其他容器时，建议通过受限的 Docker Socket Proxy 填写 `DOCKER_HOST`，而不是直接把 `/var/run/docker.sock` 挂入容器。

## Introduction

Modmanager uses the LinuxServer.io maintained `linuxserver/modmanager` image for Docker Mods cache download and scheduled updates.

## Features

- Provide Docker Mods cache download and scheduled updates
- Persist configuration and application data
- Configure service ports and data paths from the install form
- Configure the container time zone

## Access

Modmanager does not provide a web interface. After installation, it downloads and maintains `/modcache` according to `DOCKER_MODS`.

## Runtime Notes

This package does not mount the Docker socket by default. For Docker discovery, prefer a restricted Docker Socket Proxy endpoint in `DOCKER_HOST` instead of mounting `/var/run/docker.sock` directly.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-modmanager/>
- Project website: <https://www.linuxserver.io/>
