# LinkStack

## 应用简介
高度可定制的链接共享平台，用户界面直观易用。

英文说明：A highly customizable link sharing platform with an intuitive, easy to use user interface.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 应用 HTTP 端口 | 40225 | 是 |
| PANEL_APP_PORT_HTTPS | 应用 HTTPS 端口 | 40226 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HTTP_SERVER_NAME | HTTP 服务器名称 | www.example.xyz | 是 |
| HTTPS_SERVER_NAME | HTTPS 服务器名称 | www.example.xyz | 是 |
| SERVER_ADMIN | 服务器管理员 | admin@example.xyz | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| PHP_MEMORY_LIMIT | PHP 内存限制 | 512M | 是 |
| UPLOAD_MAX_FILESIZE | 上传文件最大限制 | 8M | 是 |

## 使用说明
- 数据默认以存储卷方式存储，类似卷`linkstack_linkstack`

- 需要注意，当前面板自带备份不会备份到存储卷

## 参考资料
- 官网: <https://linkstack.org>
- 文档: <https://docs.linkstack.org>
- 源码: <https://github.com/LinkStackOrg/LinkStack>
