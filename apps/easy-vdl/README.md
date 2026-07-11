# Easy-VDL

## 产品介绍

Easy-VDL 是面向多平台视频下载、作者订阅、直播录制和媒体整理的可视化平台，支持生成 Emby/Jellyfin 元数据、在线回放以及可选的 AI 高光处理。

## 主要功能

- 下载并订阅抖音、Bilibili、YouTube、快手、小红书等平台内容。
- 检测并录制直播，保存弹幕与回放数据。
- 管理下载文件、元数据、海报和媒体库目录。
- 通过企业微信回调端口接收相关机器人请求。

## 访问说明

- Web 端口默认 `888`，企业微信回调端口默认 `8001`。
- 使用安装表单生成的管理员账号和密码登录。
- 首次启动需要初始化镜像内置的 PostgreSQL 数据目录，可能比普通 Web 应用耗时更长。

## 数据持久化

- `DOWNLOAD_DIR` 挂载到 `/app/downloads`，保存视频和媒体文件。
- `LOG_DIR` 挂载到 `/app/logs`，保存运行日志。
- `DATABASE_DIR` 挂载到 `/app/database`，保存内置数据库、配置、Cookie 和浏览器状态。
- 升级前应备份三个目录，尤其是数据库目录。

## 权限与硬件说明

官方镜像入口脚本会根据 `PUID` 和 `PGID` 调整挂载目录权限，并会将下载目录设置为兼容 NAS 多用户访问的宽松权限。数据库目录中可能包含平台 Cookie，请限制宿主机访问权限。

本适配默认使用 CPU 模式，不挂载 `/dev/dri`、不授予 `PERFMON` capability，也不请求 NVIDIA 设备，因此可在无显卡服务器上直接安装。硬件转码与 GPU 监控需要管理员按上游说明自行扩展 Compose，并承担相应设备访问风险。

## 风险与内容说明

- 下载和录制功能可能受到目标平台服务条款、地区限制与账号风控影响。
- 请控制订阅与检测频率，只保存您有权访问和使用的内容。
- Cookie、机器人凭据和通知密钥会保存在数据库目录，请使用 HTTPS 并限制公网访问。

## Introduction

Easy-VDL is a visual platform for multi-site video downloads, subscriptions, live recording, and media management.

## Features

- Subscribe to creators and download videos from multiple platforms.
- Detect and record live streams with comments and replay metadata.
- Organize downloads for Emby and Jellyfin libraries.
- Run in CPU mode by default without host GPU permissions.

## Links

- Project and deployment guide: https://github.com/wlaosj/easy-vdl
- Image: https://hub.docker.com/r/qq918652593/easy-vdl
