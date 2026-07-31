# Fusion

## 产品介绍

Fusion 是一款轻量级自托管 RSS/Atom 阅读器，支持未读状态、书签、搜索、订阅分组、OPML 导入导出和 Fever API 客户端。

## 主要功能

- RSS/Atom 订阅、自动发现和分组管理
- 未读状态、书签、搜索和键盘快捷键
- OPML 导入导出和 Fever API 客户端兼容

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，并使用安装表单生成或设置的密码登录。默认仅绑定 `127.0.0.1`；远程访问应通过 1Panel 的 HTTPS 反向代理发布。

## 数据持久化

`APP_DATA_DIR` 保存 SQLite 数据库。卸载不会删除此目录，请定期独立备份。

## 安全与部署风险

- 本应用默认禁止抓取私网和本机地址的订阅源。确需读取内网订阅时，应先评估 SSRF 与网络边界，不要直接修改默认模板。
- 官方镜像为兼容旧数据而暂时以 root 启动；本应用面向新安装强制使用镜像内的 `100:101` 用户，并使用只读根文件系统、丢弃全部 Linux capabilities、启用 `no-new-privileges`。登录、创建分组和重启持久性已在该约束下验证。
- 固定版和本次审计的 `latest` 镜像快照在 amd64/arm64 扫描中均包含基础系统及 Go 依赖漏洞。唯一 Critical ID `CVE-2026-31789` 只影响 32 位平台，不适用于本应用支持的 amd64/arm64。镜像中的 OpenSSL、zlib 和 iconv 不被静态链接的 Fusion 主程序调用；默认健康检查也只访问本机明文 HTTP。
- `x/net/html` 用于订阅解析和 URL 重写，最终文章内容仍由浏览器端 DOMPurify 白名单净化后才渲染。QUIC、SSH 和 JWE 漏洞路径不属于默认 HTTP/password 部署流程。这些是默认路径的可达性例外，不代表镜像没有漏洞；移动 `latest` 标签解析到新镜像、入口或配置发生变化后必须重新审计。

## Introduction

Fusion is a lightweight self-hosted RSS/Atom reader with unread tracking, bookmarks, search, feed groups, OPML import/export, and Fever API compatibility.

## Features

- RSS/Atom subscriptions, discovery, and group management
- Unread tracking, bookmarks, search, and keyboard shortcuts
- OPML import/export and Fever API client compatibility

## Usage Notes

- Access Fusion at `http://<server-ip>:<port>` and sign in with the password generated or set during installation. It binds to `127.0.0.1` by default; use an HTTPS reverse proxy for remote access.
- `APP_DATA_DIR` stores the SQLite database. Uninstallation preserves this directory.
- Private-network feed fetching is disabled by default. Enabling it changes the SSRF and network trust boundary and is outside this package's audited defaults.
- The container is forced to UID/GID `100:101`, uses a read-only root filesystem, drops all Linux capabilities, and enables `no-new-privileges`.

## Security Note

Fresh amd64 and arm64 scans of the fixed release and the audited `latest` image snapshot contain base-system and Go dependency findings. The only Critical ID, `CVE-2026-31789`, requires a 32-bit platform and does not apply to the supported architectures. Fusion is a static Go binary and does not call the image's OpenSSL, zlib, or iconv tooling in the default path. Feed HTML is ultimately sanitized with a DOMPurify allowlist before browser rendering; QUIC, SSH, and JWE vulnerable paths are not used by the default HTTP/password deployment. These are reachability exceptions for the audited snapshot, not claims that later images are vulnerability-free; reassess when the moving `latest` tag resolves to a new image.

## References

- Project: <https://github.com/0x2E/fusion>
- Stable release: <https://github.com/0x2E/fusion/releases/tag/v1.2.1>
- Dockerfile: <https://github.com/0x2E/fusion/blob/v1.2.1/Dockerfile>
- Configuration: <https://github.com/0x2E/fusion/blob/v1.2.1/.env.example>
- License: <https://github.com/0x2E/fusion/blob/v1.2.1/LICENSE> (MIT)
