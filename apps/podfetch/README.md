# PodFetch

## 产品介绍

PodFetch 是一个自托管的播客管理器和下载器，提供 Web 界面、全文检索以及多种移动端和订阅阅读器集成。

## 主要功能

- 订阅、刷新和下载公开播客源。
- 使用 SQLite 保存订阅、用户和播放状态。
- 将播客媒体保存到独立目录，便于备份或迁移。
- 支持基本认证、OIDC、GPodder 和 Audiobookshelf 兼容接口。

## 访问说明

- 默认启用基本认证，请使用安装表单中的管理员用户名和密码登录。
- `播客目录` 和 `数据库目录` 都是持久化边界，卸载应用时不会自动删除。
- 如使用反向代理，请启用 WebSocket 并转发标准的 `X-Forwarded-*` 头。

## Introduction

PodFetch is a self-hosted podcast manager and downloader with a web interface, full-text search, and integrations for mobile apps and feed readers.

## Features

- Subscribe to, refresh, and download public podcast feeds.
- Store subscriptions, users, and playback state in SQLite.
- Keep downloaded media in a separate directory for backup and migration.
- Supports Basic authentication, OIDC, GPodder, and Audiobookshelf-compatible APIs.

## 参考资料

- 文档：<https://samtv12345.github.io/PodFetch/>
- 源码：<https://github.com/SamTV12345/PodFetch>
