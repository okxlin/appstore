# Moodist

## 产品介绍

Moodist 是一个免费、开源的环境声音混音器，可在浏览器中组合自然、雨声、城市、场所、交通和噪声等声音，帮助专注、放松或入睡。

## 主要功能

- 同时叠加多种环境声音并分别调节音量
- 保存、重命名和重新应用自定义声音预设
- 提供睡眠计时器、番茄钟、倒计时和呼吸练习
- 支持通过链接分享声音组合
- 可安装为渐进式 Web 应用

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。

声音选择、音量、预设和其他个人设置保存在当前浏览器本地，不会写入服务器端目录。清除浏览器站点数据或更换浏览器后，这些设置不会自动迁移；卸载应用不会清除浏览器中已经保存的数据。

该应用没有内置身份验证。如需从公网访问，请通过 HTTPS 反向代理限制访问范围。部分浏览器只允许渐进式 Web 应用、媒体会话等能力在安全上下文中完整工作。

## 安全与漏洞说明

- 当前打包镜像的 Trivy 扫描结果为 `0 Critical / 9 High`。报告涉及 Caddy 基础镜像中的 c-ares、curl/libcurl，以及 Go 标准库和 gRPC。
- 上游 Caddy 配置只在容器端口上提供 `/var/www/html` 中的静态文件，没有配置 TLS、反向代理、gRPC/xDS、出站 DNS、上传或用户可控的 curl 请求。因此这些 High 项对应的默认服务路径不可达，但仍应在上游发布重建镜像后及时升级。

## Introduction

Moodist is a free and open-source ambient sound mixer. It lets you layer sounds from nature, rain, cities, places, transport, and noise for focus, relaxation, or sleep.

## Features

- Layer multiple ambient sounds and adjust each level independently
- Save, rename, and reapply custom sound presets
- Sleep timer, Pomodoro, countdown, and breathing tools
- Share sound mixes through links
- Installable progressive web app

## Usage And Security Notes

Open the app at `http://<server-ip>:<port>` using the Web port configured during installation.

Sound selection, volume, presets, and other personal settings are stored in the current browser rather than a server-side data directory. Clearing site data or changing browsers does not migrate them, and uninstalling the container does not clear browser-local data.

Moodist has no built-in authentication. Restrict public exposure through an HTTPS reverse proxy. Some PWA and media-session capabilities require a secure browser context.

The packaged image scans as `0 Critical / 9 High`, covering c-ares, curl/libcurl, the Go standard library, and gRPC in the Caddy base image. The shipped Caddyfile only serves static files from `/var/www/html`; it configures no TLS, reverse proxy, gRPC/xDS, outbound DNS, upload path, or user-controlled curl request. Those High paths are not reachable through the default deployment, but the image should still be upgraded after upstream rebuilds it with fixed packages.

## References

- Project and self-hosting: <https://github.com/remvze/moodist>
- License: <https://github.com/remvze/moodist/blob/main/LICENSE> (MIT)
- Logo: <https://github.com/remvze/moodist/blob/983f7412e8cd054e76d156977c563da2028e4428/public/favicon.svg>
- Bundled audio includes upstream-declared Pixabay Content License and CC0 assets; see the project's license notes before redistribution.
