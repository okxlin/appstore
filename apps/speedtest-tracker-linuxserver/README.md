# Speedtest Tracker

## 应用简介
Speedtest Tracker 网速监测。

英文说明：Internet speed tracker maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.14.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_KEY | 应用密钥 | 安装时自动生成 | 是 |
| APP_URL | 应用访问 URL | - | 否 |
| DB_CONNECTION | 数据库连接 | sqlite | 是 |
| DB_HOST | 数据库主机 | - | 否 |
| DB_PORT | 数据库端口 | - | 否 |
| DB_DATABASE | 数据库名称 | - | 否 |
| DB_USERNAME | 数据库用户名 | - | 否 |
| DB_PASSWORD | 数据库密码 | - | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| DISPLAY_TIMEZONE | 显示时区 | Asia/Shanghai | 否 |
| SPEEDTEST_SCHEDULE | 测速计划 | 0 */6 * * * | 否 |
| SPEEDTEST_SERVERS | 测速服务器 ID | - | 否 |
| PRUNE_RESULTS_OLDER_THAN | 测速结果保留天数，0 表示不清理 | 0 | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 默认使用 SQLite 时，只需确认 `APP_KEY`、时区和数据目录；如切换到 MySQL/PostgreSQL，再补充对应数据库连接参数。
- 首次访问如果跳转到 `getting-started` 页面，按页面提示创建初始账户并完成测速计划设置即可。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://speedtest-tracker.dev/>
- 文档: <https://docs.linuxserver.io/images/docker-speedtest-tracker/>
- 源码: <https://github.com/linuxserver/docker-speedtest-tracker>
