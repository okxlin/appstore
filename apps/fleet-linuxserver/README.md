# Fleet LinuxServer

## 产品介绍

Fleet LinuxServer 使用 LinuxServer.io 维护的 `linuxserver/fleet` 镜像，提供 Fleet 镜像仓库展示界面 能力。

## 主要功能

- 提供 镜像仓库展示与管理 能力
- 持久化保存配置和业务数据
- 使用安装表单配置服务端口和数据路径
- 支持自定义时区

## 访问说明

安装完成后，通过 HTTP 端口访问 Fleet Web UI。使用 DATABASE 模式时，可通过 `/setup` 初始化用户。

## 运行说明

LinuxServer 已将该镜像和 Fleet 应用标记为 deprecated。本适配保留 `2.3.3` numbered tag，用于兼容 LinuxServer 镜像部署。

## Introduction

Fleet LinuxServer uses the LinuxServer.io maintained `linuxserver/fleet` image for image repository display and management.

## Features

- Provide image repository display and management
- Persist configuration and application data
- Configure service ports and data paths from the install form
- Configure the container time zone

## Access

After installation, open Fleet from the HTTP port. In DATABASE mode, initialize the first user from `/setup`.

## Runtime Notes

LinuxServer marks this image and the Fleet application as deprecated. This package keeps the `2.3.3` numbered tag for LinuxServer image compatibility.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-fleet/>
- Project website: <https://github.com/linuxserver/fleet>
