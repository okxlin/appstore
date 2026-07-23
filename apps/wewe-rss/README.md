# WeWe RSS

## 产品介绍

WeWe RSS 是用于生成微信公众号 RSS 订阅源的自托管服务。本仓库上游已归档，商店包继续保留用于现有部署，但不会加入自动更新白名单。

## 主要功能

- 登录并管理微信公众号订阅账号。
- 生成和定时更新 RSS 订阅源。
- MySQL 版本可通过 1Panel 数据库选择器复用现有 MySQL 应用。

## 访问说明

- 安装后通过表单配置的 HTTP 端口访问 Web 界面。
- MySQL 版本要求目标数据库应用已安装、运行，并与本应用加入 `1panel-network`。
- 上游项目已归档，部署前请评估维护与安全风险，并避免将服务直接暴露到不受信任的公网。

## Introduction

WeWe RSS is a self-hosted service that generates RSS feeds for WeChat official accounts. The upstream repository is archived, so this package is retained for existing deployments and is not eligible for automatic updates.

## Features

- Manage WeChat subscription accounts.
- Generate and periodically refresh RSS feeds.
- Reuse an existing MySQL app through the 1Panel database selector.

## 应用简介
更优雅的微信公众号订阅方式。

英文说明：A more elegant way to subscribe to WeChat.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`2.6.1`、`latest-mysql`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40332 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| DATABASE_TYPE | 数据库类型 | sqlite | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_PORT | 数据库端口 | 3306 | 是 |
| PANEL_DB_NAME | 数据库名 | wewe-rss | 是 |
| PANEL_DB_USER | 数据库用户 | wewe-rss | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | 随机生成 | 是 |
| AUTH_CODE | 授权码 | password | 是 |
| SERVER_ORIGIN_URL | 外部访问地址 | http://1.2.3.4:40332 | 是 |
| FEED_MODE | 提取模式 | fulltext | 否 |
| CRON_EXPRESSION | 定时更新表达式 | 35 5,17 * * * | 否 |
| MAX_REQUEST_PER_MINUTE | 每分钟最大请求次数 | 60 | 否 |

## 使用说明
### 账号状态说明

- 今日小黑屋

  > 账号被封控，等一天恢复
  > 如果账号正常，可以通过重启服务/容器清除小黑屋记录

- 禁用

  > 不使用该账号

- 失效
  > 账号登录状态失效，需要重新登录

## 参考资料
- 官网: <https://github.com/cooderl/wewe-rss>
