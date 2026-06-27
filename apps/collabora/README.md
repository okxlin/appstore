# Collabora

## 产品介绍
Collabora Online Development Edition (CODE) 是基于 LibreOffice 技术的在线文档协作套件，可通过 WOPI 协议与 Nextcloud、ownCloud 等文件系统集成。

## 主要功能
- 在线编辑文本文档、表格和演示文稿
- 通过 WOPI 与 Nextcloud 等应用集成
- 提供管理控制台
- 支持按需配置允许访问的 WOPI 主机和拼写词典

## 访问说明
安装后通过 `http://<服务器 IP>:9980` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

用于 Nextcloud 集成时，请在 Nextcloud Office/Collabora 设置中填写 Collabora 的外部访问地址，并在本应用的 `WOPI_ALIAS_GROUP` 中填写允许访问的 Nextcloud 域名。

## Introduction
Collabora Online Development Edition (CODE) is an online office suite based on LibreOffice technology for WOPI integrations such as Nextcloud and ownCloud.

## Features
- Edit text documents, spreadsheets, and presentations online
- Integrate with Nextcloud and other WOPI applications
- Built-in admin console
- Configurable WOPI host allow list and dictionaries

## 部署说明
- 本应用使用官方 Docker 镜像 `collabora/code:latest` 部署。
- 默认使用 `--o:ssl.enable=false --o:ssl.termination=true`，容器内提供 HTTP，由外部反向代理或 1Panel 网站层处理 HTTPS。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 9980 | 是 |

## 数据持久化
本应用默认不挂载业务数据目录。升级或迁移前，请备份外部 WOPI 应用中的文档数据，并记录本应用安装参数。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ADMIN_USERNAME | 管理控制台用户名 | admin | 是 |
| ADMIN_PASSWORD | 管理控制台密码 | 随机生成 | 是 |
| WOPI_ALIAS_GROUP | 允许访问的 WOPI 主机，例如 `https://nextcloud.example.com:443` | 空 | 否 |
| SERVER_NAME | 外部访问域名，反代场景可设置为 Collabora 域名 | 空 | 否 |
| DICTIONARIES | 启用的拼写词典语言列表 | de_DE en_GB en_US es_ES fr_FR it nl pt_BR pt_PT ru | 是 |
| EXTRA_PARAMS | 传给 coolwsd 的额外启动参数 | --o:ssl.enable=false --o:ssl.termination=true | 是 |

## 使用说明
- 如果只用于自测，`WOPI_ALIAS_GROUP` 可以留空；正式接入 Nextcloud 时建议填写明确的 Nextcloud HTTPS 域名。
- 官方文档示例 `aliasgroup1=https://.*:443` 会允许所有 WOPI 主机连接，仅适合公开演示场景，不建议作为默认生产配置。
- 如需容器内自签 HTTPS，可调整 `EXTRA_PARAMS`，并同步修改反向代理和探活方式。

## 参考资料
- 官网: <https://www.collaboraonline.com/code/>
- 项目仓库: <https://github.com/CollaboraOnline/online>
- CODE Docker 文档: <https://sdk.collaboraonline.com/docs/installation/CODE_Docker_image.html>
- 官方 Docker 镜像: <https://hub.docker.com/r/collabora/code>
