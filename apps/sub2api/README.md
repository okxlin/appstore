# Sub2API

## 应用简介
提供 OpenAI 兼容接口的 AI 网关服务。

英文说明：AI gateway service with OpenAI-compatible APIs.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`0.1.138`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_PORT | 数据库端口 | 5432 | 是 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |
| PANEL_APP_PORT_HTTP | Web 访问端口 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR_1 | 应用数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | postgresql | 是 |
| PANEL_DB_NAME | 数据库名 | sub2api | 是 |
| PANEL_DB_USER | 数据库用户 | sub2api | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | - | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| REDIS_DB | Redis 数据库 | 0 | 是 |
| SERVER_MODE | 服务模式 | release | 是 |
| RUN_MODE | 运行模式 | standard | 是 |
| ADMIN_EMAIL | 管理员邮箱 | admin@sub2api.local | 是 |

## 使用说明
### 反向代理说明

如果你在 Nginx 后面反代 Sub2API，并且需要兼容 Codex CLI 等依赖下划线请求头的客户端，请在 Nginx 的 `http` 块中开启：

```nginx
underscores_in_headers on;
```

这是上游 README 明确提到的要求，否则某些带下划线的头部可能会被 Nginx 丢弃，影响会话粘性与部分 CLI 场景。

## 参考资料
- 官网: <https://github.com/Wei-Shaw/sub2api>
