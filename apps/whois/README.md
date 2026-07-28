# WhoIs

## 产品介绍

WhoIs 是一个自托管的 WHOIS 与 RDAP 查询服务，可通过 HTTP API 查询域名、IPv4、IPv6、CIDR 和自治系统信息。返回结构遵循 RDAP 词汇，并提供 OpenAPI 文档、缓存和条件请求支持。

## 主要功能

- 自动识别域名、IP 地址、CIDR 和 ASN 查询
- 提供类型明确的 RDAP 风格查询路径和结构化 JSON 响应
- 提供 OpenAPI、健康状态和 Prometheus 指标端点
- 支持 ETag 条件请求和内存缓存

## 访问说明

默认仅绑定到 `127.0.0.1`。请通过 1Panel 反向代理或 SSH 端口转发访问安装时设置的 HTTP 端口。查询入口为 `/<域名或地址>`，OpenAPI 文档位于 `/openapi.json`。

默认使用内存缓存，不依赖 Redis，也不保存服务端业务数据。容器重启后缓存会重新建立。

公开部署前应在反向代理层配置 HTTPS、访问控制和请求速率限制，避免未经限制的查询消耗上游注册局配额。

## Introduction

WhoIs is a self-hosted WHOIS and RDAP lookup service for domains, IPv4 and IPv6 addresses, CIDR prefixes, and autonomous systems. Its HTTP API returns structured RDAP-style responses and publishes an OpenAPI specification.

## Features

- Auto-detect domains, IP addresses, CIDR prefixes, and ASNs
- Provide typed RDAP-style routes and structured JSON responses
- Expose OpenAPI, health, and Prometheus metrics endpoints
- Support ETag revalidation and an in-memory cache

The package binds to `127.0.0.1` by default and uses memory-only caching. Put it behind a 1Panel reverse proxy with HTTPS, access control, and request rate limiting before exposing it publicly.

## References

- Source: <https://github.com/KincaidYang/whois>
- Documentation: <https://github.com/KincaidYang/whois/blob/main/README_EN.md>
- API errors: <https://github.com/KincaidYang/whois/blob/main/docs/errors.md>
