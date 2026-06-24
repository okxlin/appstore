# Medusa
## 产品介绍

Medusa 是一个剧集库和下载自动化工具，可管理剧集、字幕和下载任务。本应用使用 LinuxServer.io 维护的 `linuxserver/medusa` 镜像。

## 主要功能

- 通过 Web UI 管理剧集库和下载任务
- 持久化保存配置、剧集目录和下载目录
- 容器使用 8081 端口，默认宿主端口为 8082
- 支持自定义时区

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Web 界面。首次启动后请按应用页面提示完成媒体服务、索引器或资料库配置。

## Introduction

Medusa is a TV library and download automation tool for managing shows, subtitles, and downloads. This app uses the LinuxServer.io maintained `linuxserver/medusa` image.

## Features

- Manage TV libraries and download tasks from the Web UI
- Persist configuration, TV folders, and downloads
- Use container port 8081 with host default 8082
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-medusa/>
- Project website: <https://pymedusa.com/>
