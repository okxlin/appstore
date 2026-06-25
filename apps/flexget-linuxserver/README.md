# FlexGet

## 产品介绍
FlexGet 是一个多用途自动化工具，本应用使用 LinuxServer.io 镜像部署。

## 主要功能
- 通过 Web UI 管理和查看自动化任务。
- 使用 `/config` 持久化配置、日志和数据库。
- 使用 `/data` 作为默认下载目录。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Web UI，并使用表单中设置的 Web UI 密码。

## Introduction
FlexGet is a multi-purpose automation tool. This app deploys the LinuxServer.io image.

## Features
- Manage and inspect automation tasks from the Web UI.
- Persist configuration, logs, and database files under `/config`.
- Use `/data` as the default downloads folder.

## 应用简介
FlexGet 自动化工具。

英文说明：Automation tool maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`3.19.25`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 5050 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DOWNLOADS_PATH | 下载目录路径 | ./data/downloads | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| FG_LOG_LEVEL | 日志级别 | info | 是 |
| FG_WEBUI_PASSWORD | Web UI 密码 | 随机生成 | 是 |

## 使用说明
- 默认配置文件路径为容器内 `/config/.flexget/config.yml`。
- 首次使用前请在配置目录中维护 FlexGet 任务配置。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://flexget.com/>
- 文档: <https://docs.linuxserver.io/images/docker-flexget/>
- 源码: <https://github.com/linuxserver/docker-flexget>
