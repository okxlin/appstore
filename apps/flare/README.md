# Flare

## 产品介绍

Flare 是一款轻量、快速的个人导航页与书签管理器。它使用单个 Go 程序运行，无需数据库，并提供在线编辑器来管理导航内容。

## 主要功能

- 管理个人导航入口和书签分组
- 通过在线编辑器维护书签和页面内容
- 内置使用向导和 Material Design Icons 图标库
- 支持登录保护，适合通过网络访问的部署

## 部署说明

- 本应用使用官方 `soulteary/flare` 镜像和单容器 Docker Compose 部署。
- Web 端口由 `PANEL_APP_PORT_HTTP` 配置。
- 登录账号和密码分别由 `FLARE_USER`、`FLARE_PASS` 配置；密码由 1Panel 在安装时随机生成。
- 安装后通过 1Panel 显示的 Web 端口访问首页。
- 使用向导位于 `/guide`，在线编辑器位于 `/editor`。

## 访问说明

安装完成后，通过 1Panel 应用详情中显示的 Web 端口访问 Flare。使用安装表单中的账号和随机生成的密码登录，再访问 `/editor` 编辑书签；`/guide` 提供内置操作向导。

## 数据持久化

`APP_DATA_DIR` 会挂载到容器内的 `/app`，其中保存书签、应用入口和页面设置。升级、迁移或修改数据目录前，请先通过 1Panel 备份该目录。

## 版本与升级

应用商店同时提供滚动更新版本和固定版本。需要可重复部署时请选择固定版本；升级后应确认登录、书签和页面设置仍然可用。

## Introduction

Flare is a lightweight and fast personal start page and bookmark manager. It runs as a single Go application without a database and includes an online editor for managing navigation content.

The Web port is configured with `PANEL_APP_PORT_HTTP`. Sign in with the `FLARE_USER` and generated `FLARE_PASS` values, open `/guide` for the built-in guide, and use `/editor` to manage bookmarks. `APP_DATA_DIR` is mounted at `/app`; back up this directory before upgrades or migrations.

## Features

- Personal start page with grouped applications and bookmarks
- Built-in online editor and guided tour
- Login protection for network-accessible deployments
- Transparent file-based persistence without a database

## 参考资料

- 部署项目: <https://github.com/soulteary/docker-flare>
- 源码: <https://github.com/soulteary/flare>
- 启动参数: <https://github.com/soulteary/docker-flare/blob/main/docs/advanced-startup.md>
- 账号配置: <https://github.com/soulteary/docker-flare/blob/main/docs/application-account.md>
