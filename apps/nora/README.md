## 产品介绍

**NORA** 是一个轻量级自托管制品仓库，可通过单个服务提供 Docker Registry v2、Raw、Maven、npm、PyPI、Cargo、Go Modules、NuGet 等软件包协议。

## 主要功能

- 通过内置 Web 界面浏览制品、活动记录和运行状态。
- 支持托管与代理缓存多种软件包格式。
- 使用本地持久化卷保存制品、索引、令牌和配置。
- 支持按需启用基本认证、OIDC、S3 存储、保留策略和制品治理。

## 访问说明

- 安装完成后，通过应用详情中的 Web 端口访问 `/ui/`。
- 默认关闭认证，以保持上游零配置行为。此时任何能访问端口的用户都可能上传、下载或删除制品，切勿将端口直接暴露到不可信网络。
- 对公网提供服务前，建议通过反向代理启用 HTTPS，并按照上游文档配置认证和正确的公共访问地址。
- `公共访问地址` 用于生成客户端链接。修改 Web 端口或使用域名时应同步修改该字段。

## 数据与升级

- NORA 将制品内容、索引、令牌和配置保存在 Docker 命名卷中。
- 应用限制为单实例，以避免多个实例争用同一命名卷。
- 升级前应备份 NORA 数据卷；卸载时是否删除命名卷由 1Panel 的卸载选项决定，应用脚本不会主动删除用户数据。
- `latest` 为浮动镜像，适合希望通过容器更新工具跟踪上游发布的用户；固定版本用于可重复部署。

## 默认工作流

在默认无认证模式下，可以通过 `PUT /raw/<路径>` 上传小文件，再通过相同地址下载并校验内容。该流程可用于确认上传、索引、下载和重启后的持久化均正常。

## 参考资料

- 官网：<https://getnora.dev>
- 项目仓库：<https://github.com/getnora-io/nora>
- 容器镜像：<https://github.com/getnora-io/nora/pkgs/container/nora>

## Introduction

NORA is a lightweight self-hosted artifact registry for container images and multiple software package formats.

## Features

- Host, browse, and proxy-cache artifacts from one service.
- Persist artifacts, indexes, tokens, and configuration in a named volume.
- Use the Raw endpoint for a simple upload and download workflow.
- Optionally configure authentication, object storage, retention, and curation through upstream settings.
