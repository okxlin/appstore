# Medama

## 应用简介
自托管、注重隐私的网站分析。

英文说明：Self-hostable, privacy-focused website analytics.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`0.6.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40282 | 是 |

## 数据持久化
- `medama-data:/app/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 账户密码
```
username: admin
password: CHANGE_ME_ON_FIRST_LOGIN
```

- 需要域名反向代理并开启`https`访问才能登录。

## 参考资料
- 官网: <https://oss.medama.io>
- 源码: <https://github.com/medama-io/medama>
