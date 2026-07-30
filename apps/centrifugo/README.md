# Centrifugo

## 产品介绍

Centrifugo 是一个面向应用的实时消息服务器。应用后端通过 HTTP API 发布消息，已认证的客户端通过 WebSocket 等传输订阅频道并实时接收消息。

本应用使用 Centrifugo 官方镜像和默认内存引擎，以单个非 root 容器运行，不依赖数据库或缓存服务。

## 主要功能

- 通过默认启用的 WebSocket 端点向在线客户端实时传送消息
- 使用 JWT 验证客户端连接，并通过 HTTP API 密钥保护后端发布接口
- 在内置管理界面中查看节点、连接和频道，并执行受控发布操作
- 使用健康检查监控单节点服务状态

## 访问说明

- 管理界面：`http://<主机>:<安装端口>/`
- WebSocket：`ws://<主机>:<安装端口>/connection/websocket`
- HTTP 发布 API：`POST http://<主机>:<安装端口>/api/publish`

反向代理 WebSocket 时需要保留 Upgrade/Connection 请求头。公网部署还应在防火墙、安全组和反向代理中限制管理入口与 API 访问。

## 默认安全配置

- 连接必须使用由 `CENTRIFUGO_CLIENT_TOKEN_HMAC_SECRET_KEY` 签名的 JWT。
- HTTP 发布 API 必须提供 `CENTRIFUGO_HTTP_API_KEY`。
- 管理界面默认启用，并使用随机管理密码和随机会话密钥保护。
- 默认允许已认证客户端订阅无命名空间频道，便于完成官方快速入门流程。生产环境可在安装表单中关闭该选项并改用上游的命名空间或代理授权策略。
- 浏览器应用应在 `CENTRIFUGO_CLIENT_ALLOWED_ORIGINS` 中填写允许的源，多个源使用空格分隔。非浏览器客户端未发送 `Origin` 时不受该配置影响。

所有密钥均由 1Panel 在安装时随机生成。请妥善保存安装参数，不要把 JWT 签名密钥、HTTP API 密钥或管理会话密钥发送给客户端。

## 使用说明

安装后通过表单设置的 HTTP 端口打开管理界面。使用管理密码登录后，可以查看节点和连接，并通过 Actions 页面向频道发布消息。

客户端 WebSocket 地址为：

```text
ws://<主机>:<端口>/connection/websocket
```

可以在 1Panel 的容器终端中使用官方 CLI 为测试用户生成连接令牌：

```bash
centrifugo gentoken -u demo-user
```

应用后端通过 `POST /api/publish` 发布消息，并在 `X-API-Key` 请求头中提供安装时生成的 HTTP API 密钥。详细的客户端订阅与发布示例请参阅上游快速入门文档。

## 数据与重启

默认内存引擎不保存消息历史、在线状态或频道状态，因此本应用没有持久卷。容器重启会断开现有客户端并清空内存状态；客户端应重新连接和订阅。安装配置与随机密钥由 1Panel 的应用环境保留，重启后认证配置保持不变。

需要 Redis、NATS、PostgreSQL、Kafka 或其他扩展拓扑时，请按照上游文档单独规划依赖、扩缩容、持久化和升级流程；这些模式不属于本默认单机包。

## 安全说明

交付时镜像包含 `grpc-go` 的 High 级公告 `GHSA-hrxh-6v49-42gf`。该公告影响 gRPC/xDS RBAC 与 gRPC HTTP/2 服务端；本包不启用或暴露 Centrifugo 的 gRPC API 和单向 gRPC 端点，因此默认拓扑不会进入对应代码路径。启用上游 gRPC 功能前应升级到包含修复依赖的镜像并重新评估风险。

## 参考资料

- 官网：<https://centrifugal.dev/>
- 快速入门：<https://centrifugal.dev/docs/getting-started/quickstart>
- 配置说明：<https://centrifugal.dev/docs/server/configuration>
- 源码：<https://github.com/centrifugal/centrifugo>
- 官方镜像：<https://hub.docker.com/r/centrifugo/centrifugo>

## Introduction

Centrifugo is a real-time messaging server for applications. Backends publish through the authenticated HTTP API, while authenticated clients subscribe over WebSocket and other supported transports.

This package runs the official image as one non-root service with the default in-memory engine. It enables the authenticated admin UI, connection JWT verification, HTTP API key authorization, health checks, and client-side channel subscriptions. It does not enable or expose gRPC endpoints.

## Features

- Authenticated real-time messaging through the default WebSocket endpoint
- API-key-protected backend publishing over HTTP
- Built-in authenticated administration UI for nodes, connections, channels, and publish actions
- Container health monitoring through the upstream `/health` endpoint

The default engine has no persistent state. Existing clients disconnect and in-memory channel state is cleared when the container restarts, while 1Panel retains the install configuration and generated secrets. See the upstream documentation before adopting Redis, NATS, PostgreSQL, Kafka, or a clustered topology.
