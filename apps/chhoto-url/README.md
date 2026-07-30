# Chhoto URL

## 产品介绍

Chhoto URL 是一个使用 Rust 编写的轻量短链接服务。它提供 Web 界面和 JSON API，使用本地 SQLite 数据库存储短链接、备注、访问次数和到期时间。

## 主要功能

- 创建自定义或自动生成的短链接
- 查询、编辑、删除和分页检索短链接
- 设置链接到期时间并统计访问次数
- 通过 Web 界面或 API key 调用 JSON API

## Introduction

Chhoto URL is a lightweight URL shortener written in Rust. It provides a web interface and JSON API, storing short links, notes, hit counts, and expiry times in a local SQLite database.

## Features

- Create custom or automatically generated short links
- Query, edit, delete, and paginate stored links
- Configure link expiry and track redirect counts
- Use either the web interface or API-key-authenticated JSON API

## 访问说明

安装后通过 `http://<服务器 IP>:4567` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。使用安装表单中设置的管理员密码登录。命令行或其他程序可以通过 `X-API-Key` 请求头使用安装表单中的 API key。

管理员密码通过普通 HTTP 传输时不会被加密。对不受信任网络开放服务前，应通过 1Panel 网站反向代理启用 HTTPS。

## 参数说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Web 界面和 API 的 HTTP 端口 | `4567` | 是 |
| `APP_DATA_DIR` | SQLite 数据库和 WAL 文件目录 | `./data` | 是 |
| `CHHOTO_PASSWORD` | Web 管理员密码 | 安装时随机生成 | 是 |
| `CHHOTO_API_KEY` | JSON API 访问密钥 | 安装时随机生成 | 是 |
| `CHHOTO_SITE_URL` | 用于复制链接和二维码的公开访问地址 | 空 | 否 |
| `CHHOTO_REDIRECT_METHOD` | 短链接跳转方式 | `TEMPORARY` | 是 |

## 部署与安全

- 使用 Chhoto URL 官方 scratch 镜像和单服务拓扑。
- 容器以 UID/GID `1000:1000` 运行，根文件系统只读，并移除全部 Linux capabilities。
- SQLite 数据库位于 `/data/urls.sqlite`，默认启用 WAL 与 ACID 持久化。
- 公共写入模式默认关闭；创建、查询和删除链接需要管理员密码或 API key。
- 可选的 `CHHOTO_SITE_URL` 应填写浏览器实际访问的完整 URL，例如 `https://short.example.com`。

## 数据与升级

升级、迁移或卸载前，请备份 `APP_DATA_DIR` 指向的完整目录，不能只复制 `urls.sqlite` 文件。默认的 `./data` 位于 1Panel 应用安装目录内，卸载时会被移除。需要跨卸载保留数据时，可选择独立绝对路径；若目录已经存在，须提前将其所有权设为 UID/GID `1000:1000`，应用脚本不会修改既有绝对目录的所有权。

## 参考资料

- 项目仓库: <https://github.com/SinTan1729/chhoto-url>
- 安装文档: <https://github.com/SinTan1729/chhoto-url/blob/main/docs/INSTALLATION.md>
- API 文档: <https://github.com/SinTan1729/chhoto-url/blob/main/docs/CLI.md>
