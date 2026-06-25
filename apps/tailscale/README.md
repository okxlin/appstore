# Tailscale

## 应用简介
使用 WireGuard 和 2FA 的最简单、最安全的方式。

英文说明：The easiest, most secure way to use WireGuard and 2FA.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.98`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TS_SOCKET | Tailscale Socket 路径 | /var/run/tailscale/tailscaled.sock | 否 |
| TS_STATE_DIR | Tailscale 状态目录 | /var/lib/tailscale | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TS_AUTHKEY | Tailscale 认证密钥 | tskey-auth-ab1CDE2CNTRL-0123456789abcdef | 是 |
| TS_ROUTES | 广播子网路由 | 192.168.1.0/24,10.0.0.0/16 | 是 |
| TS_ACCEPT_DNS | 是否接受 DNS 配置 (true/false) | false | 否 |
| TS_AUTH_ONCE | 尝试仅登录一次 (true/false) | false | 否 |
| TS_DEST_IP | 目标 IP | - | 否 |
| TS_KUBE_SECRET | Kubernetes 密钥名称 | tailscale | 否 |
| TS_HOSTNAME | 节点主机名 | my-tailscale-node | 否 |
| TS_OUTBOUND_HTTP_PROXY_LISTEN | HTTP代理地址和端口 (127.0.0.1:1081) | - | 否 |
| TS_SOCKS5_SERVER | SOCKS5代理地址和端口 (127.0.0.1:1080) | - | 否 |
| TS_USERSPACE | 启用用户空间网络 (true/false) | true | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://tailscale.com>
- 文档: <https://tailscale.com/kb/1017/install>
- 源码: <https://github.com/tailscale/tailscale>
