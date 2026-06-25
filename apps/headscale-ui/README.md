# Headscale-UI

## 应用简介
Headscale 与 Tailscale 兼容的协调服务器的 Web 前端。

英文说明：A web frontend for the headscale Tailscale-compatible coordination server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTPS | 端口 | 40182 | 是 |

## 使用说明
**Headscale 服务器地址，只能用经过域名反向代理的地址。**

## 参考资料
- 官网: <https://github.com/gurucomputing/headscale-ui>
