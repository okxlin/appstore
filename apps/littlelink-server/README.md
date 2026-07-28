# LittleLink Server

## 产品介绍

LittleLink Server 是一个轻量级自托管个人链接页面，可通过环境变量配置头像、简介、社交链接、按钮、主题、页面元数据和分析服务。

## 主要功能

- 集中展示个人资料、社交平台和自定义链接
- 支持亮色和暗色主题、头像、页面元数据及搜索引擎设置
- 支持自定义按钮顺序和多种分析服务
- 配置在容器启动时由环境变量提供，无需数据库或持久化目录

## 访问说明

安装后，通过 1Panel 显示的 Web 端口访问页面。常用字段可在应用设置中编辑；其他上游支持的环境变量可直接加入应用 `.env` 和 Compose 环境列表后重建容器。

## Introduction

LittleLink Server is a lightweight self-hosted personal link page. Environment variables configure the profile, social links, custom buttons, theme, metadata, and optional analytics.

## Features

- Profile, social platform, and custom links on one page
- Light and dark themes, avatar, metadata, and crawler settings
- Custom button ordering and optional analytics integrations
- Environment-only configuration with no database or persistent directory

## Deployment And Security

- The package pins the official `latest` image to the reviewed OCI digest because upstream does not publish versioned releases.
- The container runs as the image's non-root `node` user, drops all Linux capabilities, prevents privilege escalation, and uses a read-only root filesystem.
- Values are rendered into a public page. Do not place passwords, private tokens, or non-public URLs in profile fields.
- External avatar and link URLs are loaded by visitors' browsers. Use trusted HTTPS destinations and terminate public access through the 1Panel reverse proxy.
- The default metadata prevents indexing. Change `META_INDEX_STATUS` manually only when the page is ready for public discovery.

## Configuration

The panel form covers the most common settings. `BUTTON_ORDER` defaults to `GITHUB,EMAIL`; remove a value or set its URL field empty to hide that button. The complete environment-variable catalog is maintained in the upstream `.env.example` and Docker Compose file.

## References

- Source: <https://github.com/timothystewart6/littlelink-server>
- Runtime configuration: <https://github.com/timothystewart6/littlelink-server#runtime-configuration>
- Environment example: <https://github.com/timothystewart6/littlelink-server/blob/main/.env.example>
