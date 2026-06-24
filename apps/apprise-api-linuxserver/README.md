# Apprise API
## 产品介绍

Apprise API 为 Apprise 通知库提供 Web UI 和 HTTP API，可统一发送多种通知服务。本应用使用 LinuxServer.io 维护的 `linuxserver/apprise-api` 镜像。

## 主要功能

- 通过 Web UI 和 HTTP API 管理通知发送
- 持久化保存配置和可选附件目录
- 使用 8000 端口提供 Web/API 入口
- 支持配置附件大小限制和时区

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Web 界面。首次启动后请按应用页面提示完成初始化、账号或后端服务配置。

## Introduction

Apprise API provides a Web UI and HTTP API for the Apprise notification library, making many notification services available from one endpoint. This app uses the LinuxServer.io maintained `linuxserver/apprise-api` image.

## Features

- Manage notification delivery through a Web UI and HTTP API
- Persist configuration and optional attachments
- Expose the Web/API endpoint on port 8000
- Configure attachment size limits and time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-apprise-api/>
- Project website: <https://github.com/caronc/apprise-api>
