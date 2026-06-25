# Prometheus

## 应用简介
一个系统和服务监控系统。

英文说明：A systems and service monitoring system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.12.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40039 | 是 |

## 数据持久化
- `"./data:/etc/prometheus`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
需要按需配置应用目录下`data`文件夹里的`prometheus.yml`，以自定义更多功能。

## 参考资料
- 官网: <https://prometheus.io/>
- 文档: <https://prometheus.io/docs/>
- 源码: <https://github.com/prometheus/prometheus>
