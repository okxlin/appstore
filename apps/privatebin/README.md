# PrivateBin

## 产品介绍

PrivateBin 是零知识加密的临时文本分享服务。文本内容在浏览器中加密和解密，服务端只保存密文。

## 主要功能

- 浏览器端加密和解密的临时文本分享
- 文件系统持久化后端，保留服务器盐和限流状态
- 只读根文件系统与最小临时写入目录

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。生产环境应通过可信反向代理提供 HTTPS，并限制管理服务器的网络暴露范围。

## 数据持久化

`APP_DATA_DIR` 挂载到容器的 `/srv/data`，其中保存文本数据、服务器盐和限流状态。该路径必须位于应用版本目录内（默认 `./data`）；安装与升级脚本会拒绝绝对路径及目录外路径，避免误改宿主机文件权限。脚本会将该目录设置为官方镜像要求的 UID `65534`、GID `82`。升级、迁移或卸载前请备份该目录；卸载不会删除绑定目录中的用户数据。

## 安全说明

- 容器以只读根文件系统运行，仅允许写入 `/srv/data` 以及 `/tmp`、`/run`、`/var/lib/nginx/tmp` 三个临时目录。
- 上游镜像内部通过 s6 协调 Nginx 与 PHP-FPM；它仍是单个 Compose 服务，但不适合纳入自动升级或自动合并策略。
- 2026-07-27 的 Trivy 扫描在固定镜像中发现 `0` 个 Critical 和 `1` 个 High：`CVE-2026-42533`（Nginx 对特制 HTTP 请求的代码执行风险）。仅向可信用户开放，保持反向代理与镜像更新；上游修复镜像经验证后应尽快升级。

## Introduction

PrivateBin is a zero-knowledge encrypted paste service. Data is encrypted and decrypted in the browser, so the server stores ciphertext only.

## Features

- Browser-side encryption and decryption for shared pastes
- Filesystem persistence for the server salt and rate-limit state
- Read-only root filesystem with minimal temporary writable paths

## Usage Notes

- Access the service at `http://<server-ip>:<port>` after installation. Put a trusted TLS reverse proxy in front of it for production exposure.
- `APP_DATA_DIR` persists the filesystem backend, server salt, and rate-limit state. It must remain relative to the application version directory (default `./data`); absolute and outside paths are rejected to protect host file ownership. Back it up before upgrades or migrations.
- The container uses a read-only root filesystem with the upstream-required writable data and temporary paths only.
- The 2026-07-27 Trivy scan found 0 Critical and 1 High in the pinned image: `CVE-2026-42533` (Nginx code-execution risk for crafted HTTP requests). Expose it only to trusted users, retain a reverse proxy, and update promptly when an upstream-fixed image is verified.

## References

- Project: <https://github.com/PrivateBin/PrivateBin>
- Image deployment: <https://github.com/PrivateBin/docker-nginx-fpm-alpine#running-the-image>
- Website: <https://privatebin.info/>
- Logo: <https://github.com/PrivateBin/PrivateBin/blob/master/img/logo.svg> (official project asset; Zlib/libpng license)
