# Zabbix-Agent

## 应用简介
实时监控 IT 组件和服务(监控端)。

英文说明：Real-time monitoring of IT components and services (Agent).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`6.4.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 10050 | 是 |
| ZABBIX_SERVER_PORT | Zabbix服务端端口 | 10051 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOSTNAME | 本机主机名 | 127.0.0.1 | 是 |
| ZABBIX_SERVER | Zabbix服务端 | 192.168.8.8 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.zabbix.com/>
- 文档: <https://www.zabbix.com/manuals>
- 源码: <https://github.com/zabbix/zabbix>
