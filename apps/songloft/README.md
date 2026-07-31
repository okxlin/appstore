## 产品介绍

**Songloft** 是一个自托管的个人音乐服务器，提供本地音乐扫描、元数据管理、网页播放、播放列表和跨平台客户端支持。此应用使用上游完整版镜像，内置 Web 界面并使用 SQLite，无需外部数据库。

## 主要功能

- 扫描本地音乐目录并提取封面与音频元数据。
- 在 Web 界面中浏览、搜索和播放音乐。
- 支持播放列表、播放历史、歌词、网络音频和视频容器。
- 提供 REST API、跨平台客户端和插件扩展能力。
- 将 SQLite 数据库、配置、插件、缓存和运行二进制保存在独立数据目录。

## 访问说明

- 安装时必须填写管理员密码，不会使用上游不安全的 `admin/admin` 默认凭据。
- 安装完成后，通过应用详情中的 Web 端口访问 Songloft，并使用安装表单中的管理员账号和密码登录。
- 音乐目录在容器内挂载为 `/app/music`。将音乐文件放入安装表单选择的宿主机目录，然后在 Web 界面中执行扫描。
- 默认健康检查访问 `/api/v1/health`，不会代替实际登录、扫描和播放验证。

## 数据与升级

- 数据目录包含 SQLite 数据库、配置、插件、缓存、日志以及上游 entrypoint 管理的 `songloft` 运行二进制。
- 音乐目录可能被扫描、导入或整理，因此默认以可写方式挂载。升级前应同时备份数据目录和音乐目录。
- 建议通过 1Panel 更新应用镜像。上游应用内升级会替换数据目录中的运行二进制，该二进制可能在容器重启或镜像回滚后继续生效。
- 如需恢复到镜像自带版本，请先备份数据，再停止应用并移除数据目录中的 `songloft` 运行二进制；下次启动时上游 entrypoint 会从镜像重新复制。
- 卸载时是否删除绑定目录由 1Panel 的卸载选项决定，应用脚本不会主动删除用户音乐或数据库。

## 安全说明

- 不要使用弱管理员密码。通过反向代理对公网提供服务时应启用 HTTPS，并限制管理入口的访问范围。
- 插件和网络音频功能可能访问外部地址，请只安装可信插件并审查其权限。

## Introduction

Songloft is a self-hosted personal music server for scanning, managing, and playing a local music library. This package uses the upstream full image with its embedded Web interface and SQLite database.

## Features

- Scan local music and extract cover art and audio metadata.
- Browse, search, and play music from the built-in Web interface.
- Manage playlists, play history, lyrics, network audio, and video containers.
- Use REST APIs, cross-platform clients, and optional plugins.
- Persist the database, configuration, plugins, cache, logs, and managed runtime binary.

## Links

- Website: https://songloft.hanxi.cc
- Project: https://github.com/songloft-org/songloft
- Image: https://hub.docker.com/r/songloft/songloft
