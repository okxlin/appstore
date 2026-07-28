# HermitStash

## 产品介绍

HermitStash 是自托管的加密文件分享服务，使用 ML-KEM-1024 与 P-384 混合密钥协商，并避免在持久化存储中保留明文数据库。

## 主要功能

- 加密文件上传、分享和访问控制
- 本地账户、通行密钥与管理界面
- 加密数据库、密钥及上传文件的持久化存储

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。默认启用本地认证，同时关闭公开注册和匿名上传。

首次启动会为 `admin@hermitstash.com` 生成随机管理员密码。该密码会打印到容器日志，并写入 `APP_DATA_DIR/initial-admin-password.txt`。在仅受信任人员可读取 1Panel 日志和数据目录的环境中获取密码并立即登录，然后完成设置向导、更换管理员邮箱和密码，并配置站点及会话设置。向导完成后，上游会自动删除明文密码文件。在首次设置完成前不要向公网开放端口。

## 数据持久化

`APP_DATA_DIR` 保存加密数据库、保险库密钥和 TLS 资料，`APP_UPLOADS_DIR` 保存上传内容。两个路径必须位于应用版本目录内；初始化脚本会拒绝绝对路径和目录外路径，并设置为容器要求的 UID/GID `1000:1000`。卸载不会删除这些目录。务必单独备份 `APP_DATA_DIR/vault.key`；该文件丢失会导致已加密数据无法恢复。

## 安全与部署风险

- 容器采用上游官方 rootless 模式，固定以 UID/GID `1000:1000` 运行，丢弃全部 Linux capabilities，并启用只读根文件系统和 `no-new-privileges`。初始化脚本会在启动前准备绑定目录权限。
- 首次管理员密码在完成设置前同时存在于容器日志和数据目录中。能读取任一位置的人员可接管初始管理员账户，因此必须限制日志、备份和宿主机目录权限，并尽快完成首次设置。
- 数据库明文工作副本位于 256 MiB 的 `/dev/shm`。不要移除共享内存配置或将 `HERMITSTASH_TMPDIR` 改为磁盘路径。
- 固定镜像的 Trivy 扫描未发现 Critical 或 High 漏洞；镜像升级前仍应重新扫描。

## Introduction

HermitStash is a self-hosted encrypted file sharing service using hybrid ML-KEM-1024 and P-384 key agreement while keeping its plaintext database off persistent storage.

## Features

- Encrypted file uploads, sharing, and access controls
- Local accounts, passkeys, and an administration interface
- Persistent encrypted database, keys, and uploaded files

## Usage Notes

- Access the service at `http://<server-ip>:<port>`. Local authentication is enabled while open registration and anonymous uploads are disabled by default.
- On first boot, retrieve the generated password for `admin@hermitstash.com` from the container logs or `APP_DATA_DIR/initial-admin-password.txt`. Sign in from a trusted network and complete the setup wizard immediately. Upstream removes the plaintext password file after setup. Do not expose the port publicly before this is complete.
- `APP_DATA_DIR` and `APP_UPLOADS_DIR` must remain relative to the application version directory. Back up `APP_DATA_DIR/vault.key`; encrypted data cannot be recovered without it.

## Security and Deployment Risks

- The container uses upstream's official rootless mode, runs as UID/GID `1000:1000`, drops all Linux capabilities, and enables a read-only root filesystem plus `no-new-privileges`. The initialization script prepares bind-mount ownership before startup.
- Until setup completes, the generated administrator password is present in both container logs and the data directory. Restrict access to logs, backups, and host paths and finish setup promptly.
- The plaintext working database requires the configured 256 MiB `/dev/shm`; do not move `HERMITSTASH_TMPDIR` to persistent storage.

## References

- Project: <https://github.com/dotCooCoo/hermitstash>
- Rootless Docker deployment: <https://github.com/dotCooCoo/hermitstash/blob/main/docker-compose.rootless.yml>
- Threat model: <https://github.com/dotCooCoo/hermitstash/blob/main/docs/THREAT_MODEL.md>
- License: <https://github.com/dotCooCoo/hermitstash/blob/main/LICENSE> (AGPL-3.0-or-later)
