# Overleaf

## 产品介绍

Overleaf Community Edition 是一套在线 LaTeX 协作编辑服务，适合团队在浏览器中编写、管理和编译 LaTeX 项目。

## 主要功能

- 在线编辑 LaTeX 项目
- 多用户协作
- 浏览器内编译和预览 PDF
- MongoDB 和 Redis 数据持久化

## 访问说明

- 安装完成后访问 Web 端口。
- 首次访问 `/launchpad` 创建第一个管理员账号，然后进入 `/login` 登录。
- 本应用默认不启用 Server Pro、Git Bridge、TLS proxy 或 Sandboxed Compiles sibling containers，也不会挂载 Docker socket。
- Overleaf Community Edition 不提供用户级编译隔离；请只在可信用户环境中使用。

## Introduction

Overleaf Community Edition is a self-hosted collaborative LaTeX editor for writing, managing, and compiling LaTeX projects in a browser.

## Features

- Browser-based LaTeX editing
- Multi-user collaboration
- In-browser PDF compilation and preview
- Persistent MongoDB and Redis storage

## 使用说明

- 本应用跟随官方 Overleaf Toolkit 的 Community Edition 版本，并搭配 `mongo:8.0` 与 `redis:7.4`；实际 Overleaf 镜像版本以当前数字版本目录中的 Compose 配置为准。
- 内部 MongoDB 和 Redis 使用应用前缀服务名，避免主服务加入 `1panel-network` 时解析到其他应用的同名服务。
- 首次启动会通过 MongoDB healthcheck 幂等执行 replica set 初始化，避免 Overleaf 连接到未初始化的 `RSGhost` 节点。
- `OVERLEAF_INVITE_TOKEN_SECRET` 会在安装时随机生成，重装或迁移时应保持一致。
- 跨版本升级可能涉及 Overleaf 镜像、MongoDB 数据和迁移脚本，请先备份数据目录并参考官方 Toolkit 升级说明。

## 安全提示

- 官方 Community Edition 镜像的构建内容可能包含 Cypress 等开发工具缓存，镜像扫描会报告其中的可修复高危或严重漏洞；这些工具不属于正常 Web 服务运行路径，但仍会扩大镜像内容和潜在攻击面。
- Overleaf Community Edition 不提供用户级编译隔离。请仅向可信用户开放，限制公网访问，并及时跟进官方镜像和安全公告。

## 参数

| 参数 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 访问端口 | 18083 | 是 |
| TZ | 时区 | Asia/Shanghai | 是 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| OVERLEAF_APP_NAME | 站点名称 | Overleaf | 是 |
| EMAIL_CONFIRMATION_DISABLED | 是否禁用邮件确认 | true | 是 |
| OVERLEAF_INVITE_TOKEN_SECRET | 邀请令牌密钥 | 随机生成 | 是 |

## Links

- 官网: <https://www.overleaf.com/>
- 项目仓库: <https://github.com/overleaf/overleaf>
- Toolkit: <https://github.com/overleaf/toolkit>
- 官方快速开始: <https://github.com/overleaf/toolkit/blob/master/doc/quick-start-guide.md>
- 官方升级说明: <https://github.com/overleaf/toolkit/blob/master/doc/upgrading.md>
