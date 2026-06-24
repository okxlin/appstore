# AliyunDrive WebDAV

## 应用简介
阿里云盘 WebDAV 服务。

英文说明：AliyunDrive WebDAV Service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：存储。
- 支持架构：amd64。
- 可选版本：`main`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40257 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 配置路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REFRESH_TOKEN | 刷新令牌 | your-refresh-token | 是 |
| WEBDAV_AUTH_USER | WebDAV 用户名 | admin | 是 |
| WEBDAV_AUTH_PASSWORD | WebDAV 密码 | password | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/messense/aliyundrive-webdav>
