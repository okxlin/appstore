# Hermes Dashboard

Hermes Dashboard 是 Hermes Agent 的可选附属应用，用来提供 Web Dashboard 界面。不安装它也不影响 Hermes gateway 正常工作。

## 应用内容

本产物默认安装一个容器：

- **hermes-dashboard**：Hermes Web Dashboard，默认命令为 `dashboard --host 0.0.0.0 --insecure`

其中：

- `9119`：Hermes Web Dashboard 端口
- `GATEWAY_HEALTH_URL`：指向已部署 Hermes gateway 的完整健康检查地址，例如 `http://172.18.0.240:8642`
- `DASHBOARD_RUN_COMMAND`：Dashboard 启动命令；若切到 `dashboard --host 0.0.0.0 --insecure`，即表示允许外部访问
- `/opt/data`：建议挂载到对应 Hermes gateway 使用的同一份数据目录，默认示例路径为 `/opt/1panel/apps/local/hermes-agent/hermes-agent/data`

## 安装前建议

安装本应用前，应先确保已经部署并运行了 `hermes-agent` 主应用，或其它可用的 Hermes gateway。若使用本地应用默认目录结构，建议把 `APP_DATA_DIR` 直接填写为 `/opt/1panel/apps/local/hermes-agent/hermes-agent/data`。

## 安全警告

`dashboard --host 0.0.0.0 --insecure` 会允许外部访问 Dashboard，同时暴露 API keys 与配置内容。这个模式只适合可信内网、临时调试，或你已经在前面加了自己的反向代理鉴权。若直接暴露到不可信网络，风险很高。

## 安装后访问

- Dashboard 地址：`http://服务器IP:面板里填写的 Dashboard 端口`

如果 dashboard 需要显示 gateway 在线状态，`GATEWAY_HEALTH_URL` 必须填写为可从 dashboard 容器访问到的完整 URL。默认命令已经是 `dashboard --host 0.0.0.0 --insecure`，这会暴露 API keys 与配置；只应在可信内网、临时调试，或已通过你自己的反向代理鉴权保护时使用。

## 持久化目录

建议将 `/opt/data` 指向与对应 Hermes gateway 相同的数据目录，以便 dashboard 读取本地配置、日志与会话数据。对当前拆分后的 1Panel 本地应用，推荐直接使用 `/opt/1panel/apps/local/hermes-agent/hermes-agent/data`。

## 多实例说明

多实例场景下，每个 dashboard 都应连接到各自 gateway 的独立 `GATEWAY_HEALTH_URL`。若 gateway 使用 1Panel 网络静态 IP，可直接填写类似 `http://172.18.0.240:8642` 的地址。

## 上游项目

- GitHub：https://github.com/NousResearch/hermes-agent
- 文档：https://hermes-agent.nousresearch.com/docs/
- Docker 文档：https://hermes-agent.nousresearch.com/docs/user-guide/docker
