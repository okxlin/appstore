# LibreSpeed

## 产品介绍
LibreSpeed 是一个自托管网络速度测试服务，本应用使用 LinuxServer.io 镜像部署。

## 主要功能
- 在浏览器中进行下载、上传、延迟和抖动测试。
- 使用 `/config` 持久化配置和结果数据库。
- 默认使用 sqlite 结果数据库，便于单容器部署和迁移。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Web UI。

## Introduction
LibreSpeed is a self-hosted network speed test service. This app deploys the LinuxServer.io image.

## Features
- Run download, upload, latency, and jitter tests from a browser.
- Persist configuration and the results database under `/config`.
- Use sqlite by default for a simple single-container deployment.

## 应用简介
LibreSpeed 测速服务。

英文说明：Network speed test service maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`6.1.0`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| PASSWORD | 结果数据库密码 | 随机生成 | 是 |
| CUSTOM_RESULTS | 启用自定义结果页 | false | 是 |
| IPINFO_APIKEY | IPInfo 访问令牌 | 空 | 否 |

## 使用说明
- 默认结果数据库类型固定为 sqlite，不需要外部数据库。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://librespeed.org/>
- 文档: <https://docs.linuxserver.io/images/docker-librespeed/>
- 源码: <https://github.com/linuxserver/docker-librespeed>

