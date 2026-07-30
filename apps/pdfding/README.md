# PdfDing

## 产品介绍

PdfDing 是一个自托管的 PDF 管理、阅读与编辑工具，支持跨设备阅读进度、工作区与集合、标签、批量操作、分享、批注、签名和双因素认证。

## 主要功能

- 在浏览器中上传、管理、阅读和编辑 PDF
- 使用工作区、集合、多级标签、收藏和归档组织文档
- 添加高亮、评论、绘图、文本和签名
- 通过链接或二维码分享 PDF 和集合
- 支持本地账户、OIDC 单点登录和双因素认证

## 访问说明

- 安装后访问 `http://<服务器 IP>:<配置端口>` 并注册首个本地账户
- 默认配置适用于 HTTP 直连；通过 HTTPS 反向代理访问时，请将公开 URL 协议设为 HTTPS、启用安全 Cookie，并将允许的主机设置为实际域名
- 数据库和上传的 PDF 分别保存在版本目录的 `data/db` 与 `data/media` 中

## Introduction

PdfDing is a self-hosted PDF manager, viewer and editor with reading progress, workspaces, collections, tags, sharing, annotations, signatures and two-factor authentication.

## Features

- Upload, organize, read and edit PDFs in a browser
- Organize documents with workspaces, collections, nested tags, starring and archiving
- Add highlights, comments, drawings, text and signatures
- Share PDFs and collections by link or QR code
- Use local accounts, OIDC single sign-on and two-factor authentication

## Access

- Open `http://<server-ip>:<configured-port>` and register the first local account
- The defaults are intended for direct HTTP access; select HTTPS as the public URL scheme, enable secure cookies and set the actual host when using an HTTPS reverse proxy
- The SQLite database and uploaded PDFs are stored under `data/db` and `data/media` in the selected version directory

Official documentation: <https://docs.pdfding.com/getting_started/docker/>
