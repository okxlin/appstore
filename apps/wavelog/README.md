## 产品介绍

**Wavelog** 是一个开源的业余无线电通联日志管理系统，业余无线电爱好者可以借助 Wavelog 管理通联记录，并与 QRZ.com、LoTW 等平台同步。

## 主要功能

* 自定义电台呼号、站点和位置，在云端记录日常通联
* 上传/下载 LoTW、QRZ.com 等平台的通联记录
* 支持通过 API 或网关与 GridTracker2 等业余无线电软件、硬件联动

## 访问说明

安装后访问 `http://<服务器 IP>:<Web 端口>/install/`，在安装向导中填写 1Panel 生成的数据库信息。官方容器采用首次访问安装向导写入配置的方式，1Panel 表单创建的 MariaDB/MySQL 数据库不会自动写入配置文件。

数据库信息对应关系：

* 数据库主机：安装表单中的数据库服务地址
* 数据库名：`PANEL_DB_NAME`
* 数据库用户：`PANEL_DB_USER`
* 数据库密码：`PANEL_DB_USER_PASSWORD`

Wavelog 官方推荐 MariaDB，MariaDB >= 10.2 或 MySQL >= 8。

安装完成后，网站 Base URL 会保存在 `./data/wavelog-config/config.php`。如果外网访问地址、反向代理域名或端口发生变化，请同步修改 `base_url`。

## 安全说明

本应用使用 Wavelog 官方镜像 `ghcr.io/wavelog/wavelog:2.2.1`。维护侧扫描该镜像时发现 Debian 运行时依赖仍存在较多 Critical/High CVE，其中部分已有上游修复版本但镜像尚未更新。该风险来自上游官方镜像基础系统包，介意风险的用户建议等待上游镜像更新后再部署，或仅在可信内网/反向代理鉴权后使用。

## Introduction

Wavelog is an open-source online contact logging system for amateur radio operators.

## Features

* Manage callsigns, stations, locations, and daily QSOs
* Import and export contacts with LoTW, QRZ.com, and related platforms
* Integrate with amateur-radio tools and gateways through API workflows
