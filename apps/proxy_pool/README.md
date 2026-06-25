# ProxyPool

## 应用简介
爬虫代理 IP 池。

英文说明：Python ProxyPool for web spider.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40264 | 是 |
| REDIS_PORT | Redis 端口 | 6379 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REDIS_HOST | Redis 主机 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 否 |
| REDIS_DB_NUMBER | Redis 数据库编号 | 7 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://proxy-pool.readthedocs.io>
- 源码: <https://github.com/jhao104/proxy_pool>
