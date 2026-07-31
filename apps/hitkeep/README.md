# HitKeep

## 产品介绍

HitKeep 是一个注重隐私的网站与产品分析平台。它将仪表盘、DuckDB 存储和事件队列整合在单个容器中，不需要额外部署数据库或缓存服务。

## 主要功能

- 无 Cookie 的页面访问、访客、事件、转化和渠道分析
- 多站点仪表盘、目标、漏斗、UTM 与 Web Vitals 报表
- 团队权限、共享链接、API 客户端和只读 MCP 接口
- 内置 DuckDB，数据、归档与备份统一保存在配置的数据目录中

## 访问说明

- 安装后通过配置的端口打开 HitKeep，并创建首个管理员账户。
- 公开访问地址必须与浏览器实际使用的协议、域名和端口一致；通过反向代理访问时建议填写 HTTPS 地址。
- JWT 密钥用于会话签名，升级或重启时必须保持不变。

## Introduction

HitKeep is a privacy-first web and product analytics platform that combines its dashboard, DuckDB storage, and event queue in a single container.

## Features

- Cookie-free pageview, visitor, event, conversion, and acquisition analytics
- Multi-site dashboards, goals, funnels, UTM reporting, and Web Vitals
- Team permissions, share links, API clients, and a read-only MCP endpoint
- Persistent embedded storage without a separate database or cache service
