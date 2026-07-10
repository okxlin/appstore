# RomM

## 产品介绍

RomM 是一个自托管的复古游戏库管理器。它可以扫描游戏文件、补充封面和元数据、管理存档与状态，并通过浏览器中的 EmulatorJS 或 Ruffle 直接运行受支持的游戏。

## 主要功能

- 管理 400 多种游戏平台的游戏库。
- 从 ScreenScraper、RetroAchievements、SteamGridDB 和 Hasheous 获取元数据。
- 支持浏览器游玩、存档、状态、截图、补丁和多用户权限。
- 内置 Valkey 缓存和任务队列，使用 MariaDB 11 持久化业务数据。

## 访问说明

- 默认 Web 端口：`8080`
- 容器内部端口：`8080`
- 首次访问会进入设置向导，第一个创建的用户自动成为管理员。
- 基础扫描不强制要求元数据服务凭据，但建议至少配置一个元数据来源。

## 数据持久化

安装表单中的“数据目录”包含：

- `romm/`：游戏库、资源、上传的存档与截图以及 `config.yml`。
- `redis/`：镜像内置 Valkey 的缓存与后台任务数据。
- `mariadb/`：MariaDB 数据库文件。

RomM 需要在部分目录之间创建硬链接，因此本适配将整个 `/romm` 挂载为同一个文件系统。游戏文件应放入 `romm/library/roms/` 下符合官方目录规范的位置。

升级前建议备份整个数据目录。卸载应用不会删除绑定目录中的用户数据。

## 元数据服务

- `HASHEOUS_API_ENABLED` 默认启用，不需要账号。
- ScreenScraper 用户名和密码为可选项。
- RetroAchievements 和 SteamGridDB API Key 为可选项。
- 元数据服务可能受网络、地区限制或第三方服务条款影响。

## 安全与资源说明

- 安装表单会生成 MariaDB 用户密码、MariaDB root 密码和固定的 RomM 会话签名密钥。
- 不要在升级时更换上述密码或签名密钥，否则可能导致数据库连接失败或现有登录会话失效。
- RomM 容器内部以 root 启动多个进程，但不需要特权模式、Docker Socket 或 host 网络。
- 对公网开放时，建议通过 1Panel 网站反向代理启用 HTTPS。
- 游戏文件、固件和 BIOS 可能受版权限制，请仅使用有权持有和运行的内容。
- 标准镜像包含浏览器模拟器，镜像体积较大，首次安装需要较长拉取时间。

## 版本说明

- `4.9.2`：固定的最新稳定版本，适合需要可重复部署的用户。
- `latest`：跟随官方最新稳定镜像，升级前应阅读上游发布说明并备份数据。

项目采用 AGPL-3.0 许可证。

## Introduction

RomM is a self-hosted retro game library manager. It scans and enriches game collections, manages saves and states, and can run supported games in the browser through EmulatorJS or Ruffle.

## Features

- Manage and enrich retro game libraries for more than 400 platforms.
- Play supported games in the browser and manage saves, states, screenshots, and patches.
- Use optional metadata providers including ScreenScraper, RetroAchievements, SteamGridDB, and Hasheous.
- Keep application data, the built-in Valkey cache, and the MariaDB database persistent across upgrades.

## Links

- Project: https://github.com/rommapp/romm
- Documentation: https://docs.romm.app/latest/
- Docker image: https://hub.docker.com/r/rommapp/romm
