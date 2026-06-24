# WireGuard

## 产品介绍

WireGuard 是一种简单、快速且现代化的 VPN。该应用使用 LinuxServer.io 维护的 `linuxserver/wireguard` 镜像，保留官方镜像的 `/config` 持久化目录、UDP 服务端口和 Peer 配置生成方式。

## 主要功能

- 部署 WireGuard VPN 服务端
- 自动生成服务端和 Peer 配置
- 支持自定义服务端地址、Peer 数量、DNS、内网网段和 Allowed IPs
- 持久化保存 WireGuard 配置文件

## 访问说明

安装时请将“Host address”改为客户端可访问的公网 IP 或域名。安装完成后，客户端配置会生成在配置目录下的 `peer*` 子目录中，默认 UDP 端口为 `51820`。

## 运行说明

该应用需要 `NET_ADMIN` 和 `SYS_MODULE` 能力，并挂载主机 `/lib/modules`，用于加载和管理 WireGuard 网络能力。请只在可信主机上部署，并确认防火墙已放行所设置的 UDP 端口。

## Introduction

WireGuard is a simple, fast, and modern VPN. This package uses the LinuxServer.io `linuxserver/wireguard` image and keeps its official `/config` persistence path, UDP server port, and peer configuration workflow.

## Features

- Deploy a WireGuard VPN server
- Generate server and peer configuration files
- Configure server address, peer count, DNS, internal subnet, and allowed IPs
- Persist WireGuard configuration files

## Access

Set "Host address" to the public IP address or domain name reachable by clients before installation. After installation, peer configuration files are created under `peer*` directories in the config path. The default UDP port is `51820`.

## Runtime Notes

This app requires `NET_ADMIN` and `SYS_MODULE` capabilities and mounts host `/lib/modules` so WireGuard networking can be managed by the container. Deploy it only on trusted hosts and allow the configured UDP port in the firewall.
