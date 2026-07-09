# NPC

## 应用简介
内网穿透代理服务器 NPS 的客户端。

英文说明：Intranet Penetrating Proxy Server NPS Client.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.27.01`。
- 上游 `v0.27.01` 镜像标签是较早构建；当前固定版本使用仍在更新的 `v0.26.x` 镜像维护线。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| NPS_SERVER_ADDR | NPS 服务端地址 | 1.2.3.4:8025 | 是 |
| NPS_VKEY | 服务端显示的客户端连接密钥 | xly7traGe3r0t6UWltristuh1 | 是 |
| TLS_ENABLE_SWITCH | 服务端与客户端的通信是否启用 TLS | true | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://ehang-io.github.io/nps>
- 源码: <https://github.com/yisier/nps>
