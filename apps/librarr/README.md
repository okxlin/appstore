## 产品介绍

**Librarr** 是一个面向电子书、有声书和漫画的自托管媒体管理器。它提供统一的 Web 界面，用于管理本地媒体库、愿望单、搜索和下载流程。

## 主要功能

- 分别管理电子书、有声书和漫画目录。
- 维护愿望单、阅读记录、标签和作者监控。
- 支持上传本地媒体文件并整理到对应媒体目录。
- 可按需连接 qBittorrent、Audiobookshelf、Kavita、Komga 等外部服务。

## 访问说明

- 安装完成后打开 Web 端口。
- 首次访问时注册管理员账号；首个用户会自动成为管理员。
- 媒体目录默认为应用版本目录下的 `data/ebooks`、`data/audiobooks` 和 `data/manga`，也可在安装表单中改为其他宿主机路径。

## 数据与升级

- 用户、愿望单、设置和活动记录保存在应用数据目录中的 SQLite 数据库里。
- 三类媒体文件保存在安装表单所选的宿主机目录中。
- 应用限制为单实例，以避免多个实例争用同一数据目录。
- 卸载脚本不会删除媒体目录。卸载或升级前请备份数据库卷和媒体目录。
- `latest` 为浮动镜像，适合通过容器更新工具跟踪上游发布；固定版本用于可重复部署。

## 默认工作流

首次注册管理员后，可以添加和删除愿望单条目，也可以上传一个有效的电子书文件并在上传记录中查看。该流程可用于确认身份验证、SQLite 持久化、媒体目录写入和重启恢复均正常。

## 参考资料

- 项目仓库：<https://github.com/JeremiahM37/librarr>
- 容器镜像：<https://github.com/JeremiahM37/librarr/pkgs/container/librarr>

## Introduction

Librarr is a self-hosted media manager for ebooks, audiobooks, and manga. It provides a unified Web interface for local libraries, wishlists, search, and download workflows.

## Features

- Manage separate ebook, audiobook, and manga directories.
- Maintain wishlists, reading history, tags, and monitored authors.
- Upload local media files and organize them into the selected directories.
- Optionally integrate qBittorrent, Audiobookshelf, Kavita, Komga, and other services.

## First use

Open the Web port and register the first account, which becomes the administrator. The application data path and three media paths can be selected during installation.
