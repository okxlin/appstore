# LeafWiki

## 产品介绍

LeafWiki 是一个轻量级自托管 Wiki，以目录和文件夹结构组织 Markdown 页面，提供全文搜索、标签、页面历史、备份和多用户权限管理。

## 主要功能

- 以目录树组织 Markdown 页面
- 全文搜索、标签和页面链接
- 管理员、编辑者和只读用户角色
- TOTP 双因素认证、快照和 Git 备份

## 访问说明

安装后先在 1Panel 中为应用配置可信 HTTPS 反向代理，再通过 `https://<配置的域名>` 访问，并使用安装时设置的初始管理员用户名和密码登录。初始管理员参数只在首次创建用户数据库时生效；之后请在 LeafWiki 中管理账号和密码。

默认关闭“允许明文 HTTP 登录（不安全）”，保持上游安全默认。应用的明文端口可用于健康检查，但登录必须通过可信 HTTPS 反向代理，并正确传递 `X-Forwarded-Proto: https`。只有在端口严格限制于可信局域网且无法配置 HTTPS 时，才可显式把该选项改为 `true`；此时认证 Cookie 会通过未加密网络传输，绝不能把服务暴露到公网。

## 数据持久化

`APP_DATA_DIR` 挂载到 `/app/data`，保存 Markdown 页面、SQLite 用户数据库、资源、索引、快照和配置。该路径必须位于应用版本目录内，默认值为 `./data`；初始化脚本会拒绝绝对路径和目录外路径，并将其设置给官方非 root 用户 UID/GID `1000:1000`。脚本还会在该目录中首次生成并持久保存两枚 256-bit JWT/TOTP 密钥，不会在升级或重启时重新生成。卸载不会删除绑定目录中的用户数据，升级或迁移前请单独备份。

## 安全与部署风险

- 认证和刷新令牌限流保持启用；包内没有启用公开读取、无认证模式、API 密钥管理或 Git 备份。容器以 UID/GID `1000:1000` 运行，根文件系统只读，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。
- 对固定镜像执行的 2026-07-28 Trivy 扫描发现 `0` 个 Critical 和 `1` 个 High：`CVE-2026-39822`（Go `os.Root` 符号链接目录逃逸）。镜像使用 Go 1.26.4，修复版本为 1.26.5；源码级 Go 漏洞扫描未找到 LeafWiki 调用受影响 `os.Root` API 的路径，但仍应在上游发布修复镜像后尽快更新。
- 同一次源码级 Go 漏洞扫描发现 `GO-2026-5856`（`CVE-2026-42505`，ECH 客户端握手隐私泄露）存在通用 TLS 调用链。该问题只在 LeafWiki 作为客户端使用 Encrypted Client Hello 时生效；默认关闭的 Git 备份和普通入站 HTTP 服务不启用 ECH。扫描还在依赖元数据或二进制符号中报告 `GO-2026-5970`、`GO-2026-5942` 和 `GO-2026-5932`，但未发现 LeafWiki 调用其受影响符号。

## Introduction

LeafWiki is a lightweight self-hosted wiki that organizes Markdown pages in a folder tree and provides full-text search, tags, page history, backups, and multi-user access control.

## Features

- Folder-oriented Markdown page tree
- Full-text search, tags, and page links
- Administrator, editor, and viewer roles
- TOTP two-factor authentication, snapshots, and Git backups

## Usage Notes

Configure a trusted HTTPS reverse proxy for the app in 1Panel, then access it at `https://<configured-domain>` and sign in with the initial administrator credentials selected during installation. Initial administrator settings apply only when the user database is first created; manage later account changes inside LeafWiki.

The package keeps **Allow Plain HTTP Login (Insecure)** disabled by default, matching the upstream secure default. The plain application port remains available for health checks, but login requires a trusted HTTPS reverse proxy that forwards `X-Forwarded-Proto: https`. Enable the insecure option explicitly only when the port is strictly limited to a trusted LAN and HTTPS cannot be configured; authentication cookies then cross the network unencrypted, so never expose that mode to the public Internet.

`APP_DATA_DIR` is mounted at `/app/data` and stores Markdown pages, the SQLite user database, assets, indexes, snapshots, and configuration. It must remain relative to the application version directory and is prepared for UID/GID `1000:1000`. On first install, the initialization script also generates and persists separate 256-bit JWT and TOTP keys in this directory; upgrades and restarts do not regenerate them. Uninstall does not delete bind-mounted user data; back it up before upgrades or migration.

## Security and Deployment Risks

- Authentication and refresh-token rate limiting remain enabled. Public access, authentication bypass, API-key management, and Git backup are not enabled by this package. The container runs as UID/GID `1000:1000`, uses a read-only root filesystem, drops all Linux capabilities, and enables `no-new-privileges`.
- A 2026-07-28 Trivy scan of the pinned image found 0 Critical and 1 High finding: `CVE-2026-39822`, a symlink root escape in Go `os.Root`. The image was built with Go 1.26.4 and the fix is in 1.26.5. Source-mode Go vulnerability analysis found no LeafWiki call path to the affected `os.Root` APIs, but update promptly when upstream publishes a fixed image.
- The same source-mode Go scan found a generic TLS call path for `GO-2026-5856` (`CVE-2026-42505`), an ECH client-handshake privacy leak. It applies only when LeafWiki acts as a client using Encrypted Client Hello; the default-disabled Git backup and ordinary inbound HTTP service do not enable ECH. The scan also reported `GO-2026-5970`, `GO-2026-5942`, and `GO-2026-5932` in dependency metadata or binary symbols without finding calls from LeafWiki to their affected symbols.

## References

- Project: <https://github.com/perber/leafwiki>
- Release: <https://github.com/perber/leafwiki/releases/tag/v0.12.0>
- Container source: <https://github.com/perber/leafwiki/blob/v0.12.0/Dockerfile>
- Configuration: <https://github.com/perber/leafwiki/blob/v0.12.0/.env.example>
- License: <https://github.com/perber/leafwiki/blob/v0.12.0/LICENSE> (MIT)
- Logo source: <https://github.com/lucide-icons/lucide/blob/0.468.0/icons/leaf.svg> (ISC)
