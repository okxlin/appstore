# Note Mark

## 产品介绍

Note Mark 是一款轻量、快速的自托管 Markdown 笔记应用，提供适配移动端的 Web 界面，并使用普通文件和目录保存笔记与附件。

## 主要功能

- 支持 GitHub Flavored Markdown、实时编辑和渲染视图
- 支持友好链接、笔记分享以及附件上传
- 支持多用户注册与登录，并可按需关闭内部注册或匿名用户搜索
- 使用 SQLite 保存账号信息，使用标准 Markdown 文件保存笔记内容

## 访问说明

应用默认仅绑定到 `127.0.0.1`，建议通过同机 HTTPS 反向代理访问。公开访问地址必须填写为完整的 HTTP 或 HTTPS URL，且末尾不能带 `/`。相对数据目录会在安装时自动解析到应用级 `retained-data` 目录，并按容器名隔离，因此卸载实例后仍会保留；绝对路径则保持不变。备份时应完整保存最终配置的数据目录，其中包含数据库、笔记和附件。

认证签名密钥由安装时的随机 seed 确定性派生。修改 seed 会使现有登录会话失效，请仅在明确需要轮换认证密钥时修改。

## Introduction

Note Mark is a lightweight, fast, and responsive self-hosted Markdown notes application. It stores notes and assets as ordinary files and keeps account data in SQLite.

## Features

- GitHub Flavored Markdown with live editing and rendered views
- Friendly note URLs, sharing, and asset uploads
- Internal multi-user signup and login with configurable anonymous user search
- Mobile-friendly web interface and portable file-based note storage

The package binds to `127.0.0.1` by default. Publish it through a same-host HTTPS reverse proxy and set the public URL to the exact external address without a trailing slash. Relative data paths are resolved into a per-container directory under the app-level `retained-data` directory so that uninstalling an instance preserves its data; absolute paths remain unchanged. Back up the complete resolved data directory before upgrades.
