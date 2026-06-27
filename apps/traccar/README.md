# Traccar

## 产品介绍
Traccar 是一套开源 GPS 跟踪系统，支持多种 GPS 设备和手机客户端上报位置，并提供 Web 管理界面。

## 主要功能
- 管理车辆、人员或设备的位置上报
- 通过 Web 界面查看轨迹、事件和设备状态
- 支持大量 GPS 协议和手机客户端

## 访问说明
安装后通过 `http://<服务器 IP>:18083` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Traccar is an open source GPS tracking system with a web interface and support for many GPS devices and mobile clients.

## Features
- Manage location reports from vehicles, people or devices
- View tracks, events and device status in the web interface
- Support many GPS protocols and mobile clients

## 部署说明
- 本应用使用官方镜像 `traccar/traccar:6.14.5`。
- 数据库使用 MySQL 8.4，避免默认 H2 数据库用于长期生产数据。
- 官方生产 compose 示例包含 `autoheal` 容器并挂载 Docker socket；本应用默认不引入该 sidecar，降低 Docker socket 暴露风险。
- 应用分类：Website。
- 支持架构：amd64、arm64。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 管理界面端口 | 18083 | 是 |
| PANEL_APP_PORT_DEVICE | Traccar Client / OsmAnd 设备端口 | 5055 | 是 |

Traccar 官方 Docker 示例会暴露 5000-5500 设备协议端口范围。为避免默认占用大量宿主端口，本应用只暴露 Traccar Client / OsmAnd 常用的 5055 TCP/UDP 端口。其他硬件设备请先在 Traccar 官方设备列表确认协议端口，再按需在 compose 中增加对应端口映射。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Traccar 日志和 MySQL 数据目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TZ | 容器时区 | Asia/Shanghai | 是 |
| MYSQL_PASSWORD | Traccar MySQL 用户密码 | 随机生成 | 是 |

## 使用说明
- 首次访问后，按 Traccar 页面提示创建管理员账号。
- Traccar Client 最新版本默认使用 5055 端口；手机客户端的 Server URL 请填写 `http://<服务器 IP>:5055`，如果安装时修改了 `PANEL_APP_PORT_DEVICE`，请使用修改后的宿主端口。
- 其他 GPS 硬件设备的协议端口请参考 Traccar 官方设备列表或协议识别文档；例如 GPS103 默认使用 5001，JT808 默认使用 5015，GT06 默认使用 5023。
- 默认不会公开 MySQL 端口。
- MySQL root 密码与 `MYSQL_PASSWORD` 一致，仅在容器内部初始化和维护数据库时使用。

## 参考资料
- 官网: <https://www.traccar.org/>
- 项目仓库: <https://github.com/traccar/traccar>
- Docker 文档: <https://www.traccar.org/docker/>
- 官方 MySQL Compose: <https://github.com/traccar/traccar/blob/master/docker/compose/traccar-mysql.yaml>
- Traccar Client 配置: <https://www.traccar.org/client-configuration/>
- 协议识别文档: <https://www.traccar.org/identify-protocol/>
