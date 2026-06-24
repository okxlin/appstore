# NZBGet
## 产品介绍

NZBGet 是一个以性能为目标的 Usenet 下载器。本应用使用 LinuxServer.io 维护的 `linuxserver/nzbget` 镜像，提供 Web UI、配置持久化和下载目录挂载。

## 主要功能

- 通过 Web UI 管理 Usenet 下载任务
- 自定义 Web 登录用户名和密码
- 持久化保存配置目录和下载目录
- 支持自定义时区，适合与媒体管理应用配合使用

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 NZBGet。Web 登录用户名和密码由安装表单中的 `Web 用户名` 与 `Web 密码` 决定。

## Introduction

NZBGet is a Usenet downloader designed for high performance and low resource usage. This app uses the LinuxServer.io maintained `linuxserver/nzbget` image and provides a Web UI with persistent config and downloads directories.

## Features

- Manage Usenet downloads from the Web UI
- Configure the Web login username and password
- Persist configuration and downloaded files
- Configure the container time zone from the app form

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-nzbget/>
- NZBGet project: <https://nzbget.com/>
