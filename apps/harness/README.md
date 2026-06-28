# Harness Open Source

## 产品介绍
Harness Open Source 是开源开发者平台，提供代码托管、流水线、开发环境和制品仓库等能力。该项目是 Gitness 的后续形态。

## 主要功能
- Git 代码托管和 Web 管理界面
- Pull Request、用户和仓库管理
- 内置制品仓库能力
- 流水线和 Gitspaces 能力由上游提供，但本应用默认不暴露 Docker socket

## 访问说明
安装后通过 `http://<服务器 IP>:13080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Harness Open Source is an open source developer platform for code hosting, pipelines, developer environments and artifact registries. It is the successor of Gitness.

## Features
- Git code hosting and web UI
- Pull requests, users and repository management
- Built-in artifact registry support
- Pipeline and Gitspaces features exist upstream, but this app does not expose the Docker socket by default

## 部署说明
- 本应用使用官方 Docker 镜像 `harness/harness:3.3.0`。
- 应用分类：DevOps。
- 支持架构：amd64、arm64。
- 可选版本：`latest`，当前固定使用 `3.3.0` 镜像。
- 默认禁用 Gitspaces、指标上报以及内网/loopback webhook 访问。
- 默认不挂载 `/var/run/docker.sock`。需要 Docker runner、Gitspaces 或流水线容器执行能力时，请先评估宿主机 Docker socket 暴露风险。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 13080 | 是 |
| PANEL_APP_PORT_SSH | Git SSH 端口 | 13022 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Harness 数据、SQLite 数据库、Git 仓库和制品仓库存储目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PUBLIC_URL | 浏览器访问的公共基础地址 | http://localhost:13080 | 是 |
| SSH_PUBLIC_HOST | Git SSH 克隆地址使用的主机名 | localhost | 是 |
| ADMIN_EMAIL | 初始管理员邮箱 | admin@example.com | 是 |
| ADMIN_PASSWORD | 初始管理员密码 | 随机生成 | 是 |
| REGISTRY_HTTP_SECRET | 制品仓库上传会话密钥 | 随机生成 | 是 |

## 使用说明
- 首次安装时，系统会使用 `ADMIN_EMAIL` 和 `ADMIN_PASSWORD` 创建管理员账户。
- 如果已经存在数据目录，管理员自动创建参数不会覆盖已有用户。
- 对外使用域名或反向代理时，请同步修改 `PUBLIC_URL` 和 `SSH_PUBLIC_HOST`，否则页面内生成的链接可能仍指向默认地址。
- 由于上游升级可能包含数据库和仓库数据迁移，本应用未加入 Renovate 自动合并白名单。

## 参考资料
- 官网: <https://www.harness.io/open-source>
- 项目仓库: <https://github.com/harness/harness>
- Docker 镜像: <https://hub.docker.com/r/harness/harness>
- 文档: <https://developer.harness.io/docs/open-source>
