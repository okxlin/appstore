# Baby Buddy

## 应用简介

Baby Buddy 是一款自托管的婴幼儿护理记录工具，帮助家长记录喂养、睡眠、换尿布、成长曲线等信息。

## 产品介绍

Baby Buddy 基于 Django 构建，使用 SQLite 作为默认数据库。本应用使用 LinuxServer 社区维护的多架构 Docker 镜像，开箱即用。

## 主要功能

- 记录喂养、睡眠、换尿布、 tummy time 等活动
- 跟踪成长曲线（身高、体重、头围）
- 多用户支持
- 统计报表与可视化
- 支持 Home Assistant 集成

## 访问说明

- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 默认端口为 `8000`，可通过 `PANEL_APP_PORT_HTTP` 自定义。
- 首次访问时，使用默认账号 `admin` / `admin` 登录，并立即修改密码。
- 数据保存在 `APP_DATA_DIR` 映射的 `/config` 目录中。

## 数据持久化

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据目录（映射到容器 /config） | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web UI 端口 | 8000 | 是 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| PUID | 用户 ID | 1000 | 是 |
| PGID | 用户组 ID | 1000 | 是 |
| TZ | 时区 | Asia/Shanghai | 是 |

## Introduction

Baby Buddy is a self-hosted baby care tracking application for feeding, sleep, diaper changes, and growth records.

## Features

- Track feeding, sleep, diaper changes, tummy time, and other activities
- Growth curve tracking (height, weight, head circumference)
- Multi-user support
- Statistics and visualizations
- Home Assistant integration support

## References

- GitHub：<https://github.com/babybuddy/babybuddy>
- 文档 / Docs：<https://docs.baby-buddy.net>
- Docker 镜像 / Image：<https://github.com/linuxserver/docker-babybuddy>
