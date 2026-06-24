# NPS

## 应用简介
轻量级、高性能、功能强大的内网穿透代理服务器。

英文说明：Lightweight, high-performance, powerful intranet penetration proxy server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.27.01`、`bridge-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | web 管理端口 | 40209 | 是 |
| NPS_BRIDGE_PORT | 服务端客户端通信端口 | 8024 | 是 |
| NPS_BRIDGE_TLS_PORT | 服务端客户端 TLS 通信端口 | 8025 | 是 |
| NPS_HTTP_PROXY_PORT | 域名代理 http 代理监听端口 | 50080 | 是 |
| NPS_HTTPS_PROXY_PORT | 域名代理 https 代理监听端口 | 50443 | 是 |

## 数据持久化
- `./conf:/conf`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TLS_ENABLE_SWITCH | 服务端与客户端的通信是否启用 TLS | true | 是 |
| NPS_WEB_HOST | 外部访问地址(若默认地址请替换 localhost 为当前服务 IP) | http://localhost:40209 | 是 |
| NPS_WEB_USERNAME | web 界面管理账号 | admin | 是 |
| NPS_WEB_PASSWORD | web 界面管理密码 | 123 | 是 |
| NPS_WEB_OPEN_SSL | web 界面开启 https 访问 | false | 是 |
| NPS_PUBLIC_VKEY | 客户端以配置文件模式启动时的密钥 | xly7traGe3r0t6UWltristuh1 | 是 |
| NPS_AUTH_CRYPT_KEY | 16 位 AES 加密密钥 | gl8r0tujikih7br5 | 是 |
| NPS_HTTP_PROXY_IP | 域名代理 http 代理监听地址 | 0.0.0.0 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://ehang-io.github.io/nps>
- 源码: <https://github.com/yisier/nps>
