# Readeck

## 产品介绍
Readeck 是一个自托管稍后阅读应用，用于保存网页正文、图片和收藏内容，并支持浏览器扩展与移动端同步。

## 主要功能
- 保存网页内容并保留可读正文
- 管理收藏、集合和稍后阅读内容
- 支持浏览器扩展和移动端应用同步

## 访问说明
安装后通过 `http://<服务器 IP>:13801` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Readeck is a self-hosted read-it-later app for saving web content.

## Features
- Save web pages and readable article content
- Organize bookmarks, collections and read-it-later items
- Work with browser extensions and mobile applications

## 部署说明
- 本应用使用官方容器镜像 `codeberg.org/readeck/readeck` 部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 13801 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Readeck 数据目录，包含 SQLite 数据库、配置和保存内容 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- Readeck 官方文档建议多数安装使用 SQLite，本应用按单容器 SQLite 模式部署。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://readeck.org/en/>
- 项目仓库: <https://codeberg.org/readeck/readeck>
- 容器使用说明: <https://codeberg.org/readeck/readeck/src/branch/main/README.md#container>
