# ONLYOFFICE Docs

## 应用简介
一个免费的在线办公套件。

英文说明：A free collaborative online office suite.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`9.4.0.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40156 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| JWT_SECRET | JWT密码 | secret | 是 |

## 使用说明
部署完成后按照页面提示，在终端执行命令，开启服务。

## 参考资料
- 官网: <https://www.onlyoffice.com>
- 文档: <https://helpcenter.onlyoffice.com>
- 源码: <https://github.com/ONLYOFFICE>
