# OpenLiteSpeed

## 应用简介
一个高性能、轻量级、开源 的 HTTP 服务器。

英文说明：A high-performance, lightweight, open source HTTP server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：服务器。
- 支持架构：amd64。
- 可选版本：`latest`、`1.8.1-lsphp74`、`1.8.4-lsphp81`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 80 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS端口 | 443 | 是 |
| PANEL_APP_PORT_CONSOLE | 控制台端口 | 40113 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
安装完成后，在容器功能界面，连接容器终端，执行以下命令创建管理员账户密码

```
/usr/local/lsws/admin/misc/admpass.sh
```

## 参考资料
- 官网: <https://openlitespeed.org>
- 文档: <https://openlitespeed.org/#install>
- 源码: <https://github.com/litespeedtech/openlitespeed>
