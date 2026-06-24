# Cloudreve

## 应用简介
支持多家云存储的云盘系统。

英文说明：A cloud disk system that supports multiple cloud storage.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`4.16.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40033 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| UPLOAD_PATH | 上传文件保存路径 | ./data/uploads | 是 |
| TMP_PATH | 临时文件夹路径 | ./data/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
账户与密码可以查看容器日志获得

## 参考资料
- 官网: <https://cloudreve.org/>
- 文档: <https://docs.cloudreve.org/>
- 源码: <https://github.com/cloudreve/Cloudreve>
