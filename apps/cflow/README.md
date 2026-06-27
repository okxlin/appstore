# CFlow

## 产品介绍
CFlow 是基于 Memos 0.18.2 魔改的个人知识流工具，强化了编辑器、标签、搜索、热力图、资源管理和双链等个人知识管理体验。

## 主要功能
- 基于 Memos 的轻量笔记和卡片管理
- 编辑器增强、列表操作优化和快捷输入
- 标签、搜索、双链、热力图和资源库增强
- SQLite 数据持久化

## 访问说明
安装后通过 `http://<服务器 IP>:5230` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
CFlow is a personal knowledge-flow tool based on a modified Memos 0.18.2 build.

## Features
- Lightweight note and card management based on Memos
- Enhanced editor, list operations, and quick input
- Improved tags, search, backlinks, heatmaps, and resource management
- SQLite-backed persistence

## 部署说明
- 本应用使用上游 README 中发布的 Docker Hub 镜像 `vespa314/cflow:latest` 部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 5230 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | CFlow 数据目录，映射到容器内 `/var/opt/memos` | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 上游 README 说明本仓库只包含 CFlow 架构中的 Memos 主站部分。
- AI、Wallabag、Artalk、相似度计算、自研后端等依赖外部服务的功能，当前开源镜像不包含完整后端能力。
- 上游说明该版本主要按 SQLite 场景使用，迁移前请完整备份数据目录。

## 参考资料
- 项目仓库: <https://github.com/Vespa314/cflow>
- Docker Hub 使用说明: <https://github.com/Vespa314/cflow#dockerhub>
- Dockerfile: <https://github.com/Vespa314/cflow/blob/main/Dockerfile>
- Docker compose: <https://github.com/Vespa314/cflow/blob/main/docker-compose.yaml>
