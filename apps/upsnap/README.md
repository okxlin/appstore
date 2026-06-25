# UpSnap

## 应用简介
一个简单的唤醒网络应用程序。

英文说明：A simple wake on lan web app.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、armv7、armv6。
- 可选版本：`latest`、`5.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40318 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| UPSNAP_WEBSITE_TITLE | 网站标题 | Upsnap Dashboard | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LISTEN_ADDR | 监听地址 | 0.0.0.0 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| UPSNAP_INTERVAL | 扫描间隔 | @every 10s | 是 |
| UPSNAP_SCAN_RANGE | 扫描网段范围 | 192.168.1.0/24 | 是 |
| UPSNAP_SCAN_TIMEOUT | 扫描超时 | 500ms | 是 |
| UPSNAP_PING_PRIVILEGED | 使用特权权限进行 Ping | true | 是 |
| DNS_SERVER_1 | DNS 服务器 1 | 119.29.29.29 | 是 |
| DNS_SERVER_2 | DNS 服务器 2 | 223.5.5.5 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/seriousm4x/UpSnap>
