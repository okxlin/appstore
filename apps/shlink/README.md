# Shlink

## 产品介绍

Shlink 是一个开源、自托管的短链接管理平台，提供 REST API、访问统计、自定义短码、标签、重定向规则和多域名支持。

本应用包使用 Shlink 官方容器镜像，并复用 1Panel 管理的 PostgreSQL Runtime。应用 Compose 只包含一个 Shlink 服务，不内置数据库 sidecar。

## 主要功能

- 创建、编辑和统计短链接
- 自定义短码、标签、域名和动态重定向规则
- 提供版本化 REST API、健康检查和访问分析

## 访问说明

- Shlink 是 API 服务，不自带管理网页。可使用官方托管的 Shlink Web Client（`https://app.shlink.io`）或自行部署兼容客户端。
- API 基础地址为 `http://<服务器地址>:<HTTP 端口>/rest/v3`。
- 健康检查地址为 `http://<服务器地址>:<HTTP 端口>/rest/health`。
- 首次安装时填写的 Initial API Key 用于调用受保护的 REST API，请妥善保存。
- Default Domain 应填写短链接使用的域名或 `域名:端口`；启用反向代理 HTTPS 后，将 HTTPS Enabled 改为 `true`。

## 数据与升级

- 业务数据存放在所选的 1Panel PostgreSQL Runtime 中；升级前应备份对应数据库。
- Shlink 启动时会执行官方数据库迁移。升级过程中请等待健康检查恢复，不要中断容器或数据库。
- 本应用包不挂载额外业务数据目录；容器内缓存和日志可随容器重建。

## 安全默认值

- 官方镜像以非 root 用户运行。
- 自动抓取长链接网页标题默认关闭（`AUTO_RESOLVE_TITLES=false`），用于收窄当前镜像中 `libcurl`/`c-ares` 已知高危漏洞的可达面。
- GeoLite 初始下载默认跳过；如需地理位置数据库，请按照 Shlink 官方文档配置许可证并重新评估镜像安全状态。

## Introduction

Shlink is an open-source, self-hosted URL shortener with REST APIs, visit analytics, custom slugs, tags, redirect rules, and multi-domain support.

This package uses the official Shlink image and a selectable 1Panel-managed PostgreSQL Runtime. Its Compose topology contains one Shlink service and no bundled database sidecar.

## Features

- Create, edit, tag, and analyze short URLs
- Support custom slugs, domains, and dynamic redirect rules
- Expose versioned REST APIs and a database-aware health endpoint

## Usage

- Shlink is API-only and does not include an administration UI. Use the official Shlink Web Client at `https://app.shlink.io` or a compatible self-hosted client.
- The API base path is `http://<server>:<HTTP port>/rest/v3`; health is exposed at `/rest/health`.
- Keep the Initial API Key secret. Back up the selected PostgreSQL database before upgrades.
- Automatic long-URL title resolution is disabled by default to reduce exposure to a known high-severity `libcurl`/`c-ares` issue in the current upstream image.

Sources: `https://github.com/shlinkio/shlink` and `https://shlink.io/documentation/install-docker-image/`.
