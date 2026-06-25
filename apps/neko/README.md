# Neko

## 应用简介
自托管虚拟浏览器。

英文说明：A self-hosted virtual browser.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40277 | 是 |
| NEKO_BIND | 绑定地址 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOWNLOAD_PATH | 下载文件路径 (注意文件夹权限) | ./data/Downloads | 是 |
| NEKO_CERT | SSL证书路径 | - | 否 |
| NEKO_KEY | SSL 密钥路径 | - | 否 |
| NEKO_PATH_PREFIX | 路径前缀 | - | 否 |
| NEKO_FILE_TRANSFER_PATH | 文件传输路径 | /home/neko/Downloads | 否 |
| NEKO_STATIC | 静态文件路径 | - | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| IMAGE_NAME | 镜像名称 | m1k1o/neko:firefox | 是 |
| NEKO_SCREEN | 屏幕分辨率 | 1920x1080@30 | 是 |
| NEKO_PASSWORD | 用户密码 | neko | 是 |
| NEKO_PASSWORD_ADMIN | 管理员密码 | admin | 是 |
| NEKO_EPR | WebRTC UDP 端口范围 | 52000-52100 | 是 |
| NEKO_ICELITE | ICELite 模式 | 1 | 是 |
| MEM_USE | 共享内存占用 (1gb) | 2048m | 是 |
| NEKO_CONTROL_PROTECTION | 控制保护 | false | 是 |
| NEKO_IMPLICIT_CONTROL | 隐式控制 | false | 是 |
| NEKO_LOCKS | 锁定 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://neko.m1k1o.net>
- 源码: <https://github.com/m1k1o/neko>
