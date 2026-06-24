# Focalboard

## 应用简介
Trello，Notion 和 Asana 的开源自托管替代方案。

英文说明：An open source, self-hosted alternative to Trello, Notion, and Asana.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64。
- 可选版本：`latest`、`7.11.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40098 | 是 |

## 数据持久化
- `"./data/config.json:/opt/focalboard/config.json"   #sqlite`
- `fbdata:/opt/focalboard/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
默认以`SQLite`数据库模式运行，

需要以`postgres`数据库运行的，需要修改目录下的`postgres-config.json`里的数据库信息

且修改`docker-compose.yml`文件里的配置映射。

## 参考资料
- 官网: <https://www.focalboard.com/>
- 文档: <https://docs.mattermost.com/guides/boards.html>
- 源码: <https://github.com/mattermost/focalboard>
