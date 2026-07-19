# Scalar API Reference

## 产品介绍

Scalar API Reference 从 OpenAPI 和 Swagger 规范提供交互式 API 参考文档。本应用使用
官方 `scalarapi/api-reference` 镜像及其 `/docs` 文档扫描机制。

## 主要功能

- 在浏览器中展示和交互浏览 OpenAPI 文档。
- 自动识别 `data/docs` 中的 JSON、YAML 和 YML 规范文件。
- 预置非敏感示例规范，首次安装后即可验证服务和文档扫描。

## 访问说明

- 安装后访问 `http://<服务器 IP>:<HTTP 端口>`。
- 首次安装包含一个示例 OpenAPI 文档，用于确认参考文档界面和文档扫描正常工作。
- 在应用安装目录的 `data/docs` 中添加或替换 `.json`、`.yaml` 或 `.yml`
  OpenAPI 文件，然后重启应用。Scalar 会自动在页面中列出有效的规范文件。
- `data/docs` 为用户文档目录；卸载应用不会删除其中的文件。

## Usage

- Open `http://<server-ip>:<HTTP port>` after installation.
- The first installation includes a small OpenAPI example to verify the UI and
  document scan without additional setup.
- Add or replace `.json`, `.yaml`, or `.yml` OpenAPI documents in the installed
  app's `data/docs` directory, then restart the app. Scalar lists valid
  specifications automatically.
- `data/docs` contains user documentation and is preserved on uninstall.

## Introduction

Scalar API Reference serves interactive API documentation from OpenAPI and
Swagger specifications. This package uses the official
`scalarapi/api-reference` image and its documented `/docs` document scan.

## Features

- Display and interact with OpenAPI documents in a browser.
- Discover JSON, YAML, and YML specification files in `data/docs`.
- Include a non-sensitive example specification so a new install can verify the
  service and document scan immediately.

## Sources

- [Scalar Docker integration](https://scalar.com/products/api-references/integrations/docker)
- [Scalar source repository](https://github.com/scalar/scalar)
