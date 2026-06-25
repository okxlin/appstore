# Natter

## 应用简介
Fullcone NAT 端口打洞工具。

英文说明：Expose your port behind full-cone NAT to the Internet.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2.1.1`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| EXTERNAL_DATA_PATH | 外部数据路径 | ./data | 是 |
| INTERNAL_DATA_PATH | 容器内部数据路径 | /data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SERVICE_NAME | 服务名称 | natter-service | 是 |
| COMMAND | 命令 | -m test | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/MikeWang000000/Natter>
