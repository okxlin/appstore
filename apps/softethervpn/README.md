# SoftEtherVPN

## 应用简介
开源多协议 VPN 软件。

英文说明：Open-source multi-protocol VPN software.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具、安全。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| VPN_PORT_53 | VPN 端口 53 | 53 | 是 |
| VPN_PORT_443 | VPN 端口 443 | 444 | 是 |
| VPN_PORT_992 | VPN 端口 992 | 992 | 是 |
| VPN_PORT_1194_UDP | VPN 端口 1194 (UDP) | 1194 | 是 |
| VPN_PORT_5555 | VPN 端口 5555 | 5555 | 是 |
| VPN_PORT_500_UDP | VPN 端口 500 (UDP) | 500 | 是 |
| VPN_PORT_4500_UDP | VPN 端口 4500 (UDP) | 4500 | 是 |
| VPN_PORT_1701_UDP | VPN 端口 1701 (UDP) | 1701 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SOFTETHER_DATA_PATH | SoftEther 数据路径 | ./data/softether_data | 是 |
| SOFTETHER_LOG_PATH | SoftEther 日志路径 | ./data/softether_log | 是 |
| SOFTETHER_PACKETLOG_PATH | SoftEther 数据包日志路径 | ./data/softether_packetlog | 是 |
| SOFTETHER_SECURITYLOG_PATH | SoftEther 安全日志路径 | ./data/softether_securitylog | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.softether.org>
- 文档: <https://www.softether.org/4-docs>
- 源码: <https://github.com/SoftEtherVPN/SoftEtherVPN>
