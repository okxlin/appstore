# hiSHtory Server
## 产品介绍

hiSHtory Server 使用 LinuxServer.io 维护的 `linuxserver/hishtory-server` 镜像，提供 hiSHtory Shell 历史同步服务 能力。

## 主要功能

- 提供 hiSHtory Shell 历史同步 API
- 持久化保存配置和业务数据
- 使用 8080 端口提供客户端同步服务
- 支持自定义时区

## 访问说明

安装完成后，在 hiSHtory 客户端中配置服务地址，例如 `HISHTORY_SERVER=http://服务器地址:HTTP端口`。该服务主要面向客户端 API，不提供传统管理页面。

## Introduction

hiSHtory Server uses the LinuxServer.io maintained `linuxserver/hishtory-server` image for shell history synchronization.

## Features

- Provide the hiSHtory shell history sync API
- Persist configuration and application data
- Expose port 8080 for client synchronization
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-hishtory-server/>
- Project website: <https://github.com/ddworken/hishtory>
