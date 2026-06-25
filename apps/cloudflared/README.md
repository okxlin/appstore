# cloudflared

## 应用简介
Cloudflare Tunnel 客户端。

英文说明：Client for Cloudflare Tunnel.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2026.6.1`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CFD_TOKEN | Token | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/>
- 源码: <https://github.com/cloudflare/cloudflared>
