# Duplicati

## 产品介绍
Duplicati 是一个支持加密备份的自托管工具，本应用使用 LinuxServer.io 镜像部署。

## 主要功能
- 通过 Web UI 创建和管理备份任务。
- 使用 `/config` 持久化配置数据库。
- 使用 `/backups` 保存本地备份，使用 `/source` 作为默认备份源目录。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Web UI，并使用表单中设置的 Web UI 密码登录。

## Introduction
Duplicati is a self-hosted encrypted backup tool. This app deploys the LinuxServer.io image.

## Features
- Create and manage backup jobs from the Web UI.
- Persist the configuration database under `/config`.
- Use `/backups` for local backups and `/source` as the default source folder.

## 应用简介
Duplicati 备份工具。

英文说明：Encrypted backup tool maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2.3.0`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8200 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| BACKUPS_PATH | 本地备份目录 | ./data/backups | 是 |
| SOURCE_PATH | 默认备份源目录 | ./data/source | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| SETTINGS_ENCRYPTION_KEY | 设置数据库加密密钥 | Duplicati2026Key | 是 |
| DUPLICATI_WEBSERVICE_PASSWORD | Web UI 密码 | 随机生成 | 是 |
| CLI_ARGS | 额外启动参数 | 空 | 否 |

## 使用说明
- `SETTINGS_ENCRYPTION_KEY` 官方要求至少 8 位字母数字，请妥善保存。
- 首次创建本地备份时，目标路径可选择 `/backups`，源路径可选择 `/source`。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.duplicati.com/>
- 文档: <https://docs.linuxserver.io/images/docker-duplicati/>
- 源码: <https://github.com/linuxserver/docker-duplicati>
