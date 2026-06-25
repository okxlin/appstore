# WPS Office

## 应用简介
多功能免费办公套件。

英文说明：A lightweight, feature-rich comprehensive office suite with high compatibility.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`11.1.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40134 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS端口 | 40135 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| HTTP_USER | HTTP 用户 | user | 是 |
| HTTP_PWD | HTTP 密码 | password | 是 |
| MEM_USE | 共享内存占用(512m) | 1gb | 是 |
| CUSTOM_USER | Basic Auth 用户名 | admin | 是 |
| PASSWORD | Basic Auth 密码 | 随机生成 | 是 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.wps.com>
- 源码: <https://hub.docker.com/r/linuxserver/wps-office>
