# Snipe-IT LinuxServer

## 产品介绍

Snipe-IT LinuxServer 使用 LinuxServer.io 维护的 `linuxserver/snipe-it` 镜像，提供 Snipe-IT 资产管理系统 能力。

## 主要功能

- 提供 资产、许可证与耗材管理 能力
- 持久化保存配置和业务数据
- 使用安装表单配置服务端口和数据路径
- 支持自定义时区

## 访问说明

安装完成后，通过 HTTP 端口访问 Snipe-IT Web UI。生产环境请替换应用密钥和访问 URL。

## 运行说明

LinuxServer 已将该镜像标记为 deprecated，并建议迁移到 Grokability 官方 Docker 镜像。本适配保留 `8.0.4` numbered tag，用于兼容 LinuxServer 镜像部署。

## Introduction

Snipe-IT LinuxServer uses the LinuxServer.io maintained `linuxserver/snipe-it` image for asset, license and consumable management.

## Features

- Provide asset, license and consumable management
- Persist configuration and application data
- Configure service ports and data paths from the install form
- Configure the container time zone

## Access

After installation, open Snipe-IT from the HTTP port. Replace the app key and access URL before production use.

## Runtime Notes

LinuxServer marks this image as deprecated and recommends migrating to the official Grokability Docker image. This package keeps the `8.0.4` numbered tag for LinuxServer image compatibility.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/deprecated_images/docker-snipe-it/>
- Project website: <https://github.com/grokability/snipe-it>
