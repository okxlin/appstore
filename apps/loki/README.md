# Loki

## 产品介绍
Loki 是 Grafana Labs 的日志聚合系统，用于收集、存储和查询应用日志，常与 Grafana、Promtail 或 Grafana Alloy 搭配使用。

## 主要功能
- 通过 HTTP API 接收和查询日志
- 使用本地文件系统存储单节点日志数据
- 提供 `/ready` 和 `/metrics` 等运行状态接口

## 访问说明
安装后通过 `http://<服务器 IP>:3100` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Loki is Grafana Labs' log aggregation system for collecting, storing and querying application logs.

## Features
- Receive and query logs through HTTP APIs
- Store single-node log data on local filesystem storage
- Expose runtime endpoints such as `/ready` and `/metrics`

## 部署说明
- 本应用使用官方 Docker 镜像 `grafana/loki` 部署。
- 应用分类：DevOps。
- 支持架构：amd64、arm64、armv7。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Loki HTTP 端口 | 3100 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Loki 数据目录，挂载到容器 `/loki` | ./data | 是 |

升级、迁移或清理日志前，请先备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 本应用使用单节点本地文件系统配置，适合轻量日志收集、测试和小规模自用场景。
- Loki 默认不提供 Web 管理界面，建议搭配 Grafana 数据源使用。
- 本应用配置已关闭 Loki 匿名统计上报。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://grafana.com/oss/loki/>
- 项目仓库: <https://github.com/grafana/loki>
- Docker 安装文档: <https://grafana.com/docs/loki/latest/setup/install/docker/>
