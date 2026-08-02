# Resin

## 产品介绍

Resin 是一个高性能智能代理池网关，可将多个代理订阅聚合为统一的 HTTP、SOCKS5 和反向代理入口，并提供健康检查、智能调度、会话保持和可观测性。

## 主要功能

- 导入 sing-box、Clash、URI、Base64 及纯文本代理订阅
- 提供 HTTP、SOCKS5 和 URL 反向代理入口
- 支持节点健康探测、熔断、智能调度和粘性会话
- 通过 WebUI 管理订阅、节点、平台、租约和请求日志
- 持久化状态、缓存、指标与请求日志

## 访问说明

- 安装后通过 `http://<服务器 IP>:<Web 端口>` 打开管理界面，并使用安装时生成的管理令牌登录。
- HTTP 和 SOCKS5 正向代理与管理界面共用容器内的 `2260` 端口；客户端使用安装时生成的代理令牌认证。
- 新安装固定使用 Resin `V1` 认证格式；HTTP 和 SOCKS5 代理用户名格式为 `平台.账户`，未指定时可使用 `Default`。
- WebUI 中新增自定义接入点时，还需要在 1Panel 编排中发布对应端口。Docker 无法为已经运行的容器动态增加端口映射。

## 安全说明

当前上游 `1.2.0` 镜像仍包含 Trivy 报告的 `CVE-2026-33186` Critical 漏洞以及若干 High 漏洞。本应用按维护者明确接受的安全例外提供，部署前应结合网络暴露范围评估风险，并在上游发布修复镜像后尽快升级。

## Introduction

Resin is a high-performance intelligent proxy pool gateway. It combines multiple proxy subscriptions behind unified HTTP, SOCKS5, and reverse-proxy entry points with health monitoring, smart routing, sticky sessions, and observability.

## Features

- Import sing-box, Clash, URI, Base64, and plain-text proxy subscriptions
- Serve HTTP, SOCKS5, and URL-based reverse proxy traffic
- Monitor node health and provide circuit breaking, smart scheduling, and sticky sessions
- Manage subscriptions, nodes, platforms, leases, and request logs through the WebUI
- Persist state, cache, metrics, and request logs

## Security Notice

The current upstream `1.2.0` image still contains the Trivy-reported Critical vulnerability `CVE-2026-33186` and several High vulnerabilities. This package is provided under an explicitly accepted maintainer exception. Review the exposure risk before deployment and upgrade when upstream publishes a fixed image.
