# FOSSBilling

## 应用简介
一款用于高效计费和客户管理的免费开源解决方案。

英文说明：A free open source, billing and client management solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40125 | 是 |

## 使用说明
- 要求`MySQL8`或以上。

- 注意默认资料以存储卷方式存储的。

## 参考资料
- 官网: <https://fossbilling.org>
- 文档: <https://fossbilling.org/docs>
- 源码: <https://github.com/FOSSBilling/FOSSBilling>
