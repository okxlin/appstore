# This Week in Past

## 产品介绍

This Week in Past 会扫描指定的照片库，按拍摄日期找出往年同一周的照片，并在浏览器中生成自动播放的幻灯片。如果本周没有匹配照片，应用会回退到随机照片。

## 主要功能

- 根据照片 EXIF 拍摄日期展示往年本周回忆
- 在没有本周照片时显示随机照片
- 支持浏览器上一张、暂停/继续和下一张操作
- 支持隐藏指定照片，并将隐藏状态保存在 SQLite 数据库中
- 可设置幻灯片播放间隔和随机播放模式

## 安装与访问

- `PHOTO_LIBRARY_PATH` 指向主机上的照片目录，容器只读挂载该目录。
- `APP_DATA_DIR` 保存 SQLite 数据库和应用缓存，默认由应用包管理。
- Web 端口由 `PANEL_APP_PORT_HTTP` 设置，安装后通过 `http://<服务器 IP>:<端口>` 访问。
- 首次索引时间取决于照片数量和存储性能。

## 访问说明

安装完成后，使用 `http://<服务器 IP>:<Web 端口>` 访问应用。应用没有登录认证；从外部网络访问时，请通过 1Panel 反向代理配置 HTTPS 和访问控制。

## 数据与安全

- 照片库始终以只读方式挂载，应用不会修改原始照片。
- `APP_DATA_DIR` 包含隐藏照片列表、索引和缓存，重启或更新时会继续使用。
- 应用本身不提供登录认证。请勿直接暴露到不可信网络；远程访问时应通过 1Panel 反向代理配置 HTTPS 和访问控制。
- 卸载应用不会删除照片库。迁移或清理前请单独备份应用数据目录。

## Introduction

This Week in Past scans a photo library and builds a browser slideshow from photos taken during the same calendar week in previous years. When no matching photos exist, it falls back to random photos.

## Features

- Build weekly memories from photo EXIF capture dates
- Fall back to random photos when the current week has no matches
- Navigate, pause, and resume the slideshow in the browser
- Hide selected photos and persist that state in SQLite
- Configure the slideshow interval and random mode

## Storage and Security

- `PHOTO_LIBRARY_PATH` is mounted read-only at `/resources`; original photos are never modified.
- `APP_DATA_DIR` stores the SQLite database and application cache and survives restarts and updates.
- The application does not include authentication. Do not expose it directly to an untrusted network; use a 1Panel reverse proxy with HTTPS and access control for remote access.
- Uninstalling the application does not delete the photo library.

## Links

- Project: <https://github.com/RouHim/this-week-in-past>
- Docker image: <https://hub.docker.com/r/rouhim/this-week-in-past>
- Frozen Docker documentation: <https://github.com/RouHim/this-week-in-past/blob/1cbf1e33bc96810d14549daf19e62ac0ecf9eb5d/README.md>
