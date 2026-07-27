# Downtify

## 产品介绍

Downtify 是自托管的音乐下载与管理工具，可从 Spotify 曲目或播放列表查找匹配音源，下载音频并写入封面和元数据。

## 主要功能

- 曲目、专辑和播放列表下载
- 音频格式、码率、目录结构和歌词设置
- 播放列表监控、M3U 导出和浏览器播放器

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。Downtify 没有内置身份认证，任何能够访问端口的用户都可以提交媒体 URL、修改设置、删除下载记录和管理文件。仅在受信任网络中开放，或在前置反向代理中启用可靠的身份认证与访问限制；不要直接暴露到公网。

下载内容保存在 `APP_DOWNLOADS_DIR`，应用设置和播放列表监控数据库保存在 `APP_DATA_DIR`。两个路径必须位于应用版本目录内；初始化脚本会拒绝绝对路径和目录外路径，并设置为容器使用的 UID/GID `1000:1000`。卸载不会删除这些数据，升级或迁移前请备份。

## 安全与漏洞警告

- 固定镜像包含 yt-dlp `2026.6.9` 的 High 漏洞 `CVE-2026-55404`，修复版本为 `2026.7.4`。该漏洞影响 yt-dlp 的 `.url` 和 `.desktop` 快捷方式写入选项；Downtify 的正常下载配置未启用这些选项，因此已知利用路径在默认流程中不可达。镜像仍会处理用户提交的媒体 URL 和外部媒体数据，只允许受信任用户使用，并在上游发布包含修复版 yt-dlp 的镜像后立即升级。
- 容器以非 root UID/GID `1000:1000` 运行，丢弃全部 Linux capabilities，并启用只读根文件系统和 `no-new-privileges`。
- 用户应遵守内容来源的使用条款和当地法律，不要下载未经授权的受版权保护内容。

## Introduction

Downtify is a self-hosted music downloader and library manager that matches Spotify tracks and playlists to audio sources, downloads them, and embeds artwork and metadata.

## Features

- Track, album, and playlist downloads
- Audio format, bitrate, directory layout, and lyrics settings
- Playlist monitoring, M3U export, and a browser player

## Usage Notes

- Access the service at `http://<server-ip>:<port>`. Downtify has no built-in authentication. Anyone who can reach the port can submit media URLs, change settings, delete download records, and manage files. Restrict it to trusted networks or place it behind an authenticated reverse proxy; do not expose it directly to the public internet.
- `APP_DOWNLOADS_DIR` stores downloaded media, while `APP_DATA_DIR` stores settings and the playlist-monitor database. Both paths must remain relative to the application version directory. Uninstalling the app preserves these directories.

## Security and Vulnerability Warning

- The pinned image contains High-severity `CVE-2026-55404` in yt-dlp `2026.6.9`; the fixed version is `2026.7.4`. The issue affects yt-dlp's `.url` and `.desktop` shortcut-writing options, which Downtify does not enable in its normal download flow, so the known exploit path is not reachable by default. The service still processes user-supplied media URLs and external media data. Limit use to trusted users and upgrade as soon as upstream publishes an image containing the fixed yt-dlp release.
- The container runs as non-root UID/GID `1000:1000`, drops all Linux capabilities, and enables a read-only root filesystem plus `no-new-privileges`.
- Users are responsible for complying with source terms and applicable copyright law.

## References

- Project: <https://github.com/henriquesebastiao/downtify>
- Docker deployment: <https://downtify.henriquesebastiao.com/getting-started/docker-compose/>
- Environment variables: <https://downtify.henriquesebastiao.com/getting-started/environment-variables/>
- License: <https://github.com/henriquesebastiao/downtify/blob/main/LICENSE> (GPL-3.0)
- Vulnerability: <https://nvd.nist.gov/vuln/detail/CVE-2026-55404>
