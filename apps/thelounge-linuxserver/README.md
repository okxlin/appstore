# The Lounge
## 产品介绍

The Lounge 是一个可自托管的 Web IRC 客户端，可以在浏览器中连接和管理 IRC 网络。本应用使用 LinuxServer.io 维护的 `linuxserver/thelounge` 镜像。

## 主要功能

- 通过浏览器访问 IRC 客户端界面
- 持久化保存 The Lounge 配置和用户数据
- 支持自定义时区，容器数据由应用目录保存
- 可按官方说明进入容器创建 The Lounge 用户

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 The Lounge。首次使用前请按官方文档创建用户，例如进入容器执行 `s6-setuidgid abc thelounge add <user>`。

## Introduction

The Lounge is a self-hosted web IRC client. It lets you connect to and manage IRC networks from a browser. This app uses the LinuxServer.io maintained `linuxserver/thelounge` image.

## Features

- Access a web IRC client from the browser
- Persist The Lounge configuration and user data
- Configure the container time zone from the app form
- Create The Lounge users inside the container following the official docs

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-thelounge/>
- The Lounge project: <https://thelounge.chat/>
