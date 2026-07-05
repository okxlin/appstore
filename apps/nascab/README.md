# NasCab

## 产品介绍

NasCab 是一个用于管理文件、照片、电影、音乐和图书的轻量自托管平台，可作为软 NAS 使用，无需专用硬件。本适配基于官方 Docker 镜像 `ypptec/nascab`，提供 1Panel 中可直接安装的基础 Web 管理入口。

## 主要功能

- 统一管理文件、照片、电影、音乐和图书资源
- 使用 Web 界面访问和整理家庭媒体与文件库
- 将媒体内容目录 `/myData` 与应用状态目录 `/root/.local/share/nascab` 分离持久化
- 官方镜像内置 HTTPS、WebDAV、FTP 能力，本适配默认仅暴露 HTTP 入口以降低默认暴露面

## 访问说明

- 安装后通过 `http://<服务器IP>:<端口>` 访问
- 首次启动会初始化数据库、缓存与媒体索引，服务可用可能需要等待几十秒
- 升级前请备份媒体目录与状态目录，尤其是保存数据库与缓存的状态目录
- 如需额外启用 HTTPS、WebDAV 或 FTP 端口，请参考官方部署说明自行扩展 compose 配置：<https://www.nascab.cn/docker.html>

## Introduction

NasCab is a lightweight self-hosted platform for managing files, photos, movies, music, and books. It can serve as a software NAS alternative and this package is built from the official Docker image `ypptec/nascab`.

## Features

- Web-based library for files, photos, movies, music, and books
- Separate persistent mounts for media content and app state, database, and cache
- Default 1Panel package exposes HTTP only to keep the initial surface smaller
- First startup may take a little longer while NasCab initializes its database and indexes
