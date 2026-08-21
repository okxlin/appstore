# CLIProxyAPI

## 产品介绍

CLIProxyAPI 为命令行工具提供 OpenAI 兼容的 API 代理接口。

## 主要功能

- 提供多个兼容 API 端口。
- 持久化配置、认证信息和运行日志。

## 应用简介
一个为 CLI 提供 OpenAI 等兼容 API 接口的代理服务器。

英文说明：A proxy server providing OpenAI-compatible API interfaces for CLI.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`7.2.117`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 访问端口 (8317) | 8317 | 是 |
| PANEL_APP_PORT_8085 | 端口 8085 | 8085 | 是 |
| PANEL_APP_PORT_1455 | 端口 1455 | 1455 | 是 |
| PANEL_APP_PORT_54545 | 端口 54545 | 54545 | 是 |
| PANEL_APP_PORT_51121 | 端口 51121 | 51121 | 是 |
| PANEL_APP_PORT_11451 | 端口 11451 | 11451 | 是 |

## 数据持久化
- `./data/config.yaml:/CLIProxyAPI/config.yaml`
- `./data/auths:/root/.cli-proxy-api`
- `./data/logs:/CLIProxyAPI/logs`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 升级兼容

从旧版本升级时，`scripts/upgrade.sh` 会把旧的 `CLI_PROXY_PORT_8085`、
`CLI_PROXY_PORT_1455`、`CLI_PROXY_PORT_54545`、`CLI_PROXY_PORT_51121` 和
`CLI_PROXY_PORT_11451` 迁移为对应的 `PANEL_APP_PORT_*` 变量。已有自定义端口优先保留，
缺失或空值才使用默认端口；重复执行升级不会覆盖新的自定义值。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DEPLOY | 部署环境变量 | - | 否 |

## 使用说明

## 访问说明

安装完成后，通过面板中配置的 `PANEL_APP_PORT_HTTP` 访问 Web 服务；其他端口用于对应的兼容 API 接口。

### 数据配置说明
安装本应用后，相关数据和日志挂载在 1Panel 应用安装目录下的 `data` 文件夹中。
- `config.yaml`: 配置文件
- `auths`: 认证信息缓存目录
- `logs`: 运行日志目录

## Introduction

CLIProxyAPI provides OpenAI-compatible API endpoints for command-line clients.

## Features

- Multiple compatible API endpoints.
- Persistent configuration, authentication, and log storage.

## 参考资料
- 官网: <https://help.router-for.me/>
- 源码: <https://github.com/router-for-me/CLIProxyAPI>
