# GoWebDAV

## 应用简介
轻量易用的 WebDAV 服务器。

英文说明：Lightweight and easy-to-use WebDAV server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：存储、工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40252 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DAV | WebDAV 配置 (指的容器内部的路径) | /dir1,/data/dir1,user1,pass1,true;/dir2,/data/dir2,null,null,false | 是 |
| DATA_PATH | 外部数据文件夹路径 | ./data/data | 是 |
| INNER_DATA_PATH | 外部数据对应的内部数据文件夹路径 | /data | 是 |
| DATA_PATH2 | 外部数据文件夹路径2 | ./data/data2 | 是 |
| INNER_DATA_PATH2 | 外部数据对应的内部数据文件夹路径2 | /data2 | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/117503445/GoWebDAV>
