# puff

## 应用简介
一个Go的域名监控程序。

英文说明：Go-based domain monitoring tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8080 | 是 |

## 数据持久化
- `/data/puff:/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 默认账号密码
- 账号：admin
- 密码：admin

## 参考资料
- 官网: <https://github.com/BitAUR/Puff>
- 文档: <https://roy.wang/puff/>
