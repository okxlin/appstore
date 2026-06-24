# Docker Mirror Monitor

## 应用简介
实时监控多种容器镜像源的加速器状态。

英文说明：Real-time monitoring of multiple container image source accelerators.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、armv7、ppc64le、s390x。
- 可选版本：`latest`、`1.1.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 49080 | 是 |
| PANEL_APP_PORT_HTTP_INTERNAL | 内部端口 | 9080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
安装完成后，访问 `http://IP:端口` 即可使用。

如需修改监控目标或站点标题，请编辑安装目录下的 `data/config.yaml` 文件，然后调用 API 热加载或重启容器。

## 参考资料
- 官网: <https://github.com/okxlin/docker-mirror-monitor>
- 文档: <https://github.com/okxlin/docker-mirror-monitor/blob/main/README.md>
