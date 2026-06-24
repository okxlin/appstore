# MyNodeQuery

## 应用简介
一款简洁好用的探针。

英文说明：A simple and easy-to-use probe.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.0.6.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40102 | 是 |

## 数据持久化
- `./data/appsettings.json:/app/appsettings.json`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 实际只有容器镜像，**并没有开源，使用需要慎重**。

- 每个版本升级，作者可能都要对数据库做修改，所以没事不要升级。保证按要求修改了数据库再升级。

- MySQL 5.7 或更高版本

## 参考资料
- 官网: <https://hub.docker.com/r/jaydenlee2019/mynodequery>
