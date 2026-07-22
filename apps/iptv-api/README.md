# IPTV-API

## 产品介绍

IPTV-API 是一个 IPTV 播放列表自动更新工具，可从用户配置的数据源聚合频道，执行可用性验证和测速，并生成 M3U、TXT、EPG 及 API 输出。

## 主要功能

- 聚合本地源和订阅源
- 验证频道可用性并按速度、分辨率等条件筛选
- 生成 M3U、TXT、IPv4、IPv6 和 EPG 输出
- 按固定时间或间隔自动更新
- 通过 HTTP 接口访问结果，并可选启用推流转发

## 访问说明

- 安装时将 `PUBLIC_DOMAIN` 设置为客户端实际访问的域名或 IP。`PUBLIC_SCHEME` 和 Web 端口也会写入生成的播放地址。
- 安装完成后访问 `http://服务器地址:Web 端口/`。还可使用 `/m3u`、`/txt`、`/content`、`/epg/epg.xml` 和 `/log/result` 等接口。
- 首次启动会按默认配置执行更新。应用不提供直播源；请在应用数据目录的 `config/subscribe.txt` 或 `config/local.txt` 中添加有权使用的数据源。
- 修改 `config/config.ini` 后重启应用即可生效。安装表单中的环境变量优先于同名配置项。

## 数据与升级

- 配置文件保存在 `APP_DATA_DIR/config`，播放列表、日志和缓存保存在 `APP_DATA_DIR/output`。
- 升级前请备份这两个目录。固定版本与 `latest` 目录使用相同的数据布局。
- 卸载应用会停止并删除容器，但不会删除绑定到宿主机的数据目录。

## 安全与合规

- 本应用会访问用户配置的第三方 URL，并可调用 FFmpeg 处理媒体流。请只添加可信、合法且已获授权的数据源，不要向不受信任用户开放配置目录写权限。
- 推流转发可能消耗较多 CPU、内存和带宽；公开服务前请限制访问范围并评估资源用量。
- 使用直播源、节目单和推流功能时，应遵守当地版权、广播电视、网络视听及网络服务规定。

## 参考资料

- 源代码：<https://github.com/Guovin/iptv-api>
- Docker 部署：<https://github.com/Guovin/iptv-api#docker>
- 配置说明：<https://github.com/Guovin/iptv-api/blob/master/docs/config.md>
- 使用教程：<https://github.com/Guovin/iptv-api/blob/master/docs/tutorial.md>
- 许可证：AGPL-3.0

## Introduction

IPTV-API automatically aggregates user-provided IPTV sources, validates and filters channels, and produces M3U, TXT, EPG, and HTTP API outputs.

## Features

- Aggregate local and subscribed channel sources
- Validate and filter channels by availability, speed, and resolution
- Generate M3U, TXT, IPv4, IPv6, and EPG outputs
- Run updates on a schedule and expose results through HTTP endpoints
- Optionally relay authorized streams through the built-in media service

## Usage

- Set `PUBLIC_DOMAIN` to the domain or IP used by clients. The public scheme and Web port are included in generated playlist URLs.
- Open `http://server-address:Web-port/` after installation. Additional endpoints include `/m3u`, `/txt`, `/content`, `/epg/epg.xml`, and `/log/result`.
- IPTV-API does not include channel sources. Add sources that you are authorized to use in `config/subscribe.txt` or `config/local.txt` under the application data directory.
- Back up both the `config` and `output` directories before upgrading. Uninstalling the app does not remove bind-mounted data.
- Only use trusted and legally authorized media sources. Stream relay can consume substantial CPU, memory, and bandwidth.
