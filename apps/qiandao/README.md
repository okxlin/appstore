# QianDao

## 应用简介
一个 HTTP 请求定时任务自动执行框架。

英文说明：An HTTP request timed task automation framework.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`20250129`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40022 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AES_PWD | AES加密密钥 | AESPWD | 是 |
| COOKIE_PWD | COOKIE加密密钥 | CKPWD | 是 |

## 使用说明
### 说明
### 设置管理员
- 1.先注册一个账户.
- 2.进入容器运行以下命令

```
python ./chrole.py your@email.address admin
```
- 3.需要先登出再登陆后才能获得完整管理员权限。

## 参考资料
- 官网: <https://hub.docker.com/r/qdtoday/qd>
- 文档: <https://qd-today.github.io/qd/zh_CN/>
- 源码: <https://github.com/qd-today/qd>
