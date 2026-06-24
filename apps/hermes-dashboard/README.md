# Hermes Dashboard

## 应用简介
Hermes Dashboard 附属应用。

英文说明：Optional web dashboard for Hermes Agent.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2026.6.19`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Dashboard 端口 | 9119 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIPS | 提示 | Hermes Dashboard 是附属应用。请先部署 Hermes gateway，并把 APP_DATA_DIR 指向 Hermes Agent 的同一份数据目录，再把 GATEWAY_HEALTH_URL 填成它的完整地址。容器默认不再以 root 身份运行，而是使用 HERMES_UID / HERMES_GID（默认 10000:10000）映射到宿主机数据目录。升级脚本会在旧 .env 缺失时自动补入这两个变量，并把 APP_DATA_DIR 现有目录权限迁移到对应 UID/GID；这里建议与 Hermes Agent 保持一致。默认命令就是不安全模式 `dashboard --host 0.0.0.0 --insecure`，会暴露 API keys 与配置。务必只在可信内网、临时调试，或已通过你自己的反向代理鉴权保护时使用。 | 是 |
| APP_DATA_DIR | 数据目录 | /opt/1panel/apps/local/hermes-agent/hermes-agent/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HERMES_UID | Hermes 运行用户 UID | 10000 | 是 |
| HERMES_GID | Hermes 运行用户 GID | 10000 | 是 |
| GATEWAY_HEALTH_URL | 网关健康检查 URL | http://172.18.0.240:8642 | 是 |
| DASHBOARD_RUN_COMMAND | Dashboard 启动命令 | dashboard --host 0.0.0.0 --insecure | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hermes-agent.nousresearch.com/docs/>
- 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/docker>
- 源码: <https://github.com/NousResearch/hermes-agent>
