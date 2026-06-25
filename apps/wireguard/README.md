# WireGuard

## 应用简介
一种极其简单但快速且现代的 VPN。

英文说明：An extremely simple yet fast and modern VPN.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具、安全。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.0.20250521`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_UDP | Wireguard 端口 | 51820 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| SERVERURL | 本机地址 (必改项) | 172.17.0.1 | 是 |
| PEERS | 客户端数量 | 1 | 是 |
| PEERDNS | 客户端 DNS | 119.29.29.29,1.1.1.1 | 是 |
| INTERNAL_SUBNET | 默认 Wireguard 网段子网 | 10.0.8.0 | 是 |
| ALLOWEDIPS | Wireguard 允许的 IP 段 | 10.0.8.0/24 | 是 |
| PERSISTENTKEEPALIVE_PEERS | Wireguard 保活间隔 | 25 | 是 |
| LOG_CONFS | 日志配置 | true | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.wireguard.com>
- 文档: <https://docs.linuxserver.io/images/docker-wireguard/>
- 源码: <https://github.com/linuxserver/docker-wireguard>
