# Palworld Dedicated Server (幻兽帕鲁)

## 应用简介
幻兽帕鲁服务端。

英文说明：Palworld Dedicated Server (幻兽帕鲁).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：游戏。
- 支持架构：amd64。
- 可选版本：`latest`、`2.4.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8211 | 是 |
| PANEL_APP_PORT_RCON | RCON 端口 | 25575 | 是 |
| PANEL_APP_PORT_QUERY | Query 端口 (用于与 Steam 服务器通信的查询端口) | 27015 | 是 |
| MAX_PLAYERS | 玩家数量限制 | 32 | 是 |
| PANEL_APP_PORT_PUBLIC | 服务器端口 (留空自动检测) | - | 否 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MULTITHREAD_SWITCH | 是否启用 CPU 多线程优化 (true / false) | true | 是 |
| PUBLIC_SWITCH | 是否将服务器设置为社区服务器 (true / false) | false | 是 |
| PUBLIC_IP | 服务器 IP (留空自动检测) | - | 否 |
| UPDATE_SWITCH | 是否每次启动都更新服务器 (true / false) | true | 是 |
| SERVER_NAME | 服务器名 | Default Palworld Server | 是 |
| ADMIN_PASSWORD | 管理员密码 | palworld | 否 |
| SERVER_PASSWORD | 服务器密码 | - | 否 |
| RCON_SWITCH | 是否启用 RCON (true / false) | false | 是 |

## 使用说明
**镜像标签版本是不同的，不可以覆盖**

- `latest`是下载了整合包，镜像体积比较大。
- 数字版本的是安装好了会自动在线下载所需内容的。

## 参考资料
- 官网: <https://hub.docker.com/r/kagurazakanyaa/palworld>
- 文档: <https://github.com/KagurazakaNyaa/palworld-docker>
