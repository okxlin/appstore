# Certd

## 应用简介
开源 SSL 证书管理工具。

英文说明：Open source SSL certificate management tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：安全。
- 支持架构：amd64。
- 可选版本：`latest`、`1.41.4`、`latest-postgres`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40311 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DNS_1 | 主 DNS | 223.5.5.5 | 是 |
| DNS_2 | 次 DNS | 119.29.29.29 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| HTTPS_PROXY | HTTPS 代理 | - | 否 |
| HTTP_PROXY | HTTP 代理 | - | 否 |
| RESET_ADMIN_PASSWD | 重置管理员密码 | false | 是 |
| IMMEDIATE_TRIGGER | 立即触发定时任务 | false | 是 |

## 使用说明
- 账户密码
```
username: admin
password: 123456
```

## 参考资料
- 官网: <https://certd.docmirror.cn>
- 源码: <https://github.com/certd/certd>
