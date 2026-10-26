# SimpleX SMP Server

## 产品介绍
SimpleX SMP Server 是官方推荐的自托管 SimpleX 中继服务，提供 SMP 消息中继端口，并自动生成运行所需的证书、指纹与配置。

## 主要功能
- 自托管 SMP 中继服务端口
- 首次启动自动生成证书、指纹与 `smp-server.ini`
- 支持可选队列创建密码

## 访问说明
安装完成后：

```text
smp://指纹[:创建队列密码]@ADDR:PANEL_APP_PORT_SMP
```

`ADDR` 默认值为 `127.0.0.1`，仅适用于本地初始化与测试。正式安装时请直接填写你的公网域名或公网 IP，SimpleX 客户端通过该地址与 SMP 端口连接。

## 运行模式
此包使用 SimpleX 官方 Docker manual 模式，SMP 主要监听端口为 5223。本包不启动 Caddy/Let's Encrypt，也不提供 443 的服务器信息页。首次启动仍会初始化 SMP 指纹和 `smp-server.ini`。

## 数据持久化
- `APP_CONFIG_DIR`：持久化 `/etc/opt/simplex`，保存证书、指纹与 `smp-server.ini`
- `APP_STATE_DIR`：持久化 `/var/opt/simplex`，保存 store log、统计与运行状态文件

## 升级说明
- 从 6.5.x 升级到 7.0.0 时，应用升级脚本会清理旧版生成的 `smp-server-stats.log` / `smp-server-stats.daily.log`，避免官方 v7 进程因旧统计文件格式不兼容而启动失败。
- 这会丢弃旧版累计的本地统计历史，但不会删除证书、指纹、store log 或消息数据。

## Introduction
SimpleX SMP Server is the official self-hosted relay server for SimpleX. This adaptation keeps the SMP relay port and follows the current Docker image behavior used by the upstream server image.

## Features
- Self-hosted SMP relay port
- Auto-generated certificates, fingerprint, and `smp-server.ini`
- Optional password for creating new queues
- `ADDR` must be set to your public domain or public IP during installation

## Runtime mode
This package uses SimpleX's official Docker manual setup, with SMP on TCP 5223. It does not include Caddy/Let's Encrypt or the automatically managed HTTPS server information page on port 443. First startup still initializes the SMP fingerprint and `smp-server.ini`.

## 版本说明
固定版本目录更新至官方镜像 `simplexchat/smp-server:v7.0.1`；`latest` 继续跟随官方滚动标签，可能独立变化。

The fixed version directory uses the official `simplexchat/smp-server:v7.0.1` image. The `latest` directory follows the upstream rolling tag and may move independently.

## 参考资料
- 官网: <https://simplex.chat/>
- 部署文档: <https://github.com/simplex-chat/simplex-chat/blob/stable/docs/SERVER.md>
- 源码: <https://github.com/simplex-chat/simplex-chat>
- Docker Compose 参考: <https://raw.githubusercontent.com/simplex-chat/simplexmq/stable/scripts/docker/docker-compose-smp-manual.yml>
- Docker Hub: <https://hub.docker.com/r/simplexchat/smp-server>
