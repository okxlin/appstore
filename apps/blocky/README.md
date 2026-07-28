# Blocky

## 产品介绍

Blocky 是快速、轻量的 DNS 代理与广告拦截器，支持加密上游、域名列表、缓存、自定义 DNS 和多种现代 DNS 协议。

## 主要功能

- 通过 TCP 和 UDP 提供 DNS 解析
- 使用 DNS-over-TLS 上游保护转发流量
- 通过 StevenBlack hosts 列表拦截广告和跟踪域名
- 将配置和下载列表缓存保存在持久化数据目录
- 支持自定义上游、名单、重写和客户端分组

## Introduction

Blocky is a fast, lightweight DNS proxy and ad blocker with encrypted upstreams, domain lists, caching, custom DNS, and modern DNS protocol support.

## Features

- Serve DNS over TCP and UDP
- Forward through encrypted DNS-over-TLS upstreams
- Block advertising and tracking domains with the StevenBlack hosts list
- Keep configuration and downloaded-list cache in a persistent data directory
- Support custom upstreams, lists, rewrites, and client groups

## 访问说明

- 默认监听宿主机 `127.0.0.1:5353`，仅供本机使用。
- 若要供局域网客户端使用，将 `DNS_BIND_ADDRESS` 改为服务器的局域网 IP，并将客户端 DNS 指向该地址和 `PANEL_APP_PORT_DNS`。
- 不要把 DNS 端口暴露到互联网。请使用主机防火墙或安全组仅允许受信任的局域网或 VPN 网段，否则会形成可滥用的开放递归解析器。
- 本包不发布 Blocky 的无认证 HTTP 管理 API；修改阻止状态或刷新列表请在受控环境中使用容器命令或编辑配置。
- 若宿主机的目标端口已被系统 DNS 服务占用，请选择其他端口或先处理冲突。

## Access and network security

- The host binding defaults to `127.0.0.1:5353` for local-only use.
- For LAN clients, set `DNS_BIND_ADDRESS` to the server's LAN address and point clients to that address and `PANEL_APP_PORT_DNS`.
- Never expose the DNS port to the public internet. Restrict it to trusted LAN or VPN ranges with the host firewall or security group to avoid operating an abusable open recursive resolver.
- This package does not publish Blocky's unauthenticated HTTP management API. Use controlled container commands or edit the configuration for administrative changes.
- Choose another host port or resolve the conflict if a system DNS service already owns the requested port.

## 配置

默认配置位于所选数据目录的 `config.yml`，使用 Cloudflare 和 Quad9 的 DNS-over-TLS 服务，并启用 StevenBlack hosts 拦截列表。修改后通过 1Panel 重启应用。升级时初始化脚本会保留已有配置和下载列表缓存。删除应用数据前请自行备份配置。

The `config.yml` in the selected data directory uses Cloudflare and Quad9 DNS-over-TLS upstreams and enables the StevenBlack hosts blocklist. Restart the app in 1Panel after editing it. Upgrades preserve the existing configuration and downloaded-list cache. Back up the configuration before deleting application data.

## 参考资料

- 官网: <https://0xerr0r.github.io/blocky/>
- 源码: <https://github.com/0xERR0R/blocky>
- 安装文档: <https://0xerr0r.github.io/blocky/latest/installation/>
- 配置文档: <https://0xerr0r.github.io/blocky/latest/configuration/>
