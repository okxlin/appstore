# ATVLoadly

## 应用简介
轻松将 IPA 侧载到 AppleTV。

英文说明：Easily sideload the IPA to AppleTV.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具、媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`0.4.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40338 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| DBUS_PATH | DBus 路径 | /var/run/dbus | 是 |
| AVAHI_DAEMON_PATH | Avahi Daemon 路径 | /var/run/avahi-daemon | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PRIVILEGED_MODE | 特权模式开关 | true | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/bitxeno/atvloadly>
