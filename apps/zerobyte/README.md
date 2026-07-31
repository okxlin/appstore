# Zerobyte

## 产品介绍

Zerobyte 是一个基于 restic 的自托管备份自动化工具，可管理备份源、加密仓库、计划任务和恢复操作。

## 主要功能

- 管理本地和远程加密备份仓库。
- 按计划备份固定挂载在 `/source` 的目录。
- 浏览快照并将选定内容恢复到原始位置。
- 通过 Web 界面查看任务进度和存储统计。

## 访问说明

默认仅监听 `127.0.0.1`，适合通过同机 1Panel 网站反向代理访问。需要直接从其他主机访问时，将 **绑定地址** 改为 `0.0.0.0`，并配置防火墙和 HTTPS。首次打开 Web 界面时创建管理员账户。`BASE_URL` 必须与实际访问 URL 一致；使用 HTTPS 域名时，Zerobyte 会启用安全会话 Cookie。

## 存储边界

本应用采用 Zerobyte 官方的简化拓扑，不授予 `SYS_ADMIN`，也不挂载 `/dev/fuse`。因此不能在容器内挂载 NFS、SMB、WebDAV 或 SFTP 文件系统，但仍可使用本地目录以及 Zerobyte 支持的本地、S3、GCS、Azure 和 rclone 仓库后端。

安装表单中的 **备份源目录** 只会挂载到容器内固定的 `/source`。该目录必须是专用的非根目录，并且必须可写，因为原位恢复会写回源目录。初始化脚本拒绝文件系统根目录、系统顶层目录、符号链接、应用数据目录以及与应用数据目录相互包含的路径。请勿把不受信任用户能够修改的目录设为备份源。

容器先丢弃所有 Linux capability，再仅添加 `DAC_OVERRIDE`。这是读取和恢复由不同宿主 UID 拥有且权限为 `0600` 的备份文件所需的最小权限；其作用范围受限于容器可见的应用数据目录和单一 `/source` 挂载。Zerobyte 管理员因此能够读取和改写整个备份源目录，请只挂载确实需要备份的专用目录。

Zerobyte 当前没有针对备份操作的细粒度 RBAC。组织成员可以操作仓库、备份源、计划任务和恢复流程，因此只应添加可信运维人员。

## 镜像安全说明

固定版本中的 v0.41.0 镜像快照无 Critical 漏洞，扫描报告包含七个 High 记录：rclone 的 TIFF 解码问题仅位于可选 Internxt 后端；gRPC 问题位于可选 GCS/Google Drive 客户端而非入站服务器或 xDS 控制面；Go `os.Root` 问题在 rclone、restic 和 shoutrrr 的对应源码版本中均无调用点。`latest` 目录使用移动标签，解析到新镜像后应重新评估这些结论。

## Introduction

Zerobyte is a self-hosted backup automation tool built on restic. It manages backup sources, encrypted repositories, schedules, and restores.

## Features

- Manage local and remote encrypted backup repositories.
- Schedule backups for the directory mounted at `/source`.
- Browse snapshots and restore selected content to its original location.
- Monitor task progress and storage statistics from the web UI.

## Access And First Run

The package binds to `127.0.0.1` by default for use behind a same-host 1Panel website reverse proxy. For direct remote access, change **Bind Address** to `0.0.0.0` and configure a firewall and HTTPS. Create the administrator account in the web UI on first use. `BASE_URL` must match the URL users open; Zerobyte enables secure session cookies for HTTPS URLs.

## Storage Boundary

This package follows Zerobyte's official simplified topology. It does not grant `SYS_ADMIN` or mount `/dev/fuse`. Mounting NFS, SMB, WebDAV, or SFTP filesystems inside the container is therefore unavailable, while local directories and Zerobyte's local, S3, GCS, Azure, and rclone repository backends remain available.

The **Backup Source Directory** is mounted only at `/source` inside the container. It must be a dedicated directory rather than a filesystem root, and it must be writable because in-place restores write back to the source. The initialization script rejects filesystem roots, top-level system directories, symbolic links, the application data directory, and paths that contain one another. Do not expose a directory that untrusted users can modify.

The container drops every Linux capability and then adds only `DAC_OVERRIDE`. This is the minimum capability needed to read and restore backup files owned by different host UIDs with modes such as `0600`; its reach is limited to the application data directory and the single `/source` mount visible inside the container. A Zerobyte administrator can therefore read and rewrite the entire mounted source, so mount only a dedicated directory that must be backed up.

Zerobyte does not currently provide fine-grained RBAC for backup operations. Organization members can operate repositories, sources, schedules, and restores, so membership must be limited to trusted operators.

## Image Security Note

The image snapshot pinned by the fixed v0.41.0 package has no Critical findings and seven High records. The rclone TIFF issues are confined to the optional Internxt backend; the gRPC findings are in optional GCS/Google Drive clients rather than an inbound server or xDS control plane; and the affected rclone, restic, and shoutrrr source revisions contain no `os.Root` call site. The `latest` package follows a moving tag; reassess these findings after it resolves to a new image.
