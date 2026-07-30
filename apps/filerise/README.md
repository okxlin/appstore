# FileRise

## 产品介绍

FileRise 是一个自托管文件管理器和存储中心，提供文件上传、搜索、标签、共享链接、文件夹级访问控制和 WebDAV 访问。

## 主要功能

- 通过 Web 界面上传、预览、搜索、整理和分享文件。
- 为用户配置文件夹级读取、写入和管理权限。
- 通过 WebDAV 从桌面和移动客户端访问文件。
- 支持共享链接、回收站、审计记录以及多种外部存储源。

## 访问说明

默认只监听 `127.0.0.1`，适合通过同机 1Panel 网站反向代理访问。首次打开后按页面提示创建初始管理员。需要从其他主机直接访问时，将绑定地址改为 `0.0.0.0`，并配置防火墙与 HTTPS；通过 HTTPS 访问时应把安全 Cookie 设为 `true`。

## 数据与安全

上传文件、用户资料和元数据分别保存在数据目录的 `uploads`、`users` 和 `metadata` 子目录。`metadata/persistent_tokens.key` 由 FileRise 在首次启动时自动生成，用于保护持久化令牌和配置；备份、迁移和恢复时必须与另外两个目录一起保留。

默认数据目录由初始化脚本准备为 UID/GID `1000:1000`。如使用已存在的绝对目录，其整个目录树必须已由该 UID/GID 所有，初始化脚本不会递归接管所有权。请使用 FileRise 专用子目录，不要指向大型共享目录或文件系统根目录。

卸载应用不会删除这三个绑定目录中的持久化数据。升级、迁移或卸载前请备份完整数据目录。

## Introduction

FileRise is a self-hosted file manager and storage hub with uploads, search, tags, sharing, per-folder access controls, and WebDAV access.

## Features

- Upload, preview, search, organize, and share files from a web interface.
- Configure per-folder read, write, and administrative permissions.
- Access files from desktop and mobile clients through WebDAV.
- Use share links, trash, audit records, and multiple external storage sources.

## Access And First Run

The package binds to `127.0.0.1` by default for use behind a same-host 1Panel reverse proxy. Open FileRise and create the initial administrator when prompted. For direct access from other hosts, change the bind address to `0.0.0.0` and configure a firewall and HTTPS. Set Secure Cookie to `true` when FileRise is accessed through HTTPS.

## Data And Security

Uploads, user records, and metadata are stored in the `uploads`, `users`, and `metadata` children of the configured data directory. FileRise generates `metadata/persistent_tokens.key` on first start to protect persisted tokens and configuration. Keep it with the other two directories during backup, migration, and recovery.

The initializer prepares the default data directory for UID/GID `1000:1000`. When an existing absolute directory is selected, its complete tree must already be owned by that UID/GID; the initializer does not recursively take ownership of it. Use a dedicated FileRise subdirectory rather than a large shared directory or filesystem root.

Uninstalling the app leaves data in these bind-mounted directories intact. Back up the complete data directory before upgrades, migrations, or removal.

## References

- Website: <https://filerise.net/>
- Source: <https://github.com/error311/FileRise>
- Documentation: <https://github.com/error311/FileRise/wiki>
