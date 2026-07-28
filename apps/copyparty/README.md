# Copyparty

## 产品介绍

Copyparty 是一个自托管文件服务器，支持浏览器上传、文件管理、WebDAV 和媒体播放。

## 主要功能

- 通过浏览器上传、下载、整理和预览文件。
- 使用账户和密码保护文件目录；默认账户拥有完整管理权限。
- 将索引数据库、缩略图和文件历史保存在独立的配置目录中。

## 访问说明

- 默认 Web 端口：`3923`
- 容器内部端口：`3923`
- 使用安装时设置的用户名和密码登录。

## 数据与备份

- `Data Directory/files` 保存共享文件。
- `Data Directory/config` 保存 Copyparty 的索引、缩略图和文件历史。
- 卸载会停止并移除容器，但不会删除数据目录。

## 版本

- `latest` 跟随官方 Copyparty 最新发布镜像。
- 固定版本目录用于可重复部署。

## 许可证

Copyparty 上游项目采用 MIT 许可证。

## Introduction

Copyparty is a self-hosted file server with browser uploads, file management, WebDAV, and media playback.

## Features

- Upload, download, organize, and preview files in the browser.
- Protect the shared directory with an account and password; the configured account has full administrative access.
- Keep the index database, thumbnails, and file history in a separate persistent configuration directory.

## Access

- Default web port: `3923`
- Container port: `3923`
- Sign in with the username and password set during installation.

## Data and Backup

- `Data Directory/files` stores shared files.
- `Data Directory/config` stores Copyparty indexes, thumbnails, and file history.
- Uninstall stops and removes the container but keeps the data directory.

## License

Copyparty is licensed under MIT.
