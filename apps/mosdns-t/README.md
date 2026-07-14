# MosDNS-T

## 产品介绍

MosDNS-T 是基于 mosdns 持续维护的 DNS 分流增强版，提供重构后的 WebUI、规则维护、查询诊断和专属分流组。

## 主要功能

- 管理国内外 DNS 分流、缓存、白名单、灰名单和 DDNS 域名。
- 配置普通与专属上游、在线规则和本地规则。
- 支持 FakeIP 与 Redir-Host 场景，并提供查询日志和诊断界面。

## 访问说明

安装后通过表单配置的 WebUI 端口访问管理界面。DNS 服务同时监听表单配置端口的 TCP 和 UDP。

## 部署说明

- 空数据目录首次启动时会从上游官方配置地址自动初始化默认配置；部署环境需要能够访问 GitHub，否则请按上游文档预先准备配置目录。
- 默认配置可以直接解析常见国内域名。
- 国外域名分流通常依赖 sing-box、mihomo 或 FakeIP DNS 等伴生服务。安装后请在 WebUI 中把相关上游改为容器可访问的服务名、`host.docker.internal`、宿主机地址或局域网地址。
- bridge 模式中的 `127.0.0.1` 指向 MosDNS-T 容器本身，不代表宿主机。
- 数据目录保存配置、规则、缓存、生成列表和 WebUI 状态，升级前请备份。

## 安全与使用风险

DNS 服务通常面向局域网提供。请避免把递归 DNS 端口直接暴露到公网，否则可能被滥用于 DNS 放大攻击。在线配置和规则更新会访问上游项目配置的外部地址，请结合网络环境评估来源与可达性。

上游项目：https://github.com/jasonxtt/mosdns

## Introduction

MosDNS-T is a maintained mosdns fork with an enhanced WebUI for DNS routing, rules, diagnostics, and dedicated routing groups.

## Features

- Manage domestic and international DNS routing, caches, allowlists, greylists, and DDNS domains.
- Configure regular and dedicated upstreams, online rules, and local rules.
- Support FakeIP and Redir-Host workflows with query logs and diagnostics.

After installation, open the configured WebUI port. The DNS service listens on both TCP and UDP. International routing commonly requires a reachable sing-box, mihomo, or FakeIP DNS companion; configure it from the WebUI using a container-reachable address rather than `127.0.0.1` in bridge mode.
