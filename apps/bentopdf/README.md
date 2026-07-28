# BentoPDF

## 产品介绍

BentoPDF 是一个在浏览器中本地处理文档的 PDF 工具集，提供合并、拆分、转换、编辑、OCR 和签名等功能。此应用使用官方推荐的 `bentopdf-simple` 自托管镜像，不使用商业镜像。

## 主要功能

- 合并、拆分、转换、编辑、OCR 和签名 PDF。
- 在浏览器中处理文档，无需应用数据库或服务端文件卷。
- 使用上游的自托管 Simple Mode 完整工具集。

## 访问说明

- 默认 Web 端口：`8080`
- 容器内部端口：`8080`
- 安装完成后在浏览器打开 1Panel 中配置的端口。

## 数据与隐私

- 容器不挂载持久化目录，也不包含数据库。
- 文档由浏览器处理；关闭或刷新页面前请下载处理结果。
- 将服务暴露到公网时，请通过 1Panel 网站反向代理配置 HTTPS 和访问控制。

## 版本

- `latest` 跟随官方自托管镜像的最新发布。
- 固定版本目录用于可重复部署。

## 许可证

BentoPDF 上游项目采用 AGPL-3.0-only 许可证。

## Introduction

BentoPDF is a PDF toolkit that processes documents locally in the browser. It includes tools for merging, splitting, converting, editing, OCR, and signing PDFs. This package uses the upstream-recommended `bentopdf-simple` self-hosted image, not the commercial image.

## Features

- Merge, split, convert, edit, OCR, and sign PDFs.
- Process documents in the browser without an application database or server-side file volume.
- Use the complete upstream self-hosted Simple Mode toolset.

## Access

- Default web port: `8080`
- Container port: `8080`
- Open the port configured in 1Panel after installation.

## Data and Privacy

- The container has no persistent volume or database.
- Documents are processed in the browser; download results before closing or refreshing the page.
- When exposing the service publicly, configure HTTPS and access controls through a 1Panel website reverse proxy.
