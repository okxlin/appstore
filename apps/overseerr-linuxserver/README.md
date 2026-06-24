# Overseerr LinuxServer

## 产品介绍

Overseerr 是一个面向 Plex 的媒体请求和发现平台，可与 Sonarr、Radarr 集成。本应用使用 LinuxServer.io 维护的 `linuxserver/overseerr` 镜像。

## 主要功能

- 通过 Web UI 发现和请求媒体内容
- 持久化保存配置和请求数据
- 使用 5055 端口提供 Web 管理界面
- 支持自定义时区

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Web 界面。首次启动后请按应用页面提示完成媒体服务、索引器或资料库配置。

## Introduction

Overseerr is a media request and discovery platform for Plex that integrates with Sonarr and Radarr. This app uses the LinuxServer.io maintained `linuxserver/overseerr` image.

## Features

- Discover and request media from the Web UI
- Persist configuration and request data
- Expose the Web interface on port 5055
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-overseerr/>
- Project website: <https://overseerr.dev/>
