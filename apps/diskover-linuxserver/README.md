# Diskover LinuxServer

## 产品介绍

Diskover LinuxServer 使用 LinuxServer.io 维护的 `linuxserver/diskover` 镜像，提供 Diskover 文件系统索引与搜索 能力。

## 主要功能

- 提供 文件系统索引与 Web 检索 能力
- 持久化保存配置和业务数据
- 使用安装表单配置服务端口和数据路径
- 支持自定义时区

## 访问说明

安装完成后，通过 HTTP 端口访问 Diskover Web UI。默认账号为 diskover，密码为 darkdata。

## 运行说明

该应用随包启动 Elasticsearch 7.17.22。根据 LinuxServer 官方 compose 示例，安装时会运行一个短生命周期的 privileged helper，用于设置 `vm.max_map_count=262144`，满足 Elasticsearch 启动要求。

## Introduction

Diskover LinuxServer uses the LinuxServer.io maintained `linuxserver/diskover` image for filesystem indexing and web search.

## Features

- Provide filesystem indexing and web search
- Persist configuration and application data
- Configure service ports and data paths from the install form
- Configure the container time zone

## Access

After installation, open Diskover from the HTTP port. The default username is diskover and the password is darkdata.

## Runtime Notes

This package starts Elasticsearch 7.17.22 alongside Diskover. Following the LinuxServer official compose example, installation runs a short-lived privileged helper to set `vm.max_map_count=262144`, which Elasticsearch requires at startup.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-diskover/>
- Project website: <https://github.com/diskoverdata/diskover-community>
