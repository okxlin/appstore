# Photofield

## 产品介绍

Photofield 是一款注重速度和简洁性的自托管照片图库。它从只读目录索引照片，使用 SQLite 保存缩略图与索引缓存，不会修改原始照片。

## 主要功能

- 可缩放的高密度照片浏览界面
- 快速文件索引、EXIF 元数据读取与多级缩略图缓存
- 支持相册、时间线、瀑布流、地图和高亮等布局
- 支持 JPEG、PNG、HEIF、视频等多种媒体格式
- 原始照片目录以只读方式挂载，缓存与配置独立保存

## 访问说明

应用没有内建账号、认证或授权。安装时默认仅绑定到 `127.0.0.1`，建议通过同机 HTTPS 反向代理访问并在代理层配置认证；只有在可信网络中才应改为 `0.0.0.0`。

照片目录以只读方式挂载到容器。缓存目录包含 `configuration.yaml`、SQLite 索引和缩略图缓存，升级前应备份该目录。卸载时脚本不会主动删除照片或缓存，最终是否移除缓存目录由 1Panel 的卸载选项决定。

媒体解析器处理操作员挂载的文件。当前上游镜像系列曾包含 libjxl 和 TIFF 解码器的高危缺陷；应只挂载可信媒体库、限制网络访问，并及时更新镜像。Photofield 不是面向不可信匿名上传的媒体处理服务。

## Introduction

Photofield is a fast, self-hosted photo gallery focused on simple, non-invasive browsing. It indexes a read-only photo library and keeps generated thumbnails and SQLite cache data in a separate writable data directory.

## Features

- Zoomable, high-density photo browsing
- Fast file indexing, metadata extraction, and thumbnail caching
- Album, timeline, wall, map, and highlight layouts
- Read-only source libraries with separate writable cache data

The application has no built-in authentication or authorization. It binds to `127.0.0.1` by default; publish it through a same-host HTTPS reverse proxy with access control. Mount only trusted media libraries, keep the photo mount read-only, back up the data directory before upgrades, and update promptly when media-decoder fixes are released.
