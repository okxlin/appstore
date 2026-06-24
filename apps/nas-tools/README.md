# NAS-Tools

## 应用简介
NAS 媒体库管理工具。

英文说明：NAS Media Library Management Tools.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`3.4.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40296 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| MEDIA_PATH | 媒体路径 | ./data/media | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOSTNAME | 主机名 | nas-tools | 是 |
| NASTOOL_AUTO_UPDATE | 自动更新 | false | 是 |
| NASTOOL_CN_UPDATE | 国内更新 | false | 是 |

## 使用说明
- 账户密码
```
username: admin
password: password
```

## 参考资料
- 官网: <https://github.com/hsuyelin/nas-tools>
