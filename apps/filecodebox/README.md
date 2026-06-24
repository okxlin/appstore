# FileCodeBox

## 应用简介
文件快递柜-匿名口令分享文本，文件，像拿快递一样取文件。

英文说明：Anonymous Passcode Sharing Text, Files, Like Taking Express Delivery for Files.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`beta`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40157 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 后端地址：`/#/admin`

- 后台密码：`FileCodeBox2023`

## 参考资料
- 官网: <https://share.lanol.cn>
- 文档: <https://github.com/vastsa/FileCodeBox>
