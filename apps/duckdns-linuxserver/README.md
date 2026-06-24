# DuckDNS
## 产品介绍

DuckDNS 使用 LinuxServer.io 维护的 `linuxserver/duckdns` 镜像，提供 DuckDNS 动态 DNS 更新服务能力。

## 主要功能

- 将 DuckDNS 子域名更新到当前公网 IP
- 持久化保存配置和业务数据
- 使用安装表单配置子域名、令牌、IP 更新模式和日志开关
- 支持自定义时区

## 访问说明

安装完成后，容器会定期向 DuckDNS 更新子域名记录；该应用没有 Web 界面。`SUBDOMAINS` 填写 DuckDNS 子域名前缀，多个值使用英文逗号分隔，例如 `home,media`。

## 运行说明

`UPDATE_IP=ipv4` 为默认模式；选择 `ipv6` 或 `both` 时，LinuxServer 官方文档建议使用 host networking 以便 IPv6 检测。本通用适配保留 bridge 网络，适合常规 IPv4 更新场景。

## Introduction

DuckDNS uses the LinuxServer.io maintained `linuxserver/duckdns` image for DuckDNS dynamic DNS updates.

## Features

- Update DuckDNS subdomains to the current public IP address
- Persist configuration and application data
- Configure subdomains, token, IP update mode, and log writing from the install form
- Configure the container time zone

## Access

After installation, the container periodically updates DuckDNS records; this app does not provide a Web UI. Set `SUBDOMAINS` to DuckDNS subdomain prefixes, separated by commas, for example `home,media`.

## Runtime Notes

`UPDATE_IP=ipv4` is the default mode. LinuxServer's documentation recommends host networking for `ipv6` or `both` detection. This generic package keeps bridge networking for common IPv4 update deployments.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-duckdns/>
- Project website: <https://www.duckdns.org/>
