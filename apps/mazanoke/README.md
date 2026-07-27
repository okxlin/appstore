# Mazanoke

## 产品介绍

Mazanoke 是可离线使用的图片优化工具。图片解码、压缩和格式转换全部在浏览器本地完成，不会上传到 Mazanoke 容器。

## 主要功能

- 调整图片质量、目标大小和最大宽高
- 支持 JPG、PNG、WebP、ICO、HEIC、AVIF、TIFF、GIF 和 SVG
- 移除 EXIF 元数据并支持剪贴板粘贴
- 可安装为渐进式 Web 应用并离线运行

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。适配默认强制启用上游 Basic Auth；使用安装时配置的 `MAZANOKE_USERNAME` 和随机生成或手动设置的强密码登录。生产环境还应使用 HTTPS，避免 Basic Auth 凭据以明文 HTTP 传输。

Mazanoke 不在服务器端保存或处理图片。浏览器加载应用后，所选文件只进入当前浏览器的内存和本地处理流程。

## 安全与漏洞警告

- 固定镜像的扫描结果为 `0 Critical / 18 High`，涉及 `apache2-utils`、c-ares、curl/libcurl、OpenSSL、Expat、libxml2 和 nghttp2。Apache 模块漏洞不在该 Nginx 静态站点中加载，默认配置未启用 HTTP/2，且图片不会到达容器；因此多数报告路径在默认部署中不可达。Nginx 仍是网络可访问服务，应限制访问范围，并在上游发布更新镜像后尽快升级。
- 图片在浏览器中解析和转换，不会上传到容器，但恶意或畸形文件仍可能攻击浏览器及其媒体解码器。只处理可信来源的图片，在隔离的浏览器会话中检查来源不明的文件，并及时更新浏览器。
- Basic Auth 由容器启动脚本写入 Nginx 配置。容器丢弃全部 capabilities 后仅恢复 `CHOWN`、`SETUID`、`SETGID` 和 `NET_BIND_SERVICE`，并启用 `no-new-privileges`。
- 不要使用不受信任来源提供的共享密码。更换凭据后重启应用，并确保旧凭据未留在自动化日志或备份中。

## Introduction

Mazanoke is an offline-capable image optimizer. Image decoding, compression, and format conversion happen locally in the browser and files are never uploaded to the Mazanoke container.

## Features

- Image quality, target size, and maximum-dimension controls
- JPG, PNG, WebP, ICO, HEIC, AVIF, TIFF, GIF, and SVG support
- EXIF removal and clipboard paste support
- Installable progressive web app with offline operation

## Usage Notes

- Access the service at `http://<server-ip>:<port>`. This adaptation requires upstream Basic Auth. Sign in with the configured `MAZANOKE_USERNAME` and generated or user-supplied strong password.
- Use HTTPS in production so Basic Auth credentials are not transmitted over plaintext HTTP.
- Selected images remain in the browser's memory and local processing flow; the server only delivers static application files.

## Security and Vulnerability Warning

- The pinned image scans as `0 Critical / 18 High` across `apache2-utils`, c-ares, curl/libcurl, OpenSSL, Expat, libxml2, and nghttp2. Apache module findings are not loaded by this Nginx static site, HTTP/2 is not enabled in the default configuration, and images never reach the container, so most reported paths are unreachable by default. Nginx remains network-facing; restrict exposure and upgrade promptly when upstream publishes a refreshed image.
- Images are parsed and converted in the browser rather than uploaded to the container, but malicious or malformed files may still target the browser and its media decoders. Process trusted images only, inspect unknown files in an isolated browser session, and keep the browser current.
- The container drops all capabilities and restores only `CHOWN`, `SETUID`, `SETGID`, and `NET_BIND_SERVICE`, with `no-new-privileges` enabled.

## References

- Project: <https://github.com/civilblur/mazanoke>
- Docker deployment: <https://github.com/civilblur/mazanoke#docker>
- Configuration: <https://github.com/civilblur/mazanoke/blob/main/docs/configuration.md>
- License: <https://github.com/civilblur/mazanoke/blob/main/LICENSE> (GPL-3.0)
