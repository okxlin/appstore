# 哪吒监控 - Dashboard

## 应用简介
哪吒监控 - Dashboard。

英文说明：Nezha Monitoring - Dashboard.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`0.20.13`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40308 | 是 |
| PANEL_APP_PORT_GRPC | GRPC 端口 | 5555 | 是 |

## 数据持久化
- `./data:/dashboard/data`
- `./config.yaml:/dashboard/data/config.yaml`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
可以通过编辑目录下的配置文件来修改一些配置。
例如：
```
/opt/1panel/apps/local/nezha-dashboard/nezha-dashboard/config.yaml
```

## 参考资料
- 官网: <https://nezha.wiki>
- 文档: <https://nezha.wiki/guide/dashboard.html>
- 源码: <https://github.com/naiba/nezha>
