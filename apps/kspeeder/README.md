# KSpeeder

## 产品介绍
KSpeeder 是面向 Docker、GitHub 与多种网络源的加速服务，支持节点聚合、测速和镜像代理。

## 主要功能
- 通过 5003 管理端口提供 Web 控制台
- 通过 5443 提供镜像加速 TLS 入口
- 自动生成并管理 `nodes.yaml` 节点配置
- 支持可选 CONNECT 代理认证

## 访问说明
安装完成后访问：

```text
http://服务器IP:管理端口
```

管理界面默认使用 `PANEL_APP_PORT_HTTP`，镜像加速入口使用 `PANEL_APP_PORT_TLS`。首次启动后若配置目录为空，容器会自动生成 `nodes.yaml` 示例。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/kspeeder-data`
- `APP_CONFIG_DIR`：持久化 `/kspeeder-config`

## Introduction
KSpeeder is an acceleration service for Docker, GitHub, and other network sources with node aggregation, testing, and image proxying.

## Features
- Web console on the admin port
- TLS mirror endpoint for accelerated image pulls
- Auto-generated `nodes.yaml` configuration
- Optional CONNECT proxy authentication

## 参考资料
- 源码: <https://github.com/kspeeder/docker_kspeeder>
- 文档: <https://github.com/kspeeder/docker_kspeeder/blob/main/README.md>
- Docker Hub: <https://hub.docker.com/r/linkease/kspeeder>
