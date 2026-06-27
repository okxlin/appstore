# Qexo

## 产品介绍
Qexo 是一个快速、强大、美观的在线静态博客编辑器，可作为 Hexo 等静态博客的在线写作和管理后端。

## 主要功能
- 提供静态博客文章、页面和资源的在线编辑能力
- 支持通过 Git 与静态博客仓库协作
- 默认使用 SQLite 保存 Qexo 后端数据，适合轻量自托管部署

## 访问说明
安装后通过 `http://<服务器 IP>:15080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Qexo is a fast, powerful and beautiful online editor for static blogs, commonly used as a writing and management backend for Hexo-style sites.

## Features
- Online editing for static blog posts, pages and assets
- Works with Git-based static blog workflows
- Uses SQLite by default for lightweight self-hosted deployments

## 部署说明
- 本应用使用 Qexo 官方发布工作流推送的 Docker Hub 镜像 `abudulin/qexo` 部署。
- 应用分类：网站。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Qexo Web 访问端口，容器内映射到 `8000` | 15080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Qexo SQLite 数据目录，挂载到容器 `/app/db` | ./data | 是 |

升级、迁移或重新安装前，请先在 1Panel 中备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOMAINS | Django 允许访问域名，格式为 JSON 数组，例如 `["blog.example.com"]` | `["localhost","127.0.0.1"]` | 是 |
| WORKERS | Gunicorn worker 进程数 | 4 | 是 |
| THREADS | Gunicorn worker 线程数 | 4 | 是 |
| TIMEOUT | Gunicorn 请求超时时间，单位秒 | 600 | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 对公网开放或使用反向代理时，请把实际域名写入 `DOMAINS`，否则 Qexo 可能因 Host 校验拒绝访问。
- 首次进入 Qexo 后，请按上游文档配置静态博客仓库、部署方式和访问凭据。
- 如对公网开放访问，请同步检查防火墙、安全组、反向代理和 HTTPS 配置。

## 参考资料
- 项目仓库: <https://github.com/Qexo/Qexo>
- 官方文档: <https://oplog.cn/qexo/>
- Dockerfile: <https://github.com/Qexo/Qexo/blob/master/Dockerfile>
- Docker 镜像发布工作流: <https://github.com/Qexo/Qexo/blob/master/.github/workflows/docker-image-release.yml>
