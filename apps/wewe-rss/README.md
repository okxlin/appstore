# WeWe RSS

## 应用简介
更优雅的微信公众号订阅方式。

英文说明：A more elegant way to subscribe to WeChat.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`2.6.1`、`latest-mysql`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40332 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| DATABASE_TYPE | 数据库类型 | sqlite | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AUTH_CODE | 授权码 | password | 是 |
| SERVER_ORIGIN_URL | 外部访问地址 | http://1.2.3.4:40332 | 是 |
| FEED_MODE | 提取模式 | fulltext | 否 |
| CRON_EXPRESSION | 定时更新表达式 | 35 5,17 * * * | 否 |
| MAX_REQUEST_PER_MINUTE | 每分钟最大请求次数 | 60 | 否 |

## 使用说明
### 账号状态说明

- 今日小黑屋

  > 账号被封控，等一天恢复
  > 如果账号正常，可以通过重启服务/容器清除小黑屋记录

- 禁用

  > 不使用该账号

- 失效
  > 账号登录状态失效，需要重新登录

## 参考资料
- 官网: <https://github.com/cooderl/wewe-rss>
