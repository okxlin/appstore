# SABnzbd
## 产品介绍

SABnzbd 是一个基于 Web 的 Usenet 下载器，可管理队列、分类、速度限制和下载目录。本应用使用 LinuxServer.io 维护的 `linuxserver/sabnzbd` 镜像。

## 主要功能

- 通过 Web UI 管理 Usenet 下载任务和队列
- 持久化保存配置、完成下载和未完成下载目录
- 使用 8080 端口提供 Web 管理界面
- 支持自定义时区

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Web 界面。首次启动后请按应用页面提示完成初始化、账号或后端服务配置。

## Introduction

SABnzbd is a web-based Usenet downloader for managing queues, categories, speed limits, and download folders. This app uses the LinuxServer.io maintained `linuxserver/sabnzbd` image.

## Features

- Manage Usenet download jobs and queues from the Web UI
- Persist configuration, completed downloads, and incomplete downloads
- Expose the Web interface on port 8080
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-sabnzbd/>
- Project website: <https://sabnzbd.org/>
