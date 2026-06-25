# sub2clash

## 应用简介
将节点和订阅转换为 clash(meta) 配置。

英文说明：Converting nodes and subscriptions to clash(meta) configuration.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.1.0-alpha.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40223 | 是 |

## 数据持久化
- `./data/logs:/app/logs`
- `./data/templates:/app/templates`
- `./data/data:/app/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| META_TEMPLATE | 默认 meta 模板文件名 | template_meta.yaml | 是 |
| PROXY_TEMPLATE | 默认 clash 模板文件名 | template_clash.yaml | 是 |
| CLASH_TEMPLATE | 默认 clash 模板文件名 | template_clash.yaml | 是 |
| REQUEST_RETRY_TIMES | Get 请求重试次数 | 3 | 是 |
| REQUEST_MAX_FILE_SIZE | Get 请求订阅文件最大大小（byte） | 1048576 | 是 |
| CACHE_EXPIRE | 订阅缓存时间（秒） | 300 | 是 |
| LOG_LEVEL | 日志等级 | info | 是 |
| SHORT_LINK_LENGTH | 短链长度 | 6 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.nite07.com/sub>
- 文档: <https://github.com/nitezs/sub2clash>
