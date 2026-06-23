# Jackett LinuxServer

## 产品介绍

Jackett 是面向 Sonarr、Radarr 等媒体管理工具的索引器代理。它将应用发出的搜索请求转换为各 Tracker 站点的查询请求，并把结果整理后返回给调用方。本应用使用 LinuxServer.io 维护的 `linuxserver/jackett` 镜像。

## 主要功能

- 通过 Web UI 管理索引器、API Key 和连接配置
- 对外暴露 9117 Web 服务端口，可被 Sonarr、Radarr 等工具调用
- 持久化保存 Jackett 配置和 blackhole 下载目录
- 支持配置时区、自动更新开关和额外运行参数

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Jackett Web UI。首次配置索引器后，可在页面中复制 API Key 并填入需要调用 Jackett 的媒体管理应用。

## Introduction

Jackett works as a tracker indexer proxy for media management apps such as Sonarr and Radarr. It translates application search requests into tracker-specific queries, parses responses, and returns normalized results. This app uses the LinuxServer.io maintained `linuxserver/jackett` image.

## Features

- Manage indexers, API keys, and connection settings from the Web UI
- Expose the 9117 Web service port for media management applications
- Persist Jackett configuration and blackhole downloads separately
- Configure the time zone, auto update flag, and optional runtime arguments

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-jackett/>
- Jackett project: <https://github.com/Jackett/Jackett>
