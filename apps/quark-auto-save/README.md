# Quark Auto Save

## 产品介绍

Quark Auto Save 提供 WebUI，用于自动执行夸克网盘签到、分享链接转存、文件名整理、通知推送和媒体库刷新。它适合管理持续更新的网盘资源，并可通过插件与 Emby、OpenList、SmartStrm 等服务联动。

## 主要功能

- 定时签到并自动转存持续更新的分享资源。
- 使用正则表达式整理、重命名和筛选文件。
- 发送任务通知，并通过插件刷新媒体库或生成 STRM 文件。
- 通过 WebUI 管理多个账号、转存任务和插件配置。

## 访问说明

- Web 端口由安装表单设置，默认 `5005`。
- 使用安装表单生成的管理用户名和密码登录 WebUI。
- 夸克账号 Cookie、任务和插件配置保存在配置目录中，请定期备份。
- 媒体目录挂载到容器内 `/media`，供 STRM 等插件生成或读写媒体文件。
- `PLUGIN_FLAGS` 可按上游格式禁用插件，例如 `-emby,-aria2`；不了解时请留空。

## 数据持久化

- `APP_CONFIG_DIR` 挂载到 `/app/config`，保存账号、任务和应用配置。
- `MEDIA_DIR` 挂载到 `/media`，保存或访问插件生成的媒体内容。
- 升级前至少备份配置目录。将媒体目录指向已有媒体库时，应先在少量数据上验证插件行为。

## 风险与限制

- 本应用会保存夸克账号 Cookie。请限制面板和 WebUI 的访问范围，并使用强管理密码与 HTTPS 反向代理。
- 转存、重命名和媒体插件可能修改云端或挂载目录中的内容，请先验证任务规则。
- 不要设置过高的定时执行频率，以免触发账号风控或对上游服务造成过量请求。
- 请仅处理您有权访问和保存的内容，并遵守服务条款和当地法律。

## Introduction

Quark Auto Save automates Quark cloud-drive sign-in, share-link transfers, file renaming, notifications, and media-library refresh tasks through a self-hosted WebUI.

## Features

- Schedule sign-in and transfer tasks for continuously updated shares.
- Filter and rename files with regular-expression rules.
- Send notifications and integrate media-library or STRM plugins.
- Manage accounts, tasks, and plugins through the WebUI.

## Links

- Project: https://github.com/Cp0204/quark-auto-save
- Documentation: https://github.com/Cp0204/quark-auto-save/wiki
- Image: https://hub.docker.com/r/cp0204/quark-auto-save
