# PerfreeBlog

## 产品介绍

PerfreeBlog 是基于 Java 的开源博客与 CMS 建站平台，支持主题、插件和内容管理。

## 主要功能

- 博客文章与站点内容管理。
- 主题和插件扩展。
- 通过 1Panel 数据库选择器复用现有 MySQL 应用。

## 访问说明

- 安装后通过表单配置的 HTTP 端口访问 Web 界面。
- 目标 MySQL 应用必须已安装、运行，并与本应用加入 `1panel-network`。
- 首次启动会连接所选数据库并初始化应用数据，请先确认数据库名称、用户、密码和端口正确。

## Introduction

PerfreeBlog is an open source Java-based blog and CMS platform with content management, themes, and plugins.

## Features

- Blog posts and site content management.
- Theme and plugin extensions.
- Reuse an existing MySQL app through the 1Panel database selector.

## 应用简介
开源的博客/CMS 建站工具。

英文说明：open source blog/CMS website builder.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`4.0.11`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40337 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_PORT | 数据库端口 | 3306 | 是 |
| PANEL_DB_NAME | 数据库名 | perfree | 是 |
| PANEL_DB_USER | 数据库用户 | perfree | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | perfree | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://perfree.org.cn/>
- 文档: <https://perfree.org.cn/useDocs/>
- 源码: <https://github.com/PerfreeBlog/PerfreeBlog>
