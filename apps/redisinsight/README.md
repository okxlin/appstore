# RedisInsight

## 应用简介
Redis 图形管理工具。

英文说明：Redis graphical management tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`、`3.6.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40274 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| RI_SERVER_TLS_KEY | TLS 密钥路径 | - | 否 |
| RI_SERVER_TLS_CERT | TLS 证书路径 | - | 否 |
| RI_PROXY_PATH | 代理路径 | - | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| RI_APP_HOST | 应用主机 | 0.0.0.0 | 是 |
| RI_ENCRYPTION_KEY | 加密密钥 | - | 否 |
| RI_LOG_LEVEL | 日志级别 | info | 是 |
| RI_FILES_LOGGER | 文件日志 | true | 否 |
| RI_STDOUT_LOGGER | 标准输出日志 | true | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://redis.com/redis-enterprise/redis-insight/>
- 文档: <https://docs.redis.com/latest/ri/>
- 源码: <https://github.com/RedisInsight/RedisInsight>
