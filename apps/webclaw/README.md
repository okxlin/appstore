# WebClaw

## 产品介绍

WebClaw 是一个自托管、无状态的网页内容提取 REST API。它可以抓取公开网页，并返回适合检索、归档和 AI 工作流使用的 Markdown、纯文本、HTML 或结构化 JSON。

## 主要功能

- 通过 `/v1/scrape` 提取单个网页
- 支持 Markdown、纯文本、HTML、LLM 文本和 JSON 输出
- 支持站点抓取、URL 映射、批量提取、差异比较和品牌信息提取
- 可选接入 Serper.dev 搜索和 WebClaw Cloud 回退服务
- 使用 Bearer Token 保护所有 `/v1/*` 接口

## 访问说明

- 安装后通过设置的 HTTP 端口访问 REST API；`/health` 可用于健康检查。
- 调用 `/v1/*` 接口时，在 `Authorization` 请求头中提供安装时生成的 API Token。
- 默认包启动开源的 `webclaw-server`，不包含托管版的反机器人绕过、JavaScript 渲染、多租户和计费功能。
- 服务会访问用户提交的 URL。对公网开放前，请通过 1Panel 反向代理启用 HTTPS，并限制 API Token 的分发范围。

## 可选服务

- `WEBCLAW_CLOUD_API_KEY` 用于在受保护站点上启用 WebClaw Cloud 回退。
- `SERPER_API_KEY` 用于启用 `/v1/search`；留空时该接口返回未配置状态，不影响本地网页提取。

## 数据说明

开源服务器本身无状态，不创建数据库或持久化用户内容。API Token 和可选外部服务密钥由 1Panel 应用配置管理。

## 链接

- 网站：https://webclaw.io
- 项目：https://github.com/0xMassi/webclaw
- 镜像：https://github.com/0xMassi/webclaw/pkgs/container/webclaw

## Introduction

WebClaw is a self-hosted, stateless REST API for extracting public web pages as clean Markdown, plain text, HTML, or structured JSON.

## Features

- Extract a page through `/v1/scrape`
- Return Markdown, plain text, HTML, LLM text, or JSON
- Crawl sites, map URLs, process batches, compare pages, and extract brand metadata
- Optionally enable Serper.dev search and WebClaw Cloud fallback
- Protect every `/v1/*` endpoint with a Bearer token

The `/health` endpoint is available without authentication. Send the generated API token in the `Authorization: Bearer ...` header for `/v1/*` requests. Enable HTTPS through a 1Panel reverse proxy before exposing the service publicly.
