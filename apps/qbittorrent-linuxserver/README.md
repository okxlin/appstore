# qBittorrent
## 产品介绍

qBittorrent 是一款开源 BitTorrent 客户端，目标是提供一个轻量、跨平台且无广告的下载工具。本应用使用 LinuxServer.io 维护的 Docker Hub `linuxserver/qbittorrent` 镜像，适合在 1Panel 中部署 Web UI 管理端和 BT 下载监听端口。

## 主要功能

- Web UI 管理下载任务、队列、分类和速度限制
- 支持 TCP 与 UDP 监听端口，适配常见 BT 下载场景
- 配置目录和下载目录可独立挂载，便于备份和迁移
- 支持自定义时区，容器数据由应用目录持久化保存

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 qBittorrent Web UI。

首次访问时请查看容器日志中的临时管理员密码，并在登录后及时修改默认凭据。若需要公网访问，请确认 HTTP 端口、BT TCP 端口和 BT UDP 端口已按实际网络环境放行。

## Introduction

qBittorrent is an open-source BitTorrent client designed as a lightweight, cross-platform, and ad-free download tool. This app uses the LinuxServer.io maintained Docker Hub `linuxserver/qbittorrent` image and exposes both the Web UI and torrent listener ports for 1Panel deployments.

## Features

- Manage downloads, queues, categories, and speed limits from the Web UI
- Expose TCP and UDP listener ports for common BitTorrent workflows
- Persist configuration and downloads in separate mounted directories
- Configure the container time zone from the app form

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-qbittorrent/>
- qBittorrent project: <https://www.qbittorrent.org/>
