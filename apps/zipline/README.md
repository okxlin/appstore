# Zipline

## 产品介绍

Zipline 是自托管的文件分享和 URL 缩短平台，提供用户管理、文件上传、分享链接、缩略图及管理界面。

## 主要功能

- 文件上传、分享、缩略图和到期策略
- URL 缩短、访问统计和用户管理
- 本地数据源、自定义主题和管理界面

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问。默认只绑定 `127.0.0.1`；如需远程访问，建议通过 HTTPS 反向代理发布。首次打开时创建的第一个账户将成为管理员。

## 数据持久化

`APP_DATA_DIR` 中的 `postgres`、`uploads`、`public` 和 `themes` 分别保存数据库、上传文件、公开资源和自定义主题。卸载不会删除这些目录，请定期独立备份。

## 安全与部署风险

- Zipline 以 UID/GID `1000:1000` 运行，数据库以 `70:70` 运行；两者均丢弃全部 Linux capabilities、使用只读根文件系统并启用 `no-new-privileges`。PostgreSQL 仅接入内部网络，不发布宿主端口。
- 固定版本 `4.6.5` 使用的镜像快照在双架构扫描中仍包含上游漏洞。两份 Critical `CVE-2026-59873` 仅位于 npm/corepack 工具链，默认服务入口不调用这些工具。
- `@fastify/static 9.1.3` 受 `CVE-2026-15074` 影响，但该公告仅允许绕过受保护 URL 前缀并读取同一静态根中的文件，不能越出静态根。Zipline 的 `build/client` 根本来就是公开前端资源；临时目录以 `serve:false` 注册，用户导出通过固定文件名和认证中间件发送。该默认路径例外不代表漏洞不存在。
- 其余 High 位于构建工具、Prisma 迁移配置、静态 schema/路由依赖或需要 Zipline 默认监听器未启用的 HTTP/2/RSC 等功能。不要在容器内运行 npm/pnpm、载入不可信 Prisma 配置或改变官方入口；移动 `latest` 标签解析到新镜像后必须重新扫描。

## Introduction

Zipline is a self-hosted file sharing and URL shortening platform with user management, uploads, share links, thumbnails, and an administration interface.

## Features

- File uploads, sharing, thumbnails, and expiration policies
- URL shortening, access statistics, and user management
- Local storage, custom themes, and an administration interface

## Usage Notes

- Access the service at `http://<server-ip>:<port>`. It binds to `127.0.0.1` by default; publish it through an HTTPS reverse proxy for remote access. The first account created becomes the administrator.
- `APP_DATA_DIR` contains PostgreSQL data, uploads, public assets, and custom themes. Uninstallation preserves these directories.
- Zipline runs as UID/GID `1000:1000`; PostgreSQL runs as `70:70` on an internal-only network. Both containers drop all capabilities, use read-only root filesystems, and enable `no-new-privileges`.

## Security Note

The audited official image snapshot contains upstream vulnerabilities. Two Critical `CVE-2026-59873` findings are confined to npm/corepack tooling that the default service entrypoint does not invoke. `CVE-2026-15074` in `@fastify/static 9.1.3` bypasses route-scoped guards but cannot escape a configured static root; Zipline exposes `build/client` as intentionally public, registers its temporary root with `serve:false`, and sends authenticated exports by a fixed server-selected filename. Other High findings are confined to build tooling, Prisma migration configuration, static schema/router dependencies, or features such as HTTP/2 and RSC that the default service does not enable. These are default-path reachability exceptions, not claims that the packages are absent from later images. A new image resolved from the moving `latest` tag, running package managers in the container, loading untrusted Prisma configuration, or replacing the official entrypoint invalidates them.

## References

- Project: <https://github.com/diced/zipline>
- Docker guide: <https://zipline.diced.sh/docs/get-started/docker>
- Official Compose: <https://github.com/diced/zipline/blob/v4.6.5/docker-compose.yml>
- License: <https://github.com/diced/zipline/blob/v4.6.5/LICENSE> (MIT)
- Static advisory: <https://github.com/fastify/fastify-static/security/advisories/GHSA-83w8-p2f5-377r>
