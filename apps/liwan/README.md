# Liwan

## 产品介绍

Liwan 是一个轻量、注重隐私的网站分析平台。它在单个容器中提供访问事件采集、实时统计和管理界面，并使用嵌入式数据库保存数据，无需额外部署数据库或缓存服务。

## 主要功能

- 无 Cookie 的页面访问和自定义事件采集
- 实时流量、来源、地理位置、设备和会话分析
- 多实体、多项目和用户权限管理
- 单容器部署，用户、项目、配置和分析数据统一保存在数据目录中

## 访问说明

- 首次启动后，从容器日志中的 `/setup?t=...` 地址进入初始化页面并创建管理员账户。
- 基础访问地址应填写浏览器实际使用的协议、域名和端口；通过反向代理访问时应填写外部 HTTPS 地址。
- 数据目录需要由 UID/GID `1000:1000` 写入。安装脚本会初始化新的空目录；已有目录请先确认其所有权。
- 卸载应用时保留数据目录，重新安装前请自行备份或清理不再需要的数据。

## Introduction

Liwan is a lightweight, privacy-focused web analytics platform. It combines event collection, real-time reports, an administration interface, and embedded storage in a single container.

## Features

- Cookie-free pageview and custom event collection
- Real-time traffic, referrer, location, device, and session reports
- Multiple entities and projects with user access control
- Persistent application and analytics state in one data directory

Open the setup URL shown in the container logs after the first start to create the administrator account. Keep the configured base URL aligned with the address used by browsers, and back up the complete data directory before upgrades.
