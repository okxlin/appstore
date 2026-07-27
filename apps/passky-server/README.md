# Passky Server

## 产品介绍

Passky Server 是 Passky 密码管理器的自托管后端。客户端在本地使用 XChaCha20 加密保险库内容，并以 Argon2id 派生的凭据访问服务器；服务器保存加密后的密码条目和账户元数据。

## 主要功能

- 为 Passky 网页端、浏览器扩展、桌面端和移动端提供同步 API
- 使用 SQLite 保存账户、加密密码条目和许可证数据
- 提供账户数量、存储额度、健康状态和许可证管理后台
- 支持 2FA、YubiKey、API 请求限速及可选外部服务

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>/website/` 打开管理后台，使用安装时设置的管理员用户名和随机密码登录。根路径是 Passky 客户端使用的 API 地址；普通 Passky 账户与管理后台账户彼此独立。

镜像只提供明文 HTTP。密码管理服务不应通过明文公网连接使用：生产环境必须由可信反向代理终止 HTTPS，并阻止公网直接访问应用端口。内置 Cloudflare Turnstile 使用上游测试密钥，不构成真实验证码保护；公网反向代理还应对管理后台登录增加限速和访问控制。

## 数据持久化

`APP_DATA_DIR` 挂载到容器的 `/var/www/html/databases`，保存 SQLite 数据库。该路径必须位于应用版本目录内，默认为 `./data`；初始化脚本拒绝绝对路径和目录逃逸。升级、迁移或卸载前请备份该目录，卸载不会删除绑定目录中的用户数据。

管理员密码由 1Panel 随机生成并保存在应用 `.env` 中，再以明文环境变量传给上游应用；能够读取 1Panel 应用配置或 Docker 容器环境的人也能读取该密码。不要复用其他系统密码，并限制 1Panel 和 Docker 管理权限。

## 安全与漏洞警告

- 2026-07-28 对固定镜像的 Trivy 扫描结果为 `0 Critical / 17 High`，对应 7 个不同漏洞。镜像版本 8.1.8 发布于 2024-11-05，上游仓库最后活动时间为 2025-11-30；修复镜像发布后应先重新验证，再尽快升级。
- `CVE-2026-42945` 在 Nginx 1.18.0 中可能由未认证请求触发堆溢出和代码执行，但它要求特定的 `rewrite`/`if`/`set` 连续配置、未命名 PCRE 捕获以及包含问号的替换串。固定镜像的实际配置只有 FastCGI 的独立 `set $path_info`，未出现该危险组合，因此默认请求路径未达到漏洞前置条件。
- `CVE-2025-49844` 和 `CVE-2024-31449` 是 Redis Lua 脚本执行路径中的代码执行风险。上游镜像原本让 Redis 无密码监听所有容器接口；本包在固定镜像启动时校验并修改其 s6 脚本，使 Redis 只监听 `127.0.0.1`/`::1`，同时禁用 Passky 不使用的 `EVAL` 和 `EVALSHA`。健康测试会验证这些约束；不要删除入口脚本或将 6379 暴露到共享网络。
- `CVE-2023-4911` 是需要本地执行条件和 SUID 程序的 glibc 提权。Nginx 与 PHP-FPM 工作进程以 UID/GID `1000:1000` 运行且有效 capabilities 为零，但 s6、Nginx/PHP-FPM 主进程、Redis 和 cron 仍由 root 监督。本包丢弃默认能力集，只恢复启动所需的 `CHOWN`、`DAC_OVERRIDE`、`SETUID`、`SETGID` 和 `NET_BIND_SERVICE`；该上游镜像启用 `no-new-privileges` 时 Nginx 无法启动，因此不能声明该保护。
- `CVE-2025-68973` 位于 GnuPG 装甲输入解析，默认运行路径不调用 GnuPG；`CVE-2025-9900` 位于 TIFF 解码，而 Passky API 不接收或解析图像；`CVE-2026-45447` 位于 OpenSSL `PKCS7_verify()`，应用未发现 PKCS#7 或 S/MIME 验证入口。这些组件仍应随官方镜像更新。
- API 请求限速保持启用。仅向可信用户和客户端开放，使用 HTTPS，定期备份，并关注官方镜像更新。

## Introduction

Passky Server is the self-hosted backend for the Passky password manager. Clients encrypt vault content locally with XChaCha20 and use Argon2id-derived credentials; the server stores encrypted password entries and account metadata.

## Features

- Sync API for Passky web, browser, desktop, and mobile clients
- SQLite persistence for accounts, encrypted entries, and license records
- Administration pages for accounts, storage limits, health, and licenses
- 2FA, YubiKey, API rate limiting, and optional external integrations

## Access And Persistence

Open `http://<server-ip>:<port>/website/` and sign in with the administrator username and random password selected during installation. The root URL is the API endpoint used by Passky clients. Passky vault accounts and the administration account are separate.

