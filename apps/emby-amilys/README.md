# Amilys Emby Server

## 应用简介
一个免费的个人媒体服务器 (开心版)。

英文说明：A free personal media server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`4.9.3.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40258 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 40259 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data/config | 是 |
| MOUNT_PATH | 挂载文件夹路径 | ./data/mnt1 | 是 |
| MOUNT_PATH2 | 挂载文件夹路径2 | ./data/mnt2 | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
> 如果需要显卡加速，安装的时候，请选择编辑`compose`文件，然后编辑显卡加速相关的配置。

***
已添加功能：

## 参考资料
- 官网: <https://hub.docker.com/r/amilys/embyserver>
- 源码: <https://github.com/amilys>
