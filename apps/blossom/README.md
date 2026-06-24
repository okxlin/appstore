# Blossom

## 应用简介
一个支持私有部署的云端双链笔记软件。

英文说明：A note-taking software which support self-hosted and cloud-based dual-chain storing.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.16.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40204 | 是 |

## 数据持久化
- `./bl/:/home/bl/`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | blossom | 是 |
| PANEL_DB_USER | 数据库用户 | blossom | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | blossom | 是 |

## 使用说明
**管理页面及初始账户密码等通过查看容器日志获取。**

- 日志样本展示
```
blossom  | 启动成功 [xxxx-xx-xx xx:xx:xx], 可使用客户端登录, 默认用户名/密码: blos/blos
blossom  | 下载地址: https://github.com/blossom-editor/blossom/releases
blossom  | 文档地址: https://www.wangyunf.com/blossom-doc/index
blossom  | 博客端访问地址: http://IP:端口(域名)/blog/#/home
blossom  | 客户端访问地址: http://IP:端口(域名)/editor/#/settingindex
```

## 参考资料
- 官网: <https://www.wangyunf.com/blossom-doc/>
- 源码: <https://github.com/blossom-editor/blossom>
