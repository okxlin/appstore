# HomeBox

## 应用简介

HomeBox 是一款面向家庭用户的物资与库存管理系统，帮助记录家中物品、存放位置、标签与数量，让家庭物资井井有条。

## 产品介绍

HomeBox 基于 Go 构建，提供简洁的 Web 界面。当前镜像与项目由 SysAdmins Media 社区维护；本应用使用官方 hardened 镜像，并以非 root 用户运行。用户可以创建位置、添加物品、设置标签，并通过搜索快速查找。

## 主要功能

- 创建房间、柜子等存放位置
- 记录物品名称、数量、图片与标签
- 支持搜索与筛选
- 数据导出
- 多用户支持

## 访问说明

- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 默认端口为 `7745`，可通过 `PANEL_APP_PORT_HTTP` 自定义。
- 首次打开 Web UI 后注册管理员账号即可开始使用。

## 数据持久化

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据库存放目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

官方 hardened 镜像以 UID/GID `65532` 运行，安装脚本会自动设置数据目录所有权。

`HBOX_AUTH_API_KEY_PEPPER` 由安装表单自动生成并持久化在安装配置中。该值必须在重启和升级时保持不变；轮换它会使已签发的 API 密钥失效。独立 Compose 部署时，请使用 `openssl rand -base64 48` 生成至少 32 字节的值。

## 配置说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web UI 端口 | 7745 | 是 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| TZ | 时区 | Asia/Shanghai | 是 |
| HBOX_AUTH_API_KEY_PEPPER | API 密钥签名 Pepper（至少 32 字节） | 自动生成 | 是 |

## Introduction

HomeBox is a self-hosted inventory and organization system built for home users to track items, locations, and labels.

## Features

- Create storage locations such as rooms and cabinets
- Record item names, quantities, images, and labels
- Search and filter support
- Data export
- Multi-user support

## References

- GitHub：<https://github.com/sysadminsmedia/homebox>
- Container Registry：<https://github.com/sysadminsmedia/homebox/pkgs/container/homebox>（`latest-hardened`）
- Documentation：<https://homebox.software/en/>
