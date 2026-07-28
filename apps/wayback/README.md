# Wayback

## 产品介绍

Wayback 是开源的网页归档与回放工具。它提供 Web 界面，可将网页提交到 Internet Archive、archive.today 和 Ghostarchive，并聚合多个公共归档服务的回放结果。

## 主要功能

- 从 Web 界面提交一个或多个网页地址
- 聚合多个公共归档服务的结果
- 使用本地 Bolt 数据库保存应用状态

## 访问说明

- 默认仅监听 `127.0.0.1:8964`，实际地址和端口以安装表单为准。远程访问建议使用 HTTPS 反向代理，不要直接暴露到公网。
- Wayback Web 界面没有内置用户认证。能够访问该界面的用户可以让服务器请求外部 URL，并可能访问服务器可达的内部地址。请使用反向代理认证、网络访问控制和出站防火墙限制不受信任用户。
- 默认禁用 Wayback 的 Tor、Telegraph 和 IPFS 集成。官方 Compose 中的无头浏览器不能绕过当前应用对本地 Chromium 的前置检查，同时其当前镜像存在 Critical 漏洞，因此本包不包含该可选依赖。
- Meilisearch 是可选的归档索引与回放增强服务，不属于本包的默认拓扑。
- 当前官方 Wayback 镜像的安全扫描结果为 0 个 Critical、7 个 High。源码与运行路径复核未发现这些 High 在本包默认配置下的可达路径，但相关上游组件仍保留在镜像中；上游发布修复镜像后应及时更新。

## 数据与备份

应用数据保存在 `DATA_PATH`，其中 `wayback.db` 是 Bolt 数据库。升级或卸载前请备份整个目录。

## Introduction

Wayback is an open-source web archiving and playback tool. This package runs the official single image in Web mode with Internet Archive, archive.today, and Ghostarchive enabled. Optional browser, Telegraph, IPFS, Tor, and Meilisearch integrations are not enabled by default.

The Web interface has no built-in authentication and can make outbound requests to user-supplied URLs. Keep the default loopback binding or place it behind an authenticated HTTPS reverse proxy with appropriate egress controls. Back up the complete data directory before upgrades or uninstalling.

The current official Wayback image scans at 0 Critical and 7 High findings. Source and runtime-path review found no demonstrated reachability in this package's default configuration, but the affected upstream components remain present and the package should be updated when upstream publishes a fixed image.

## Features

- Submit one or more URLs from the Web interface
- Collect results from multiple public archive services
- Persist application state in a local Bolt database

## References

- Website: <https://wabarc.eu.org/>
- Source: <https://github.com/wabarc/wayback>
- Documentation: <https://docs.wabarc.eu.org/>
- License: GPL-3.0
