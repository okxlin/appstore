# Discuz!

## 应用简介
开源社交建站系统。

英文说明：Open Source Social Building System.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`3.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 网页端口 | 40023 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 网页端口 | 40024 | 是 |

## 使用说明
### 1. 持久化问题

应用以存储卷方式进行存储数据

### 2. 数据库连接问题

需要新建数据库再进行安装

本机`MySQL`数据库连接信息，具体查看面板数据库页面来获取，例如
```
mysql:3306
```

## 参考资料
- 官网: <https://www.discuz.vip/>
- 文档: <https://open.dismall.com/?ac=document&page=dev>
- 源码: <https://gitee.com/Discuz/DiscuzX>
