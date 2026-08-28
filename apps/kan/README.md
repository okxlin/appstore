# Kan

## 产品介绍

Kan 是一个自托管的项目管理工具，用看板、工作区和协作功能帮助团队管理任务。它是 Trello 的开源替代方案，官方项目采用 AGPLv3 许可证。

## 主要功能

- 看板可见性控制与工作区成员协作
- 卡片标签、筛选、评论和活动记录
- 从 Trello 导入看板
- 使用官方 Kan Web 与迁移程序，并联动 1Panel PostgreSQL 服务

## 访问说明

- 安装时填写对外访问 Kan 的完整 URL，必须与实际访问地址一致，例如 `https://kan.example.com`。
- Web 端口由 `PANEL_APP_PORT_HTTP` 映射，安装后通过该端口或反向代理访问。
- 首次打开后创建首个账户；如果通过反向代理访问，请同时配置 HTTPS 和正确的外部 URL。

## 配置项

安装表单会选择 1Panel 中已运行的 `postgresql` 服务，并由 1Panel 为 Kan 创建数据库和用户。`PANEL_DB_HOST`、数据库名、用户和密码属于初始化后的连接配置，安装后不要随意修改；数据库密码必须只使用 URL 安全字符（字母、数字、`.`、`_`、`~`、`-`）。

`BETTER_AUTH_SECRET` 必须至少 32 个字符。默认关闭依赖 SMTP 的邮件能力；需要邮件通知、找回密码或其他邮件功能时，请在应用配置中补充官方支持的 SMTP 参数。

PostgreSQL 数据由所选的 1Panel 数据库应用负责持久化，Kan 卸载脚本不会删除 PostgreSQL 应用或其数据。重新安装或迁移前请在 1Panel 中分别备份 Kan 与 PostgreSQL；卸载时是否删除 1Panel 记录的数据库资源，以面板确认项为准。

## 安全提醒

本适配直接使用 Kan 官方发布的 Web 与迁移容器镜像，没有在适配层重打包或修补上游代码。针对当前使用的官方 `0.6.0` 镜像版本扫描发现了 Critical/High 级别依赖告警，涉及 Web 身份认证/解析依赖和迁移镜像工具链；这不代表所有问题都能从 Kan 入口利用，但也不能视为已经修复。按用户授权保留这些官方镜像并在此处明确告警；生产环境请限制管理入口、使用 HTTPS，分别关注 Kan 与所选 PostgreSQL 镜像的安全更新。

Kan 采用 AGPLv3；分发修改后的应用或镜像时，请遵守上游许可证及源码提供义务：[LICENSE](https://github.com/kanbn/kan/blob/v0.6.0/LICENSE)。

## Introduction

Kan is a self-hosted project management tool for teams. It provides boards, workspaces, and collaboration features as an open-source alternative to Trello, under the AGPLv3 license.

## Features

- Board visibility controls and workspace collaboration
- Labels, filters, comments, and activity history
- Trello board import
- Official Kan web and migration services linked to a 1Panel PostgreSQL service

## Access

- Enter the complete public URL used to access Kan during installation, such as `https://kan.example.com`.
- The web listener is published through `PANEL_APP_PORT_HTTP`; it can also be placed behind a reverse proxy.
- Create the first account after opening the site. When using a proxy, enable HTTPS and keep the external URL consistent with the proxy address.

## Data

- The install form selects a running `postgresql` service in 1Panel, and 1Panel creates Kan's database and user. Keep `PANEL_DB_HOST`, the database name, user, and password stable after installation; the database password must use URL-safe characters (`A-Z`, `a-z`, `0-9`, `.`, `_`, `~`, `-`).
- `BETTER_AUTH_SECRET` must contain at least 32 characters. SMTP-dependent email features are disabled by default. Add the official SMTP settings when email notifications, password recovery, or other email features are required.
- PostgreSQL persistence belongs to the selected 1Panel database application. The Kan uninstall helper does not delete that PostgreSQL application or its data. Back up both Kan and PostgreSQL before reinstalling or migrating; during uninstall, follow the resource deletion choices shown by 1Panel.

## Security notice

This package uses Kan's official published web and migration images without repacking or patching the upstream code. Scans of the currently used official `0.6.0` image version found Critical/High dependency findings in the web authentication/parser dependencies and migration toolchain. These findings are not a claim that every item is exploitable through Kan, but they are also not treated as fixed. The images are retained under the user's authorization with this warning; restrict administrative access, use HTTPS, and track security updates for both Kan and the selected PostgreSQL image.

Kan is licensed under AGPLv3. Follow the upstream license and source-disclosure obligations when distributing modified applications or images: [LICENSE](https://github.com/kanbn/kan/blob/v0.6.0/LICENSE).
