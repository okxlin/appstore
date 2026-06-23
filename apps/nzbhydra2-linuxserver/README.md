# NZBHydra2 LinuxServer

## 产品介绍

NZBHydra2 是一个 NZB 索引器聚合搜索工具，可统一管理 indexer 并为下载器提供搜索入口。本应用使用 LinuxServer.io 维护的 `linuxserver/nzbhydra2` 镜像。

## 主要功能

- 通过 Web UI 管理 NZB indexer 和搜索配置
- 持久化保存配置和可选下载目录
- 使用 5076 端口提供 Web 管理界面
- 支持自定义时区

## 访问说明

安装完成后，通过 1Panel 应用入口或 `http://服务器地址:HTTP端口` 访问 Web 界面。首次启动后请按应用页面提示完成初始化、账号或后端服务配置。

## Introduction

NZBHydra2 is an NZB indexer meta-search tool for managing indexers and exposing a unified search entrypoint to download clients. This app uses the LinuxServer.io maintained `linuxserver/nzbhydra2` image.

## Features

- Manage NZB indexers and search settings from the Web UI
- Persist configuration and optional downloads
- Expose the Web interface on port 5076
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-nzbhydra2/>
- Project website: <https://github.com/theotherp/nzbhydra2>
