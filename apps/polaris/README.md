# Polaris

## 产品介绍

Polaris 是一个自托管的音乐收藏与流媒体服务器，可通过浏览器和移动设备访问个人音乐库。

## 主要功能

- 扫描本地音乐目录并建立可搜索的收藏索引。
- 使用多账户、播放列表和浏览器流媒体功能管理个人音乐库。
- 将账户、播放列表、索引和应用数据库持久化保存。

## 部署说明

- 容器镜像由 Polaris 官方安装文档认可的 Connectical 容器项目提供。
- 安装后访问表单中配置的 HTTP 端口，创建管理员账户并添加 `/music` 音乐目录。
- 音乐目录以只读方式挂载；缓存和应用数据目录由 Polaris 的 UID/GID `100:100` 管理。
- 应用数据包含账户、播放列表、收藏索引和应用数据库，升级前应备份数据目录。
- 卸载不会删除音乐、缓存或应用数据。

## 数据目录

| 变量 | 说明 | 默认值 |
| --- | --- | --- |
| `POLARIS_MUSIC_DIR` | 音乐库目录，只读挂载 | `./data/music` |
| `POLARIS_CACHE_DIR` | 扫描和封面缓存目录 | `./data/cache` |
| `POLARIS_DATA_DIR` | 账户、索引和数据库目录 | `./data/data` |

初始化脚本会拒绝配置目录中的符号链接，并将缓存与数据目录递归设为 `100:100`。请为 Polaris 使用专用目录。

## 访问说明

安装完成后通过 `http://服务器地址:配置端口` 访问。首次使用时创建管理员账户，将 `/music` 添加为收藏目录，然后开始扫描。

## Introduction

Polaris is a self-hosted music collection and streaming server for browsers and mobile devices.

## Features

- Scan a local music directory into a searchable collection.
- Manage multiple users, playlists, and browser-based music streaming.
- Persist accounts, playlists, indexes, and the application database.

## 参考资料

- 项目主页: <https://polaris.stream>
- 源代码: <https://github.com/agersant/polaris>
- 容器说明: <https://github.com/ogarcia/docker-polaris>
