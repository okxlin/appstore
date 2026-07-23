# GoTab

## 产品介绍

GoTab 是一个个性化浏览器新标签页、起始页和个人主页，支持登录后同步个人配置与页面数据。

## 主要功能

- 自定义浏览器新标签页、起始页和个人主页。
- 管理默认主页数据和用户个人数据。
- 通过管理后台调整站点功能开关。

## 访问说明

安装完成后，使用 1Panel 应用详情中配置的 Web 端口访问 GoTab。

首次访问会进入 `/install/` 安装向导。安装时先选择 1Panel 商店管理的 MySQL service；1Panel 会为本应用准备独立数据库和用户。然后将应用表单生成的数据库主机、端口、数据库名、用户名和密码填入官方安装向导。GoTab 需要 MySQL 8.0 或更高版本，应用容器不会自动跳过该向导。

管理后台入口位于“管理员 -> 我的 -> 管理端”，也可以在登录后直接访问 `/console`。

## 部署说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 支持 `amd64`、`arm64` 架构。
- `PANEL_APP_PORT_HTTP`：Web 访问端口，默认 `43009`。
- `TIME_ZONE`：应用时区，默认 `Asia/Shanghai`。
- `PANEL_DB_TYPE`：数据库服务，当前支持 1Panel 商店管理的 `mysql`。
- `PANEL_DB_HOST`：由 1Panel service 选择器注入的数据库服务名。
- `PANEL_DB_PORT`：数据库端口，默认 `3306`。
- `PANEL_DB_NAME`、`PANEL_DB_USER`、`PANEL_DB_USER_PASSWORD`：由 1Panel 生成的独立数据库凭据。

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

The first visit opens the `/install/` setup wizard. Select a store-managed MySQL service during installation, then enter the generated host, port, database name, username, and password in the official wizard. GoTab requires MySQL 8.0 or newer and the app container does not bypass this wizard.
