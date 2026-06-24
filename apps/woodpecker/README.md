# Woodpecker CI

## 应用简介
具有极强可扩展性的简单 CI 引擎。

英文说明：A simple CI engine with great extensibility.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64。
- 可选版本：`latest`、`3.15.0`、`mysql-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40122 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REGISTER_SWITCH | 启用注册(true/false) | false | 是 |
| WOODPECKER_HOST | 外部访问地址 | http://ci.example.com | 是 |
| WOODPECKER_AGENT_SECRET | Github Agent Secret 值 | - | 是 |
| GITHUB_ENABLE_SWITCH | 启用Github(true/false) | true | 是 |
| WOODPECKER_GITHUB_URL | Github地址 | https://github.com | 否 |
| WOODPECKER_GITHUB_CLIENT | Github CLIENT 值 | - | 否 |
| WOODPECKER_GITHUB_SECRET | Github SECRET 值 | - | 否 |
| GITEA_ENABLE_SWITCH | 启用Gitea(true/false) | false | 是 |
| WOODPECKER_GITEA_URL | Gitea地址 | https://try.gitea.io | 否 |
| WOODPECKER_GITEA_CLIENT | Gitea CLIENT 值 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://woodpecker-ci.org>
- 文档: <https://woodpecker-ci.org/docs/intro>
- 源码: <https://github.com/woodpecker-ci/woodpecker>
