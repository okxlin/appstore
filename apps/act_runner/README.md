# Act runner

## 应用简介
Gitea Actions 的 Runner。

英文说明：A runner for Gitea based on Gitea fork of act.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64。
- 可选版本：`latest`、`0.6.1`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| GITEA_INSTANCE_URL | Gitea 实例 URL | http://1.2.3.4:567 | 是 |
| RUNNER_REGISTRATION_TOKEN | Gitea runner REGISTRATION TOKEN | - | 是 |
| RUNNER_NAME | Gitea runner name | - | 是 |
| RUNNER_LABELS | Gitea runner labels | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://gitea.com/gitea/act_runner>
- 文档: <https://docs.gitea.com/next/usage/actions/act-runner>
