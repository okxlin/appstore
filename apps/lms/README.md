# LMS

## 产品介绍

LMS（Lightweight Music Server）是一款轻量的自托管音乐服务器，可通过响应式 Web 界面访问个人音乐收藏，并兼容 Subsonic 与 OpenSubsonic 客户端。

## 主要功能

- 支持艺术家、专辑、曲目、流派、心情和多值标签浏览
- 支持音乐库扫描、歌词、播放列表、播客与音频转码
- 提供 Subsonic/OpenSubsonic API、ListenBrainz 和 Last.fm 集成
- 提供多用户管理、收听记录、收藏与音乐推荐

## 访问说明

应用默认仅绑定 `127.0.0.1`，远程访问建议使用同机反向代理。首次打开时，设置向导会创建第一个管理员；登录后请在管理界面将 `/music` 添加为媒体库并开始扫描。

音乐目录以只读方式挂载。安装脚本不会修改现有音乐目录的内容、权限或所有权。LMS 数据目录包含 SQLite 数据库和应用状态，卸载时会保留，备份时应完整保存。

## Introduction

LMS (Lightweight Music Server) is a compact self-hosted music server with a responsive web player and compatibility with Subsonic and OpenSubsonic clients.

## Features

- Browse artists, releases, tracks, genres, moods, and multi-valued tags
- Scan local music libraries and manage lyrics, playlists, podcasts, and transcoding
- Connect through Subsonic/OpenSubsonic and integrate with ListenBrainz or Last.fm
- Manage multiple users, listening history, favorites, and recommendations

The service binds to `127.0.0.1` by default. On first launch, create the administrator with the setup assistant, then add `/music` as a media library. The music mount is read-only, while the complete LMS state directory is retained on uninstall for backup or reinstall.
