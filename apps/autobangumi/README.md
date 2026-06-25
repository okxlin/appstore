# AutoBangumi

## 应用简介
全自动追番工具。

英文说明：Automated anime tracking tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`3.2.6`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40298 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| DATA_PATH | 数据路径 | ./data/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DNS_SERVER | DNS 服务器 | 223.5.5.5 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 账户密码
```
username: admin
password: adminadmin
```

## 参考资料
- 官网: <https://www.autobangumi.org>
- 源码: <https://github.com/EstrellaXD/Auto_Bangumi>
