# frpc-frp 客户端

## 应用简介
frp 是一种反向代理工具，常用于内网穿透(客户端)。

英文说明：frp is a reverse proxy tool that is commonly used for intranet penetration(Client).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.69.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 (由配置文件决定) | 6000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_FILE_PATH | 配置文件路径 | ./data/frpc.toml | 是 |
| SSL_FOLDER_PATH | 证书文件夹路径 (对应容器内 "/etc/frp/ssl") | ./data/ssl | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/fatedier/frp>
- 文档: <https://github.com/fatedier/frp/blob/dev/README_zh.md>
