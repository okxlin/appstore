# MDCz

## 产品介绍

MDCz 是一个高效、现代的影片元数据刮削与管理工具。它提供自托管 WebUI，可识别影片编号、抓取元数据与图片、生成 NFO 文件，并整理本地媒体文件，适合与 Emby、Jellyfin 等媒体库配合使用。

## 主要功能

- 从多个数据源刮削影片、演员、封面和缩略图等元数据。
- 生成 NFO 文件并按规则重命名、移动和归类影片。
- 批量扫描媒体目录，并通过 WebUI 查看任务进度和日志。
- 提供资料库、设置、维护工具和自动化接口。
- 使用 SQLite 保存配置、认证状态和任务数据。

## 访问说明

- Web 端口：安装表单中的 `PANEL_APP_PORT_HTTP`，默认 `3838`。
- 首次访问会进入初始化向导。
- 管理员密码由安装表单生成，并自动填入首次设置页面；请妥善保存，升级时不要随意更换。
- 初始化向导中的媒体目录必须填写容器路径 `/media`，不能填写宿主机路径。

## 数据持久化

- `APP_DATA_DIR` 挂载到 `/data`，保存 SQLite 数据库、配置文件和认证状态。
- `MEDIA_DIR` 挂载到 `/media`，供 MDCz 扫描和整理影片文件。
- 默认媒体目录位于 `./data/media`，也可以改为现有媒体库的绝对路径。
- 升级前应备份 `APP_DATA_DIR`；执行批量整理前还应备份媒体文件或先使用预览功能。

## 权限与文件操作风险

官方镜像以 UID/GID `1000:1000` 的非 root 用户运行。初始化脚本会修正应用数据目录权限；如果 `MEDIA_DIR` 指向已有媒体库，需要确保 UID `1000` 对其中的文件和子目录具有读写权限。

MDCz 的核心功能会创建目录与 NFO/图片文件，并可能按照设置移动、重命名或清理媒体文件。请先在少量文件上验证整理规则，不要直接对唯一副本执行批量操作。

## 网络与内容说明

- 不同元数据源可能存在地区访问限制，部分站点需要合适的代理或出口地区。
- 元数据源和影片内容可能受到服务条款、版权或当地法律限制，请仅处理有权持有和管理的内容。
- 对公网开放时，建议通过 1Panel 网站反向代理启用 HTTPS。

## 版本说明

- `0.10.0`：固定的首个官方 WebUI 自托管版本。
- `latest`：跟随官方最新发布镜像，升级前应阅读上游发布说明并备份数据。

项目采用 GPL-3.0 许可证。

## Introduction

MDCz is a self-hosted video metadata scraper and library management tool. It provides a browser WebUI for scraping metadata, generating NFO files, and organizing media for systems such as Emby and Jellyfin.

## Features

- Scrape metadata and artwork from multiple providers.
- Generate NFO files and organize local media with configurable naming rules.
- Persist configuration, authentication state, and tasks in SQLite under `/data`.
- Mount the writable media library at `/media`; verify rules on a small sample before batch operations.

## Links

- Project: https://github.com/ShotHeadman/mdcz
- Server documentation: https://github.com/ShotHeadman/mdcz/blob/main/apps/server/README.md
- Release: https://github.com/ShotHeadman/mdcz/releases/tag/v0.10.0
