# Dashy

## 产品介绍
Dashy 是一个可自行托管的个人仪表板，可集中展示常用服务、状态信息和快捷入口。

## 主要功能
- 通过 YAML 配置仪表板页面、分组和快捷入口
- 支持图标、自定义主题、搜索和状态检查
- 支持基础认证、OIDC 等可选访问控制方式
- 配置文件和自定义图标保存在本地持久化目录

## 访问说明
安装完成后，通过 1Panel 显示的 Web 端口访问 Dashy。首次启动会读取 `data/user-data/conf.yml`，可在该文件中维护仪表板配置。

## Introduction
Dashy is a self-hosted personal dashboard for organizing service links, status information, and frequently used resources.

## Features
- YAML-based dashboard, section, and shortcut configuration
- Icons, themes, search, and service status checks
- Optional access control such as basic authentication and OIDC
- Persistent local storage for configuration and custom icons

## 部署说明
- 本应用使用单容器 Docker Compose 部署。
- Web 端口由 `PANEL_APP_PORT_HTTP` 配置。
- 容器以 UID/GID `1000` 运行，生命周期脚本会创建持久化路径并修正权限。

## 数据持久化
| 路径 | 说明 |
| --- | --- |
| `./data/user-data/conf.yml` | Dashy 主配置文件 |
| `./data/item-icons` | 自定义图标目录 |

升级或迁移前，请在 1Panel 中备份 `data` 目录。

## 参考资料
- 官网: <https://dashy.to>
- 文档: <https://dashy.to/docs>
- 源码: <https://github.com/Lissy93/dashy>
