# Grafana

## 应用简介
用于监控和可观察性的开源平台。

英文说明：The open-source platform for monitoring and observability.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`13.0.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40038 | 是 |

## 数据持久化
- `./data:/var/lib/grafana`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
默认账户与密码
```
username:admin
password:admin
```

## 参考资料
- 官网: <https://grafana.com/>
- 文档: <https://grafana.com/docs/grafana>
- 源码: <https://github.com/grafana/grafana>
