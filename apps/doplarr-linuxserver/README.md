# Doplarr
## 产品介绍

Doplarr 使用 LinuxServer.io 维护的 `linuxserver/doplarr` 镜像，提供 Discord 中的 Sonarr、Radarr 或 Overseerr 媒体请求机器人能力。

## 主要功能

- 在 Discord 中接收和处理媒体请求
- 连接 Overseerr，或直接连接 Radarr 与 Sonarr
- 使用安装表单配置令牌、API 地址和请求行为
- 持久化保存配置数据

## 访问说明

该应用没有 Web 界面。安装前需要准备 Discord Bot Token，并根据使用方式填写 Overseerr API，或填写 Radarr/Sonarr API。默认占位值仅用于完成安装流程，请在生产使用前替换为真实凭据。

## Introduction

Doplarr uses the LinuxServer.io maintained `linuxserver/doplarr` image for a Discord media request bot backed by Sonarr, Radarr, or Overseerr.

## Features

- Receive and process media requests in Discord
- Connect to Overseerr, or directly to Radarr and Sonarr
- Configure tokens, API endpoints, and request behavior from the install form
- Persist configuration data

## Access

This app does not provide a Web UI. Prepare a Discord Bot Token before installation, then configure either Overseerr API access or Radarr/Sonarr API access. The default placeholder values are only for installation flow validation and should be replaced before production use.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-doplarr/>
- Project website: <https://github.com/kiranshila/Doplarr>
