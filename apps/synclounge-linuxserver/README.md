# SyncLounge
## 产品介绍

SyncLounge 是一个 Plex 同步观看服务，可让多个用户在浏览器中同步播放进度。本应用使用 LinuxServer.io 维护的 `linuxserver/synclounge` 镜像。

## 主要功能

- 通过 Web UI 创建和加入同步观看房间
- 使用 8088 端口提供 Web 应用和服务端
- 可选限制允许访问的 Plex 用户
- 无需额外数据库服务

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Web 界面。首次启动后请按应用页面提示完成初始化、账号或媒体目录配置。

## Introduction

SyncLounge is a Plex watch party service that keeps playback synchronized between users in the browser. This app uses the LinuxServer.io maintained `linuxserver/synclounge` image.

## Features

- Create and join synchronized watch rooms from the Web UI
- Expose the web app and server on port 8088
- Optionally restrict allowed Plex users
- Run without an external database service

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-synclounge/>
- Project website: <https://synclounge.tv/>
