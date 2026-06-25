# 哪吒监控 - Agent

## 应用简介
哪吒监控 - Agent。

英文说明：Nezha Monitoring - Agent.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.1.4`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| NZ_GRPC_URL | 哪吒 gRPC 地址 | - | 是 |
| NZ_CLENT_SECRET | 哪吒客户端密钥 | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://nezha.wiki>
- 文档: <https://nezha.wiki/guide/agent.html>
- 源码: <https://github.com/naiba/nezha>
