# Chat Nio

## 应用简介
下一代 AI 一站式解决方案。

英文说明：Next Generation AI One-Stop Internationalization Solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40249 | 是 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |

## 数据持久化
- `./data/config:/config`
- `./data/logs:/logs`
- `./data/storage:/storage`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | chatnio | 是 |
| PANEL_DB_USER | 数据库用户 | chatnio | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | chatnio | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| REDIS_DB | Redis 数据库 | 5 | 是 |
| SERVE_STATIC | 是否启用静态文件服务 | true | 是 |

## 使用说明
部署成功后, 管理员账号为 `root` , 密码默认为 `chatnio123456`

## 参考资料
- 官网: <https://chatnio.com>
- 文档: <https://chatnio.com/guide>
- 源码: <https://github.com/Deeptrain-Community/chatnio>
