# Matomo

## 应用简介
开源的网站分析应用程序。

英文说明：Liberating Web Analytics.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`5.10.1-fpm-alpine`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40077 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据存放文件夹 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | matomo | 是 |
| PANEL_DB_USER | 数据库用户 | matomo | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | matomo | 是 |
| PANEL_DB_PREFIX | 数据库前缀 | matomo_ | 是 |

## 使用说明
当完成部署初始化时，注意需要按照页面提示，

修改`config.ini.php`文件，将访问IP/域名加入白名单，或者取消白名单。

文件所在大致路径如下，注意按需修改

```
/opt/1panel/apps/local/matomo/matomo/data/web/config
```

## 参考资料
- 官网: <https://matomo.org/>
- 文档: <https://matomo.org/docs>
- 源码: <https://github.com/matomo-org/matomo>
