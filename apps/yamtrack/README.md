# Yamtrack

## 产品介绍

Yamtrack 是一个自托管媒体追踪器，可在同一界面管理电影、电视、动漫、游戏、书籍、漫画和桌游的观看或游玩进度。

## 主要功能

- 搜索并追踪多种媒体类型、评分、状态和进度
- 从 Trakt、Simkl、AniList、MyAnimeList 等服务导入记录
- 支持 Jellyfin、Plex 和 Emby webhook
- 提供统计、列表、日历和通知功能

## 访问说明

安装后通过 1Panel 反向代理访问 Yamtrack，或在可信局域网场景下修改绑定地址后使用表单中的 HTTP 端口直接访问。首次打开时创建账户；完成后如不需要其他用户注册，请在应用参数中关闭注册。

## 部署说明

- 本应用包使用上游默认的 SQLite + Redis 拓扑。SQLite 数据保存在 `data/yamtrack`，Redis 数据保存在 `data/redis`。
- 默认端口只绑定到 `127.0.0.1`。请使用 1Panel 反向代理提供 HTTPS 访问；需要直接从局域网访问时再修改绑定地址。
- 首次安装默认允许注册。创建首个账户后，如不需要其他用户注册，请在应用参数中关闭注册并重建容器。
- 升级、迁移或卸载前，请备份整个数据目录。卸载脚本不会删除持久化数据。

## 安全说明

- `0.25.3` 镜像中的 PyJWT 版本存在仅影响混合对称/非对称 JWT 验证配置的安全问题。本应用包不启用或暴露社交登录配置，并明确保持 `SOCIAL_PROVIDERS` 为空。不要在此版本中手动启用 OIDC 或其他社交登录；应先升级到包含 PyJWT 2.13.0 或更高版本的上游发行版。
- Redis 不发布主机端口，只能通过应用内部网络访问。
- Yamtrack 内部提供 HTTP 服务。对不受信任网络开放时，应由 1Panel 反向代理终止 TLS，并配置访问控制、请求大小和速率限制。

## Introduction

Yamtrack is a self-hosted media tracker for movies, television, anime, games, books, comics, and board games.

## Features

- Track ratings, status, and progress across multiple media types
- Import history from Trakt, Simkl, AniList, MyAnimeList, and other services
- Receive Jellyfin, Plex, and Emby webhooks
- Browse statistics, lists, calendars, and notifications

## Deployment And Security

- This package follows the upstream SQLite and Redis topology. SQLite data is stored under `data/yamtrack`, while Redis data is stored under `data/redis`.
- The host port binds to `127.0.0.1` by default. Use a 1Panel reverse proxy for HTTPS, or explicitly change the bind address for direct LAN access.
- Registration is enabled initially so the first account can be created. Disable registration in the app settings afterward unless additional signups are required.
- Social authentication is deliberately disabled. Do not manually enable `SOCIAL_PROVIDERS` on version `0.25.3`; upgrade to an upstream release containing PyJWT 2.13.0 or newer first.
- Redis is isolated on an internal network and has no published host port.
- Back up the complete data directory before upgrades or migrations. Uninstalling the app does not delete persistent data.

## References

- Source: <https://github.com/FuzzyGrim/Yamtrack>
- Documentation: <https://github.com/FuzzyGrim/Yamtrack/tree/dev/docs>
- Environment variables: <https://github.com/FuzzyGrim/Yamtrack/blob/dev/docs/env-variables.md>
- License: <https://github.com/FuzzyGrim/Yamtrack/blob/dev/LICENSE>
