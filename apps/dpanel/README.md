# DPanel

## 应用简介
Docker 可视化面板系统。

英文说明：Docker Visualization Panel System.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`1.10.5-lite`、`lite`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40283 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| DOCKER_SOCK_PATH | Docker 套接字路径 | /var/run/docker.sock | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_NAME | 应用名称 | dpanel | 是 |

## 使用说明
- 账户密码
```
username: admin
password: admin
```

## 参考资料
- 官网: <https://donknap.github.io/dpanel-docs>
- 源码: <https://github.com/donknap/dpanel>
