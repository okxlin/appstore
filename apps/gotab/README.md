# GoTab

## 产品介绍

GoTab 是一个个性化浏览器新标签页、起始页和个人主页，支持登录后同步个人配置与页面数据。

## 主要功能

- 自定义浏览器新标签页、起始页和个人主页。
- 管理默认主页数据和用户个人数据。
- 通过管理后台调整站点功能开关。

## 访问说明

安装完成后，使用 1Panel 应用详情中配置的 Web 端口访问 GoTab。

首次访问会进入 `/install/` 安装向导。请先准备 MySQL 8.0 或更高版本，并在向导中填写数据库连接信息；数据库不由本应用容器自动创建。

管理后台入口位于“管理员 -> 我的 -> 管理端”，也可以在登录后直接访问 `/console`。

## 部署说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 支持 `amd64`、`arm64` 架构。
- `PANEL_APP_PORT_HTTP`：Web 访问端口，默认 `43009`。
- `TIME_ZONE`：应用时区，默认 `Asia/Shanghai`。

## 数据持久化

- `./data/uploads:/app/uploads`
- `./data/sourceStore:/app/sourceStore`
- `./data/config.toml:/app/config.toml`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明

后台设置中的部分功能开关会写入 `/web/siteConfig.js`。如果配置变更没有立即生效，请检查浏览器或服务缓存；HTML 文件、`/background.js` 和 `/api/*` 路径也可能受到缓存影响。

未登录时，页面数据默认只保存在浏览器本地。登录后，默认主页数据由管理员策略控制，个人数据随用户账号保存。

## 参考资料

- 官网：<https://www.gotab.cn/>
- 项目文档：<https://github.com/dengxiwang/gotab-personal>

## Introduction

GoTab is a personalized browser new tab page, start page, and personal homepage. Signed-in users can keep their personal configuration and page data with their account.

## Features

- Custom browser new tab, start, and personal home pages.
- Separate default homepage data from account-specific user data.
- Manage site feature switches from the administration console.

## Access

Open GoTab through the Web port configured in the 1Panel app details. Administrators can use "Administrator -> My -> Admin" or open `/console` after signing in.

The first visit opens the `/install/` setup wizard. Prepare MySQL 8.0 or newer and enter its connection details in the wizard; this app container does not create the database service automatically.
