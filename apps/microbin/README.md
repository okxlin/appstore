# MicroBin

## 产品介绍

MicroBin 是使用 Rust 编写的轻量自托管分享服务，可发布文本、文件和短链接，并支持有效期、只读内容、二维码和管理界面。

## 主要功能

- 文本、文件和短链接分享
- 有效期、只读内容和二维码
- SQLite 持久化与管理界面

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问。默认只绑定 `127.0.0.1`，并关闭公开列表、遥测和更新检查。远程访问应通过 HTTPS 反向代理发布。管理员界面使用安装时配置的用户名和密码。

## 数据持久化

`APP_DATA_DIR` 保存 SQLite 数据库、文本记录和附件。卸载不会删除此目录，请定期独立备份。

## 安全与部署风险

- 官方镜像默认以 root 运行；本应用强制使用 `65534:65534`，并已验证文本、附件、重启和持久化流程。容器使用只读根文件系统、丢弃全部 Linux capabilities，并启用 `no-new-privileges`。
- 本次审计的官方镜像快照在双架构扫描中包含基础系统漏洞。MicroBin 二进制只动态链接 libc、libm 和 libgcc，不链接系统 OpenSSL，也不调用镜像中的 Perl、Archive::Tar、Storable、gzip、mount、libcap 或 ncurses 工具。32 位 OpenSSL Critical 不适用于支持的 amd64/arm64 架构。
- 这些结论只覆盖审计时的镜像快照、官方入口和默认配置，并不表示后续镜像中没有漏洞。移动 `latest` 标签解析到新镜像，或入口、运行用户发生变化后必须重新扫描。

## Introduction

MicroBin is a lightweight self-hosted sharing service written in Rust. It publishes text, files, and short URLs with expiration, read-only content, QR codes, and an administration interface.

## Features

- Text, file, and short URL sharing
- Expiration, read-only content, and QR codes
- SQLite persistence and an administration interface

## Usage Notes

- Access the service at `http://<server-ip>:<port>`. It binds to `127.0.0.1` by default and disables public listing, telemetry, and update checks. Use an HTTPS reverse proxy for remote access.
- `APP_DATA_DIR` stores the SQLite database, text records, and attachments. Uninstallation preserves this directory.
- The container is forced to UID/GID `65534:65534`, uses a read-only root filesystem, drops all Linux capabilities, and enables `no-new-privileges`.

## Security Note

Fresh scans of the audited official image snapshot contain base-system vulnerabilities. The MicroBin binary dynamically links only libc, libm, and libgcc; it neither links system OpenSSL nor invokes the image's Perl, Archive::Tar, Storable, gzip, mount, libcap, or ncurses tooling. The 32-bit-only OpenSSL Critical does not apply to the supported amd64/arm64 images. These are default-entrypoint reachability exceptions, not claims that later images are vulnerability-free. A new image resolved from the moving `latest` tag, or any entrypoint or runtime-user change, requires a fresh review.

## References

- Project: <https://github.com/szabodanika/microbin>
- Stable release: <https://github.com/szabodanika/microbin/releases/tag/v2.1.4>
- Official Compose: <https://github.com/szabodanika/microbin/blob/v2.1.4/compose.yaml>
- License: <https://github.com/szabodanika/microbin/blob/v2.1.4/LICENSE> (BSD-3-Clause)
