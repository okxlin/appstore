# OxiDNS

## 产品介绍
OxiDNS 是一个高性能 DNS 策略编排引擎，支持 DNS 转发、缓存、规则匹配、查询记录、Prometheus 指标与内置 WebUI。

## 主要功能
- 同时提供 DNS 服务与管理 API / WebUI
- 支持自定义 `config.yaml` 持久化配置
- 支持 TCP/UDP DNS 监听与 HTTP 管理端口
- 默认内置 WebUI 和健康检查接口

## 访问说明
安装完成后访问：

```text
http://服务器IP:管理端口
```

DNS 服务默认监听 TCP / UDP 53 端口。安装后可直接编辑 `APP_CONFIG_DIR/config.yaml` 调整上游、规则和管理接口配置。

## 数据持久化
- `APP_CONFIG_DIR`：持久化 `config.yaml`，用于自定义运行配置

## Introduction
OxiDNS is a high-performance DNS policy orchestration engine with forwarding, caching, rule matching, query recording, Prometheus metrics, and a built-in WebUI.

## Features
- Serves both DNS traffic and the management API / WebUI
- Supports persistent custom `config.yaml`
- Exposes TCP/UDP DNS listeners and a separate HTTP management port
- Includes a built-in WebUI and health endpoints by default

## 参考资料
- 官网: <https://oxidns.org/>
- 快速开始: <https://oxidns.org/quickstart>
- 源码: <https://github.com/svenshi/oxidns>
