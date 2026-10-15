# Wavelog

## 产品介绍
开源业余无线电通联日志。

英文说明：Open-source amateur radio QSO logger.

## 主要功能
- 记录、查询和管理业余无线电通联日志。
- 通过官方 Web 安装器配置数据库和首个管理员。
- 独立持久化配置、上传文件和用户数据。

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、arm/v7。
- 当前仓库提供多个版本目录，安装时请以 1Panel 应用版本列表为准。
- 安装后按应用表单中的端口访问 Web UI。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 3792 | 是 |

## 数据持久化
- `./data/wavelog-config:/var/www/html/application/config/docker`
- `./data/wavelog-uploads:/var/www/html/uploads`
- `./data/wavelog-userdata:/var/www/html/userdata`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务，可选 1Panel 商店管理的 MariaDB 或 MySQL | mariadb | 是 |
| PANEL_DB_HOST | 由 1Panel service 选择器注入的数据库服务名 | - | 是 |
| PANEL_DB_PORT | 数据库端口 | 3306 | 是 |
| PANEL_DB_NAME | 数据库名 | wavelog | 是 |
| PANEL_DB_USER | 数据库用户 | wavelog | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | - | 是 |

## 访问说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 安装时先在表单中选择已经运行的 1Panel 商店 MariaDB 或 MySQL service。1Panel 会为本应用准备独立的数据库和用户；不要复用数据库管理员账号。
- 首次访问会进入官方 `/install/` 安装器。将应用表单生成的 `PANEL_DB_HOST`、`PANEL_DB_PORT`、`PANEL_DB_NAME`、`PANEL_DB_USER` 和 `PANEL_DB_USER_PASSWORD` 填入安装器，完成数据库检查、建表和首个管理员创建。
- 官方镜像不通过环境变量自动跳过安装器；升级或重建容器时应保留 `wavelog-config`、`wavelog-uploads`、`wavelog-userdata` 和外部数据库，并按上游迁移说明操作。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全提示
- 当前应用使用上游官方镜像 `ghcr.io/wavelog/wavelog`。官方镜像功能完整，但常见镜像扫描结果可能包含较多 High / Critical 级别漏洞条目，请结合自身暴露面评估风险。
- 建议仅在可信网络中部署，及时跟进上游镜像更新，并通过反向代理、访问控制和最小暴露原则降低风险。

## 参考资料
- 官网: <https://www.wavelog.org/>
- 文档: <https://docs.wavelog.org/>
- 源码: <https://github.com/wavelog/wavelog>

## Introduction
Wavelog is an open-source amateur radio QSO logger.

## Features
- Record, query, and manage amateur radio contact logs.
- Configure the database and first administrator through the official Web installer.
- Persist configuration, uploads, and user data in dedicated directories.
