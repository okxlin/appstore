# PreST

## 产品介绍

PreST 将 PostgreSQL 数据库映射为 REST API。本应用使用 1Panel 已管理的 PostgreSQL 服务，不会启动内置数据库。

## 主要功能

- 将 PostgreSQL schema 和 table 映射为 REST 读写接口。
- 提供数据库、schema 和 table 浏览接口及内置 Studio。
- 支持由 PostgreSQL 账户权限约束的数据访问边界。

## 安全默认值

- 除 `/_health` 和 `/_ready` 外，所有 HTTP 路径默认要求有效的 Bearer JWT。
- 安装脚本生成 32 字节随机 JWT 签名密钥，并以 `0600` 权限保存 `.env`。
- OpenTelemetry、插件构建、调试模式、缓存和目录暴露默认关闭。
- 容器以 UID/GID `65532`、只读根文件系统和无 Linux capabilities 运行。

## 访问说明

生成一枚默认有效期为一小时的访问令牌：

```bash
./scripts/token.sh
```

指定有效期秒数（允许范围 60 到 86400）：

```bash
./scripts/token.sh 3600
```

请求示例：

```bash
TOKEN="$(./scripts/token.sh)"
curl -H "Authorization: Bearer ${TOKEN}" http://127.0.0.1:3000/databases
```

外部访问应通过 1Panel 网站反向代理启用 HTTPS。JWT 不是传输加密，不应通过明文公网 HTTP 发送。

## Introduction

PreST maps PostgreSQL databases to a REST API. This package connects to a PostgreSQL service managed by 1Panel and does not start an embedded database.

## Features

- REST read and write endpoints for PostgreSQL schemas and tables.
- Database catalog endpoints and the embedded PreST Studio.
- Global JWT authentication enabled by default for all non-health routes.

Run `./scripts/token.sh` in the installed version directory to generate a short-lived Bearer token. Use HTTPS through a 1Panel reverse proxy before exposing the API outside a trusted network.

## PostgreSQL 权限边界

PreST 使用表单选择的数据库账户执行查询。该账户能访问的数据库对象就是 API 的最大权限边界。不要选择 PostgreSQL 超级用户；应为 PreST 创建专用的最小权限账户，并只授予所需 schema、table 和 operation 权限。备份和数据库账户生命周期由所选 1Panel PostgreSQL 服务负责。

## 版本说明

固定版本 `2.4.1` 保留已审查的官方 `v2.4.1` 镜像摘要；`latest` 目录使用同一版本标签但不固定 digest，以便接收该标签的上游重建。上游 Docker Hub 的浮动 `latest` 在审查时仍包含旧版 PreST，因此本包没有改用该标签。

官方镜像目前仅发布 `linux/amd64`。OpenTelemetry 保持关闭；启用它会引入未包含在本应用验证范围内的外部 OTLP/gRPC 网络路径。

## 参考资料

- 官网：<https://prest.dev/>
- 文档：<https://docs.prest.dev/>
- 源码：<https://github.com/prest/prest>
- 许可证：MIT
