# NginxProxyManager

## 应用简介
使用简单、强大的界面管理 Nginx 代理主机。

英文说明：managing Nginx proxy hosts with a simple, powerful interface.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`github-pr-3281`、`zh-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 30080 | 是 |
| PANEL_APP_PORT_HTTP1 | 控制台端口 | 30081 | 是 |
| PANEL_APP_PORT_HTTP2 | HTTPS端口 | 30443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data/data | 是 |
| SSL_PATH | 证书文件夹路径 | ./data/ssl | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
控制台默认账户密码
```
Email:    admin@example.com
Password: changeme
```

## 参考资料
- 官网: <https://nginxproxymanager.com/>
- 文档: <https://nginxproxymanager.com/guide/>
- 源码: <https://github.com/NginxProxyManager/nginx-proxy-manager>
