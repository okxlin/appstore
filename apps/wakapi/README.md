# Wakapi

## 产品介绍

Wakapi 是一个极简、自托管且兼容 WakaTime 客户端的开发统计后端，可用于记录并分析项目、语言、编辑器、主机和操作系统维度的编码活动。

## 主要功能

- 兼容 WakaTime 客户端和插件
- 项目、编程语言、编辑器和主机统计
- REST API、统计徽章和 Prometheus 指标导出
- 周报邮件和多种数据导入方式

## 访问说明

- 默认 Web 端口为 `3000`，可在安装表单中修改。
- 首次访问后注册账户，然后在 Wakapi 页面中获取 API Key。
- 在 WakaTime 客户端的 `~/.wakatime.cfg` 中将 `api_url` 设为 `http(s)://<Wakapi 域名或 IP>/api`，并填入账户的 API Key。
- 创建首个账户后，建议在 1Panel 应用参数中将“允许注册”改为 `false`。

## 数据与安全

- 此应用包使用 Wakapi 官方 Docker 镜像的默认 SQLite 模式，数据库位于持久化目录中的 `wakapi.db`。Wakapi 上游也支持 PostgreSQL 和 MySQL，但本应用包未启用外部数据库联动。
- “密码盐”用于密码哈希，安装时应使用随机值；创建账户后不要修改，并在备份时一并保留应用参数。
- 官方镜像以 UID/GID `65532:65532` 的非 root 用户运行。应用内的默认相对数据目录会在安装时自动设置权限；如果指定已存在的绝对路径，请先将该目录属主设为 `65532:65532`。
- 直接通过 HTTP 访问时保持“允许非安全 Cookie”为 `true`。如果通过带 SSL 证书的 HTTPS 反向代理访问，应将其改为 `false`。

## Introduction

Wakapi is a minimalist, self-hosted WakaTime-compatible backend for coding statistics. It tracks activity by project, language, editor, host and operating system.

## Features

- WakaTime client and plugin compatibility
- Coding statistics across projects, languages, editors and hosts
- REST API, badges and Prometheus exports
- Weekly e-mail reports and data imports

This package uses the official image's SQLite mode and persists `/data`. Keep the generated password salt unchanged after accounts are created. Disable sign-up after creating the initial account, and set insecure cookies to `false` when serving Wakapi through HTTPS.

## 参考资料

- 项目主页：<https://wakapi.dev/>
- 安装与配置：<https://github.com/muety/wakapi>
- 源码仓库：<https://github.com/muety/wakapi>
