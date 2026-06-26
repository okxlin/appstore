# FileCodeBox

## 产品介绍
FileCodeBox 是一个用于匿名口令分享文本和文件的轻量文件快递柜。

## 主要功能
- 通过匿名口令分享文本和文件。
- 使用 `/app/data` 持久化应用数据。
- 提供后台入口用于管理文件分享，首次启动后在初始化页面设置管理员密码。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Web UI，并按初始化页面设置管理员密码；后台入口为 `/#/admin`。

## Introduction
FileCodeBox is a lightweight file locker for sharing text and files with anonymous passcodes.

## Features
- Share text and files with anonymous passcodes.
- Persist application data under `/app/data`.
- Provide an admin entrypoint for managing shared files. Set the admin password on the initialization page after first launch.

## 应用简介
文件快递柜-匿名口令分享文本，文件，像拿快递一样取文件。

英文说明：Anonymous Passcode Sharing Text, Files, Like Taking Express Delivery for Files.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
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
- 首次访问时按初始化页面设置管理员密码。
- 后台入口：`/#/admin`

## 参考资料
- 官网: <https://share.lanol.cn>
- 文档: <https://github.com/vastsa/FileCodeBox>
