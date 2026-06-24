# Ubooquity
## 产品介绍

Ubooquity 使用 LinuxServer.io 维护的 `linuxserver/ubooquity` 镜像，提供 Ubooquity 电子书漫画服务 能力。

## 主要功能

- 通过 Web UI 进行 ebook and comic library hosting 配置
- 持久化保存配置和业务数据
- 使用 2202 端口提供 Web 管理界面
- 支持自定义时区

## 访问说明

安装完成后，通过 `http://服务器地址:HTTP端口/ubooquity/` 访问书库页面，通过 `http://服务器地址:管理端口/ubooquity/admin` 访问管理页面并设置初始密码。

## Introduction

Ubooquity uses the LinuxServer.io maintained `linuxserver/ubooquity` image for ebook and comic library hosting.

## Features

- Manage the application from the Web UI
- Persist configuration and application data
- Expose the Web interface on port 2202
- Configure the container time zone

Access the library at `/ubooquity/` on the HTTP port and the admin page at `/ubooquity/admin` on the admin port.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-ubooquity/>
- Project website: <https://vaemendis.net/ubooquity/>
