# DailyTxT

## 应用简介

DailyTxT 是一款加密的个人日记 Web 应用，支持 Markdown、文件上传、标签、搜索和地图等功能。

## 产品介绍

DailyTxT 使用 Svelte 和 Go 编写，所有日记内容在写入服务器存储之前都会进行加密。支持多用户，每位用户拥有独立的加密密钥。

## 主要功能

- 端到端加密日记存储
- Markdown 编辑与实时预览
- 文件上传（单文件最大 500 MB）
- 图片画廊与全屏查看
- 标签与搜索
- 地图定位与 GPX 轨迹
- 自定义模板
- 多语言支持
- 导出为 HTML
- 移动端响应式与 PWA 支持

## 访问说明

- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 默认端口为 `8000`，可通过 `PANEL_APP_PORT_HTTP` 自定义。
- 首次访问时，使用安装表单中设置的 `ADMIN_PASSWORD` 登录管理员面板。
- `SECRET_TOKEN` 用于加密会话 Cookie，请妥善保存。
- `ALLOW_REGISTRATION` 控制是否允许新用户注册，建议首次创建用户后关闭。

## 数据持久化

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web UI 端口 | 8000 | 是 |
| SECRET_TOKEN | 安全密钥（建议 32 位 base64） | 随机生成 | 是 |
| ADMIN_PASSWORD | 管理员密码 | 随机生成 | 是 |
| ALLOW_REGISTRATION | 允许新用户注册 | false | 是 |
| INDENT | JSON 文件缩进空格数 | 4 | 否 |
| LOGOUT_AFTER_DAYS | 登录 Cookie 过期天数 | 40 | 是 |
| BASE_PATH | 子路径部署（如 /dailytxt） | 空 | 否 |
| TZ | 时区 | Asia/Shanghai | 是 |

## Introduction

DailyTxT is an encrypted personal diary/journal web application with Markdown support, file uploads, tags, search, and map integration.

## Features

- End-to-end encrypted diary storage
- Markdown editing with live preview
- File uploads (up to 500 MB per file)
- Image gallery and fullscreen view
- Tags and search
- Map locations and GPX tracks
- Custom templates
- Multi-language support
- Export to HTML
- Mobile responsive and PWA support

## References

- 官网 / Website：<https://dailytxt.phitux.de>
- GitHub：<https://github.com/PhiTux/DailyTxT>
- Docker Hub：<https://hub.docker.com/r/phitux/dailytxt>
