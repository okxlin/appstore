# AdGuardHome

## 应用简介
自由且开源的，功能强大的网络广告和跟踪器屏蔽DNS服务器。

英文说明：Free and open source, powerful network-wide ads & trackers blocking DNS server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：安全。
- 支持架构：amd64。
- 可选版本：`latest`、`0.107.77`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PLAIN_DNS_PORT | 普通DNS端口 | 20053 | 是 |
| DHCP_PORT1 | DHCP服务端口1 | 20067 | 是 |
| DHCP_PORT2 | DHCP服务端口2 | 20068 | 是 |
| HTTP_PORT | HTTP网页端口 | 23000 | 是 |
| PANEL_APP_PORT_HTTP | 初始设置网页端口 | 23001 | 是 |
| DOH_PORT | DOH服务端口 | 20443 | 是 |
| DOT_PORT | DOT服务端口 | 853 | 是 |
| QUIC_PORT1 | QUIC服务端口1 | 20784 | 是 |
| QUIC_PORT2 | QUIC服务端口2 | 8853 | 是 |
| DNS_CRYPT_PORT | DNS Crypt服务端口 | 5443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| WORK_PATH | 工作数据文件夹路径 | ./data/work | 是 |
| CONFIG_PATH | 配置文件夹路径 | ./data/conf | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hub.docker.com/r/adguard/adguardhome>
- 文档: <https://github.com/AdguardTeam/AdGuardHome/wiki>
- 源码: <https://github.com/AdguardTeam/AdGuardHome>
