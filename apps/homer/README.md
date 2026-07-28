# Homer

## 产品介绍

Homer 是一个由 YAML 文件配置的轻量级静态仪表板，可将自托管服务、状态信息和常用链接集中在一个页面中。

## 主要功能

- 使用 YAML 配置页面、分组、链接和主题
- 支持多页面、搜索、键盘快捷键和渐进式 Web 应用
- 可通过智能卡片展示兼容服务的状态信息
- 配置文件、图标和其他资源保存在本地持久化目录

## 访问说明

安装后，通过 1Panel 显示的 Web 端口访问 Homer。首次启动会在 `data/assets` 中安装示例资源并生成 `config.yml`。编辑该文件即可定制页面；升级不会覆盖已有配置。

## Introduction

Homer is a lightweight static dashboard configured through YAML. It keeps self-hosted services, status information, and frequently used links on one page.

## Features

- YAML configuration for pages, groups, links, and themes
- Multiple pages, search, keyboard shortcuts, and progressive web app support
- Smart cards for status information from compatible services
- Persistent local storage for configuration, icons, and other assets

## Deployment And Security

- The package uses the official `b4bz/homer` image and its non-root UID/GID `1000:1000` runtime.
- The container serves plain HTTP on its internal port. Terminate TLS at the 1Panel reverse proxy when exposing it outside a trusted network.
- Homer is a client-side dashboard. Credentials placed in `config.yml` may be delivered to visitors' browsers; use read-only tokens with the narrowest possible scope and do not store administrative secrets there.
- The container drops all Linux capabilities, prevents privilege escalation, and uses a read-only root filesystem. Only `data/assets` and a temporary `/tmp` filesystem are writable.

## Data Persistence

Configuration, icons, and custom assets are stored in `./data/assets` and mounted at `/www/assets`. Back up the `data` directory before upgrades or migrations.

## References

- Demo: <https://homer-demo.netlify.app/>
- Source: <https://github.com/bastienwirtz/homer>
- Documentation: <https://github.com/bastienwirtz/homer/tree/main/docs>
- Configuration: <https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md>
