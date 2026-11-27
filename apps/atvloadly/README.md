# ATVLoadly

## 产品介绍
轻松将 IPA 侧载到 AppleTV。

## 主要功能
- 将 IPA 文件侧载到 Apple TV。

## Introduction
Easily sideload IPA files to Apple TV.

## Features
- Sideload IPA files to Apple TV.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具、媒体。
- 支持架构：amd64。
- 可选版本：`latest`；固定版本以应用商店当前版本目录和安装表单为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40338 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。宿主机需安装并运行 `avahi-daemon`；容器固定挂载宿主机的 `/var/run/dbus` 和 `/var/run/avahi-daemon`。

## 升级说明
- `0.8.7` 改用上游推荐的 `seccomp:unconfined`，移除 `privileged`；数据目录和 DBus/Avahi 挂载位置不变，无需迁移应用数据。
- 升级后请确认宿主机的 `avahi-daemon` 服务保持运行，才能发现 Apple TV。

## 安全说明
- 应用没有内置身份验证，请仅在可信网络中访问，避免直接暴露到公网。
- 容器使用 `seccomp:unconfined`，不再以特权容器运行。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/bitxeno/atvloadly>
