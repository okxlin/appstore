# Certimate

## 应用简介
开源的 SSL 证书管理工具。

英文说明：Open source SSL certificate management tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：安全。
- 支持架构：amd64。
- 可选版本：`latest`、`0.3.18`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40297 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 账户密码
```
username: admin@certimate.fun
password: 1234567890
```

## 参考资料
- 官网: <https://docs.certimate.me>
- 源码: <https://github.com/usual2970/certimate>
