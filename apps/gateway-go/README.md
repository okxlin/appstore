## 产品介绍

gateway-go 是云亿连/OpenIoTHub 的内网端网关，用于让移动端或桌面客户端远程访问局域网内服务。

## 主要功能

- 支持 Android、iOS、macOS、Windows、Linux 客户端
- 支持 ARM、x86 架构镜像
- 支持 P2P 连接，客户端扫码添加网关后配置需要访问的主机和端口
- 支持远程访问网关所在局域网内的管理页面和应用服务

## 访问说明

应用使用 `network_mode: host`，gateway-go Web 页面固定监听宿主机 `34323` 端口。安装后访问 `http://<服务器 IP>:34323` 查看二维码，再使用云亿连/OpenIoTHub 客户端扫码添加网关。

## 安全说明

gateway-go 需要 host 网络以发现并访问局域网服务，这会扩大容器网络权限边界。请仅在可信主机上部署，并确认 34323 端口不会暴露到不可信公网。

维护侧扫描 `openiothub/gateway-go` 镜像时发现可修复 Critical/High CVE，主要来自 Alpine OpenSSL 运行时包与 Go 依赖。当前按功能需求和来源可信度接受该风险入库，建议上游镜像更新后及时升级。

## Introduction

gateway-go is the OpenIoTHub LAN gateway for remote access to services behind NAT or firewall.

## Features

- Supports Android, iOS, macOS, Windows, and Linux clients
- Supports ARM and x86 container images
- Provides P2P remote access after pairing the gateway from the client
- Helps access management pages and application services inside the LAN
