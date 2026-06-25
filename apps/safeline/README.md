# 雷池 Web 应用防火墙(Safeline WAF)

## 应用简介
一款足够简单、足够好用、足够强的免费 WAF。

英文说明：A simple and easy to use WAF tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`7.3.1`、`newnet-7.3.1`、`newnet-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SAFELINE_DIR | 数据存放文件夹 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| POSTGRES_PASSWORD | Postgres数据库密码 | - | 是 |
| SUBNET_PREFIX | 1panel-network 子网前缀 (查看docker网络获取) | 172.18.0 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://waf-ce.chaitin.cn/>
- 文档: <https://waf-ce.chaitin.cn/posts/guide_introduction>
- 源码: <https://github.com/chaitin/safeline>
