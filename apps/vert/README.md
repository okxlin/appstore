# VERT

## 产品介绍

VERT 是在浏览器中运行的文件转换工具。图片、音频和文档由浏览器中的 WebAssembly 本地处理；视频转换默认使用 VERT 官方远程 `vertd` 服务。

## 主要功能

- 转换常见图片、音频、文档和视频格式
- 图片、音频和文档无需上传到 VERT 容器
- 支持批量转换、压缩包输入和浏览器端下载
- 可在设置中选择欧盟、美国或自定义 `vertd` 视频转换实例

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。该应用没有内置身份验证；仅向可信网络开放，公网使用时应配置带访问控制的 HTTPS 反向代理。

固定镜像在构建时启用了外部请求，Compose 运行时环境变量不能改变这一点：

- 图片、音频和文档文件在浏览器本地处理，不会上传到 VERT 容器。
- 视频文件默认上传到 `https://eu.vertd.vert.sh` 或 `https://usa.vertd.vert.sh`。应用会先请求公网 IP 地理位置服务来选择较近的实例。
- 上传敏感视频前，应在 VERT 设置中选择自己控制的 `vertd` 实例并验证其连接，或不要使用视频转换功能。自托管此 Web 前端本身并不使视频转换变成本地处理。
- 页面启动会访问 `ipapi.co` 和官方 `vertd`，并从 `cdn.jsdelivr.net` 下载 FFmpeg JavaScript/WASM；还可能访问 VERT 的版本、赞助和统计相关端点。即使文件转换本身在浏览器内执行，也不要把此构建视为完全离线应用。

## 安全与漏洞警告

- 2026-07-28 对固定镜像的 Trivy 扫描结果为 `0 Critical / 8 High`。8 条报告对应 6 个不同 CVE：c-ares `CVE-2026-33630`，curl/libcurl `CVE-2026-5773` 与 `CVE-2026-6276`（每项分别由 `curl` 和 `libcurl` 包报告），以及 Expat `CVE-2026-56131`、`CVE-2026-56407`、`CVE-2026-56408`。
- 对外提供静态文件的 Nginx 不链接 c-ares、libcurl 或 Expat，默认配置也没有加载依赖这些库的动态模块。镜像中的 curl 只由固定的容器健康检查访问 `http://localhost`，不接收用户 URL、SMB 地址、自定义 Host 或 Cookie，因此上述 c-ares、curl/libcurl 和 Expat 漏洞在默认服务路径中不可达。
- 这些漏洞已有 Alpine 修复版本：c-ares `1.34.8-r0`、curl/libcurl `8.20.0-r0`、Expat `2.8.2-r0`。仍应限制访问范围，并在上游发布包含修复包的新镜像后尽快升级。
- 容器以 UID/GID `101:101`、只读根文件系统运行，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。只有 Nginx 运行所需的 `/run`、`/var/cache/nginx` 和 `/tmp` 使用临时内存文件系统。

## Introduction

VERT is a browser-based file converter. Images, audio, and documents are processed locally with browser WebAssembly; video conversion uses VERT's remote `vertd` service by default.

## Features

- Convert common image, audio, document, and video formats
- Keep image, audio, and document files out of the VERT container
- Batch conversion, archive input, and browser-side downloads
- Select an EU, US, or custom `vertd` video conversion instance

## Usage And Privacy Notes

- Access the service at `http://<server-ip>:<port>`. VERT has no built-in authentication, so expose it only to trusted networks or place it behind an access-controlled HTTPS reverse proxy.
- External requests are enabled at image build time and cannot be disabled with runtime Compose environment variables.
- Images, audio, and documents are processed in the browser. Videos are uploaded by default to `https://eu.vertd.vert.sh` or `https://usa.vertd.vert.sh` after a public-IP geolocation request selects an instance.
- Before converting sensitive videos, select and verify a `vertd` instance you control in VERT settings, or do not use video conversion. Self-hosting this Web frontend alone does not make video processing local.
- On startup the browser contacts `ipapi.co` and the official `vertd`, and downloads FFmpeg JavaScript/WASM from `cdn.jsdelivr.net`. It may also contact VERT version, sponsorship, and analytics-related endpoints. This image is not a fully offline build even when the selected file is converted in the browser.

## Security And Vulnerability Warning

- A 2026-07-28 Trivy scan of the pinned image reports `0 Critical / 8 High`. The eight records cover six distinct CVEs: c-ares `CVE-2026-33630`; curl/libcurl `CVE-2026-5773` and `CVE-2026-6276`, each reported against both packages; and Expat `CVE-2026-56131`, `CVE-2026-56407`, and `CVE-2026-56408`.
- The network-facing Nginx binary is not linked to c-ares, libcurl, or Expat, and the default configuration loads no dynamic module that depends on them. The bundled curl binary is used only by the fixed `http://localhost` container health check and receives no user-controlled URL, SMB target, custom Host, or Cookie. These findings are therefore unreachable through the default service path.
- Fixed Alpine packages exist: c-ares `1.34.8-r0`, curl/libcurl `8.20.0-r0`, and Expat `2.8.2-r0`. Restrict exposure and upgrade promptly when upstream publishes a refreshed image.
- The container runs as UID/GID `101:101` with a read-only root filesystem, all Linux capabilities dropped, and `no-new-privileges` enabled. Only `/run`, `/var/cache/nginx`, and `/tmp` are writable tmpfs paths.

## References

- Project: <https://github.com/VERT-sh/VERT>
- Video conversion: <https://github.com/VERT-sh/VERT/blob/main/docs/VIDEO_CONVERSION.md>
- Self-hosted video service: <https://github.com/VERT-sh/vertd>
- License: <https://github.com/VERT-sh/VERT/blob/main/LICENSE> (AGPL-3.0)
- Logo: <https://github.com/VERT-sh/VERT/blob/e1c83ba4adf067c2ff60fa192e0cb029715d596a/static/lettermark_maskable.png> (official project asset from the AGPL-3.0 source tree)
