# Shiori

## 产品介绍
Shiori 是一个简洁的自托管书签管理器，可保存网页链接、抓取可读内容，并作为轻量的网页归档工具使用。

## 主要功能
- 管理书签和网页归档
- 支持离线保存网页可读内容
- 默认使用 SQLite，适合单实例自用部署

## 访问说明
安装后通过 `http://<服务器 IP>:8080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Shiori is a simple self-hosted bookmark and web archive manager.

## Features
- Manage bookmarks and archived web pages
- Save readable page content for offline use
- Use SQLite by default for single-instance deployments

## 部署说明
- 本应用使用官方 GitHub Container Registry 镜像 `ghcr.io/go-shiori/shiori` 部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、armv7。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Shiori Web 端口 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Shiori 数据目录，挂载到容器 `/srv/shiori` | ./data | 是 |

升级或迁移前，请先备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 本应用使用官方文档中的容器镜像和 SQLite 默认模式。
- SQLite 模式建议保持单实例运行，不适合多个副本同时写入。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 项目仓库: <https://github.com/go-shiori/shiori>
- 安装文档: <https://github.com/go-shiori/shiori/blob/master/docs/Installation.md>
