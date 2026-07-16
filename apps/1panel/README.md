# 1Panel

## 产品介绍

1Panel 是现代化、开源的 Linux 服务器运维管理面板。本应用使用 `moelin/1panel` 容器镜像，提供中国版和国际版的 V1 LTS、V2 固定版及浮动版本。

## 主要功能

- Linux 服务器、容器、网站、数据库和应用管理
- 可配置管理员账号、密码、访问端口和安全入口
- CN/Global 与 V1/V2 版本线独立维护

## 安装说明

可选版本：

- `1.10.34-lts`、`v1`：中国版 V1 LTS
- `2.2.3`、`v2`：中国版 V2
- `global-1.10.34-lts`、`global-v1`：国际版 V1 LTS
- `global-2.2.3`、`global-v2`：国际版 V2

生产环境建议选择固定版本；浮动标签适合希望自动跟随同一版本线镜像更新的部署。

- V1 和 V2 不能直接跨版本升级或降级。升级脚本会检测数据库类型并拒绝不兼容操作。
- `crossVersionUpdate: false` 会阻断数字目录之间的跨主版本升级，同时允许 `2.2.3` 升级到未来的 `2.3.1`。
- V1 到 V2 迁移前必须备份数据，并遵循官方迁移文档。
- 数据目录默认为宿主机 `/opt/1panel-data`，也可以在安装表单中改为其他绝对路径。
- 容器会将数据目录按相同的绝对路径挂载，并把该路径作为镜像的 `BASE_DIR`。这是 1Panel 通过宿主机 Docker Socket 创建业务容器时正确解析 bind mount 源路径所必需的。
- 从旧商店版本升级时，原有相对路径 `./data` 会被解析为原应用目录下的绝对路径，不会移动已有数据。
- 管理员密码为必填项；安全入口不要包含前导或末尾 `/`。

## 访问说明

安装完成后访问 `http://服务器地址:安装端口/安全入口/`，使用安装表单中设置的管理员账号和密码登录。

容器镜像中的 1Panel 不应通过面板右下角执行自更新。请通过更新应用镜像完成同一版本线内的升级。

## 高风险权限

> **高风险：本应用挂载 `/var/run/docker.sock` 并使用宿主机网络。**

这些权限是 1Panel 管理宿主机 Docker、网络和应用的核心要求。Docker Socket 可赋予容器等同宿主机 root 的控制能力，宿主机网络也会使面板端口直接监听在宿主机上。

- 请设置高强度管理员密码和不可预测的安全入口。
- 不要将管理端口直接暴露到不可信网络。
- 建议使用防火墙、可信来源限制或额外的反向代理访问控制。
- V1 为兼容旧部署额外挂载 `/root` 和 `/var/lib/docker/volumes`；V2 不使用这两个扩展挂载。

## 数据持久化

备份 `DATA_PATH` 对应的宿主机绝对目录即可保存 1Panel 数据。V1 和 V2 的数据库结构不同，不能通过替换镜像标签直接共用或转换数据。

## Introduction

1Panel is a modern, open-source Linux server operations and management panel. This package provides CN and Global V1 LTS and V2 tracks using the `moelin/1panel` images.

## Features

- Linux server, container, website, database, and application management
- Configurable administrator credentials, listening port, and security entrance
- Independently maintained CN/Global and V1/V2 image tracks

## Access

Open `http://server-address:installed-port/security-entrance/` and sign in with the administrator credentials supplied during installation.

Do not use the in-panel self-update action. Upgrade by changing the application image within the same major-version track. Direct V1/V2 upgrades and downgrades are blocked; use the official migration procedure instead.

## References

- 1Panel: <https://github.com/1Panel-dev/1Panel>
- Container image source: <https://github.com/okxlin/docker-1panel>
- Docker Hub: <https://hub.docker.com/r/moelin/1panel>
- V1 to V2 migration: <https://1panel.cn/docs/v2/installation/v1_migrate/>
