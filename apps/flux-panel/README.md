# Flux Panel

## 产品介绍

Flux Panel 是基于 GOST 的多节点 TCP/UDP 流量转发管理面板。

## 主要功能

- 管理端口转发与隧道转发。
- 配置用户和隧道配额、限速与流量计费。
- 通过独立节点程序接入多个转发节点。

## 访问说明

安装后通过表单配置的 Web 端口访问。默认管理员账号和密码均为 `admin_user`，首次登录后必须立即修改密码。

## 部署说明

- 首次安装会启动应用自带的 MySQL 5.7 服务并自动导入上游 `gost.sql`。
- 面板只开放 Web 端口；后端和数据库仅通过 1Panel Docker 网络访问。
- 数据库与后端日志保存在安装表单指定的数据目录中。
- 上游已声明项目暂停更新且恢复时间未定，本应用固定使用其稳定版 `1.4.3`，部署前请评估维护风险。

## 安全与使用风险

Flux Panel 能创建和管理网络转发规则。请仅用于获得授权的网络，并遵守当地法律、服务商条款和网络安全要求。弱密码、公开暴露管理端口或错误配置转发规则可能导致未授权访问、流量滥用和数据泄露。

上游项目：https://github.com/bqlpfy/flux-panel

## Introduction

Flux Panel is a GOST-based management panel for multi-node TCP and UDP traffic forwarding.

## Features

- Manage port forwarding and tunnel forwarding.
- Configure user and tunnel quotas, speed limits, and traffic accounting.
- Connect multiple forwarding nodes through the separate node program.

After installation, open the configured Web port. The default username and password are both `admin_user`; change the password immediately after the first login. Upstream has paused maintenance for an unspecified period, so assess the maintenance risk before deployment.
