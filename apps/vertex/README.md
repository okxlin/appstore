# Vertex

## 应用简介
适用于 PT 玩家的追剧刷流一体化综合管理工具。

英文说明：An all-in-one comprehensive management tool for PT players.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40197 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 账户密码
  - username：admin
  - password：通过查看`/opt/1panel/apps/local/vertex/vertex/data/data/password`获取，路径按需修改

## 参考资料
- 官网: <https://wiki.vertex.icu>
- 源码: <https://github.com/vertex-app/vertex>
