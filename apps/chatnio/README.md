# Chat Nio

## 产品介绍

Chat Nio 是面向多模型与多供应商的开源 AI 平台，提供统一聊天入口、模型路由、计费和管理能力。

## 主要功能

- 统一接入多种大语言模型和供应商。
- 提供聊天、管理、用量统计和计费能力。
- 通过 1Panel 服务选择器复用现有 MySQL 与 Redis 应用。

## 访问说明

- 安装后通过表单配置的 HTTP 端口访问 Web 界面。
- 首次登录的默认管理员账号为 `root`，默认密码为 `chatnio123456`；请立即修改密码。
- MySQL 与 Redis 必须已安装、运行，并与本应用加入 `1panel-network`。

## Introduction

Chat Nio is an open source AI platform that provides a unified chat experience, model routing, usage management, and billing across multiple model providers.

## Features

- Unified access to multiple LLMs and providers.
- Chat, administration, usage reporting, and billing features.
- Existing MySQL and Redis apps can be reused through 1Panel service selectors.

## 应用简介
下一代 AI 一站式解决方案。

英文说明：Next Generation AI One-Stop Internationalization Solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40249 | 是 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |

## 数据持久化
- `./data/config:/config`
- `./data/logs:/logs`
- `./data/storage:/storage`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | chatnio | 是 |
| PANEL_DB_USER | 数据库用户 | chatnio | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | chatnio | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| REDIS_DB | Redis 数据库 | 5 | 是 |
| SERVE_STATIC | 是否启用静态文件服务 | true | 是 |

## 使用说明
部署成功后, 管理员账号为 `root` , 密码默认为 `chatnio123456`

## 参考资料
- 官网: <https://chatnio.com>
- 文档: <https://chatnio.com/guide>
- 源码: <https://github.com/Deeptrain-Community/chatnio>
