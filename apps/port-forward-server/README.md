# Port-Forward-Server

## 应用简介
Go 语言开发的端口转发工具 (服务端)。

英文说明：Port forwarding tool developed in Go (Server).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`1.3.7`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 8080 | 是 |

## 数据持久化
- `"./data/data:/app/pfg/forward-server/data`
- `"./data/conf:/app/pfg/forward-server/conf`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 控制台：http://IP:Port/login

- 账户密码：
```
username：admin
password：123456
```

## 参考资料
- 官网: <https://gitee.com/tavenli/port-forward>