The image serves plain HTTP only. A password manager must not be used over an unencrypted public connection. Terminate HTTPS at a trusted reverse proxy and block public access to the direct application port. The bundled Cloudflare Turnstile values are upstream test keys and provide no real CAPTCHA protection; add login rate limiting and access controls at the proxy.

`APP_DATA_DIR` persists SQLite databases at `/var/www/html/databases`. It must remain within the application version directory and defaults to `./data`; absolute and escaping paths are rejected. Back it up before upgrades or migration. Uninstall does not delete the bind-mounted data.

1Panel stores the generated administrator password in the app `.env` and passes it to the upstream application as a plaintext environment variable. Anyone with 1Panel configuration or Docker inspection access can read it. Do not reuse the password, and restrict access to both control planes.

## Security And Vulnerability Warning

- A fresh Trivy scan of the pinned image on 2026-07-28 reports `0 Critical / 17 High`, covering seven distinct vulnerabilities. Version 8.1.8 was released on 2024-11-05, and the repository was last active on 2025-11-30. Revalidate and upgrade promptly when a fixed official image is published.
- `CVE-2026-42945` can cause an unauthenticated Nginx heap overflow and code execution only with a specific consecutive `rewrite`/`if`/`set` configuration, an unnamed PCRE capture, and a replacement containing a question mark. The pinned image has only a standalone FastCGI `set $path_info`; the required configuration is absent from the effective Nginx configuration.
- `CVE-2025-49844` and `CVE-2024-31449` affect Redis Lua script execution. The upstream image starts unauthenticated Redis on every container interface. This package validates and patches the pinned s6 startup line so Redis binds only to `127.0.0.1`/`::1`, then disables the unused `EVAL` and `EVALSHA` commands. Runtime tests verify both controls. Do not remove the entrypoint or expose port 6379.
- `CVE-2023-4911` is a glibc local privilege-escalation issue requiring local execution and an SUID program. Nginx and PHP-FPM workers run as UID/GID `1000:1000` with no effective capabilities, but s6, master processes, Redis, and cron remain root-supervised. Default capabilities are dropped; only `CHOWN`, `DAC_OVERRIDE`, `SETUID`, `SETGID`, and `NET_BIND_SERVICE` remain. Nginx does not start when `no-new-privileges` is enabled on this upstream image, so that control is not claimed.
- `CVE-2025-68973` is in GnuPG armored-input processing, which the running app does not invoke. `CVE-2025-9900` affects TIFF decoding, while the API has no image upload or decoding path. `CVE-2026-45447` affects OpenSSL `PKCS7_verify()`; no PKCS#7 or S/MIME verification path was found. These dormant components still require an upstream image refresh.
- API rate limiting remains enabled. Restrict the service to trusted users and clients, enforce HTTPS, keep backups, and follow upstream image updates.

## References

- Project and license: <https://github.com/Rabbit-Company/Passky-Server/tree/v8.1.8>
- Official Docker installation: <https://github.com/Rabbit-Company/Passky-Server/blob/v8.1.8/docs/installation/docker.md>
- Release: <https://github.com/Rabbit-Company/Passky-Server/releases/tag/v8.1.8>
- Nginx advisory: <https://www.cve.org/CVERecord?id=CVE-2026-42945>
- Redis advisories: <https://github.com/redis/redis/security/advisories/GHSA-4789-qfc9-5f9q>, <https://github.com/redis/redis/security/advisories/GHSA-whxg-wx83-85p5>
- GnuPG advisory: <https://www.cve.org/CVERecord?id=CVE-2025-68973>
- glibc advisory: <https://www.cve.org/CVERecord?id=CVE-2023-4911>
- OpenSSL advisory: <https://openssl-library.org/news/secadv/20260609.txt>
- libtiff advisory: <https://www.cve.org/CVERecord?id=CVE-2025-9900>
