# Wizarr

## 产品介绍

Wizarr 是 Plex、Jellyfin、Emby、Audiobookshelf、Romm、Komga 和 Kavita 的邀请与用户管理系统。管理员可以生成邀请链接，并为新用户提供分步骤的媒体应用配置引导。

## 主要功能

- 管理多个媒体服务器及其用户和媒体库权限
- 创建限时、限次或分级邀请
- 配置邀请前后引导步骤和应用下载说明
- 集成 Overseerr、Ombi、Discord、LDAP、OIDC 和 WebAuthn
- 提供活动记录、通知和 REST API

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。

首次访问会进入 `/setup/` 创建管理员。内置认证被强制保留，管理员密码至少 8 位并须包含大写字母、小写字母和数字。首次管理员创建前，任何能够访问该端口的人都可能抢先注册管理员；安装后应立即完成设置，并在此之前只允许可信管理网络访问。生产环境应使用带 HTTPS 和访问限制的反向代理。

## 数据持久化

`APP_DATA_DIR` 挂载到容器的 `/data/database`，保存 SQLite 数据库、会话和应用密钥。该路径必须位于应用版本目录内，默认 `./data`；安装脚本会拒绝绝对路径和目录逃逸。升级、迁移或卸载前请备份此目录，卸载不会删除绑定目录中的数据。

## 安全与漏洞警告

- 2026-07-28 对固定镜像的 Trivy 扫描结果为 `0 Critical / 10 High`，对应 8 个不同漏洞：pyasn1 `CVE-2026-59885`、`CVE-2026-59886`；Mako `CVE-2026-41205`、`CVE-2026-44307`；c-ares `CVE-2026-33630`；curl/libcurl `CVE-2026-5773`、`CVE-2026-6276`（各由两个包重复报告）；PostCSS `GHSA-r28c-9q8g-f849`。
- 默认网络服务不使用 Mako 生成模板，PostCSS 只用于上游镜像构建，curl/c-ares 只由固定的 `localhost` 健康检查使用；这些路径不接收用户文件、URL、Host、Cookie 或源映射。pyasn1 风险位于可选 LDAP 集成的 ASN.1 解析路径，默认未配置 LDAP，但恶意或失陷的 LDAP 端点可能触发拒绝服务。
- 所有漏洞均已有上游修复版本。应只连接可信媒体、LDAP 和通知服务，限制管理端访问，并在 Wizarr 发布经过验证的更新镜像后尽快升级。
- 容器入口仅为创建指定 UID/GID 和修正数据库目录属主而短暂使用 root；实际应用进程以 UID/GID `1000:1000` 运行。容器丢弃全部 capabilities，仅恢复入口所需的 `CHOWN`、`SETUID`、`SETGID` 和 `DAC_OVERRIDE`；最后一项用于重启时穿越已由 UID 1000 持有的 `0750` 数据目录。容器启用 `no-new-privileges`。

## Introduction

Wizarr is an invitation and user management system for Plex, Jellyfin, Emby, Audiobookshelf, Romm, Komga, and Kavita. Administrators can create invitation links and guide new users through media application setup.

## Features

- Manage users and library permissions across multiple media servers
- Create expiring, limited-use, and tiered invitations
- Configure pre-invite and post-invite onboarding steps
- Integrate with Overseerr, Ombi, Discord, LDAP, OIDC, and WebAuthn
- Activity records, notifications, and a REST API

## Usage Notes

- Access the service at `http://<server-ip>:<port>`. Built-in authentication is forced on.
- The first visit opens `/setup/` to create an administrator. Until that account exists, anyone who can reach the port could claim the first administrator. Complete setup immediately on a trusted management network, then use an access-controlled HTTPS reverse proxy for production.
- The administrator password must contain uppercase, lowercase, and numeric characters and be at least eight characters long. Login attempts are limited by the application.
- `APP_DATA_DIR` persists the SQLite database, sessions, and application keys at `/data/database`. It must remain inside the application version directory. Back it up before upgrades or migrations; uninstall does not delete it.

## Security And Vulnerability Warning

- A 2026-07-28 Trivy scan of the pinned image reports `0 Critical / 10 High`, covering eight distinct findings: pyasn1 `CVE-2026-59885` and `CVE-2026-59886`; Mako `CVE-2026-41205` and `CVE-2026-44307`; c-ares `CVE-2026-33630`; curl/libcurl `CVE-2026-5773` and `CVE-2026-6276`, each reported for both packages; and PostCSS `GHSA-r28c-9q8g-f849`.
- The default network service does not render Mako templates, PostCSS is build-time only, and curl/c-ares are used only by the fixed localhost health check. Those paths receive no user file, URL, Host, Cookie, or source-map input. The pyasn1 findings apply to the optional LDAP integration; LDAP is disabled by default, but a malicious or compromised LDAP endpoint could cause denial of service.
- Fixed upstream versions exist for every finding. Connect only trusted media, LDAP, and notification services, restrict management access, and upgrade promptly when Wizarr publishes a verified refreshed image.
- The entrypoint uses root briefly to create the configured UID/GID and fix database ownership. The application processes then run as UID/GID `1000:1000`. All capabilities are dropped except `CHOWN`, `SETUID`, `SETGID`, and `DAC_OVERRIDE`; the last capability lets the entrypoint traverse the UID-1000-owned `0750` data directory on restart. `no-new-privileges` is enabled.

## References

- Project: <https://github.com/wizarrrr/wizarr>
- Installation: <https://docs.wizarr.dev/getting-started/installation>
- Reverse proxy: <https://docs.wizarr.dev/getting-started/reverse-proxy>
- Release: <https://github.com/wizarrrr/wizarr/releases/tag/v2026.7.1>
- License: <https://github.com/wizarrrr/wizarr/blob/v2026.7.1/LICENSE.md> (MIT)
- Logo: <https://github.com/wizarrrr/wizarr/blob/v2026.7.1/app/static/wizarr-logo.png> (official project asset from the MIT-licensed source tree)
