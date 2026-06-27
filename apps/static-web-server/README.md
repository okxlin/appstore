# Static Web Server

## 产品介绍
Static Web Server 是用于静态文件服务的高性能 Web 服务器，适合托管静态网站、文档、构建产物和下载文件。

## 主要功能
- 提供静态文件 HTTP 服务
- 支持压缩、目录列表、健康检查和缓存相关能力
- 使用官方 v2 LTS Docker 镜像部署

## 访问说明
安装后通过 `http://<服务器 IP>:8787` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Static Web Server is a high-performance web server for static files.

## Features
- Serve static files over HTTP
- Support compression, directory listing, health checks and cache-related features
- Deploy with the official v2 LTS Docker image

## 部署说明
- 本应用使用官方 Docker 镜像 `joseluisq/static-web-server:2-alpine` 部署。
- 应用分类：Server。
- 支持架构：amd64、arm64、armv6、armv7。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 8787 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 静态文件目录，挂载到容器 `/var/public` | ./data | 是 |

安装后将静态文件放入 `APP_DATA_DIR`。升级或迁移前，请先备份该目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SERVER_LOG_LEVEL | 日志级别 | info | 是 |
| SERVER_DIRECTORY_LISTING | 是否启用目录列表 | false | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 首次安装会在静态文件目录中创建一个默认 `index.html`，已有文件不会被覆盖。
- 挂载目录以只读方式提供给容器；请在 1Panel 文件管理或主机目录中维护站点文件。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://static-web-server.net/>
- 项目仓库: <https://github.com/static-web-server/static-web-server>
- v2 Docker 文档: <https://github.com/static-web-server/docs/blob/master/src/v2/features/docker.md>
