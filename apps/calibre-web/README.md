# Calibre-Web

## 应用简介
用于浏览、阅读和下载存储在 Calibre 数据库中的电子书的 Web 应用程序。

英文说明：Web app for browsing, reading and downloading eBooks stored in a Calibre database.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`0.6.26`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40109 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 书本文件夹路径 | ./data/books | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 默认账户密码

```
username：admin
password：admin123
```

## 参考资料
- 官网: <https://calibre-ebook.com>
- 文档: <https://calibre-ebook.com/help>
- 源码: <https://github.com/janeczku/calibre-web>
