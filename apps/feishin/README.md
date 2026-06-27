# Feishin

## 产品介绍
Feishin 是现代化自托管音乐服务器 Web 播放器，可连接 Navidrome、Jellyfin 或 OpenSubsonic 兼容服务进行音乐浏览与播放。

## 主要功能
- 提供现代化 Web 音乐播放界面
- 支持 Navidrome、Jellyfin 和 OpenSubsonic 兼容服务器
- 支持通过环境变量预置服务器地址，并默认关闭 Umami analytics

## 访问说明
安装后通过 `http://<服务器 IP>:15078` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Feishin is a modern web music player for self-hosted Navidrome, Jellyfin and OpenSubsonic-compatible music servers.

## Features
- Modern web music player interface
- Supports Navidrome, Jellyfin and OpenSubsonic-compatible servers
- Optional server preconfiguration through environment variables, with Umami analytics disabled by default

## 部署说明
- 本应用使用官方 GitHub Container Registry 镜像 `ghcr.io/jeffvli/feishin` 部署。
- Feishin 是 Web 播放器，不自带音乐服务器；请先准备 Navidrome、Jellyfin 或 OpenSubsonic 兼容服务。
- 应用分类：多媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Feishin Web 访问端口 | 15078 | 是 |

## 数据持久化
Feishin Docker Web 版本默认不需要挂载服务端数据目录；播放服务器和用户数据由你连接的 Navidrome、Jellyfin 或 OpenSubsonic 服务保存。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ANALYTICS_DISABLED | 是否禁用 Umami analytics | true | 是 |
| SERVER_NAME | 预置音乐服务器名称 | 空 | 否 |
| SERVER_TYPE | 预置音乐服务器类型：jellyfin、navidrome、subsonic | 空 | 否 |
| SERVER_URL | 预置音乐服务器地址 | 空 | 否 |
| SERVER_LOCK | 是否锁定服务器配置 | false | 是 |
| REMOTE_URL | 单独的公网音乐服务器地址 | 空 | 否 |
| LEGACY_AUTHENTICATION | Subsonic/OpenSubsonic 传统认证开关 | false | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 如果设置 `SERVER_LOCK=true`，请同时填写 `SERVER_NAME`、`SERVER_TYPE` 和 `SERVER_URL`。
- 若音乐服务器在内网，请确认 Feishin 容器可以访问该地址。
- 如对公网开放访问，请同步检查防火墙、安全组、反向代理和 HTTPS 配置。

## 参考资料
- 项目仓库: <https://github.com/jeffvli/feishin>
- Docker 使用说明: <https://github.com/jeffvli/feishin#web-and-docker>
- Docker Compose 示例: <https://github.com/jeffvli/feishin#docker-compose>
