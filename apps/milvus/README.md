# Milvus

## 产品介绍

Milvus 是面向向量检索和数据分析的开源向量数据库，支持通过 gRPC、HTTP 和 WebUI 使用向量数据服务。

本应用包采用 Milvus 官方 v3.0.2 standalone Docker Compose 发布文件，包含 Milvus、etcd 元数据服务和 MinIO 对象存储。消息队列使用 Milvus 镜像内置的默认实现，不需要额外安装 1Panel 数据库或 Redis 服务。

## 主要功能

- 提供向量数据写入、查询、检索和索引能力
- 提供 Milvus gRPC API、HTTP/WebUI 访问端口
- 使用 etcd 保存元数据、MinIO 保存对象数据
- 使用独立数据目录保存 Milvus、etcd 和 MinIO 状态

## 访问说明

- Milvus gRPC API：默认 `19530`
- Milvus HTTP/WebUI：默认 `9091`，WebUI 地址为 `http://<主机地址>:9091/webui/`
- MinIO API：默认 `9000`
- MinIO 控制台：默认 `9001`

MinIO 端口和上游 Compose 一样默认发布，但 MinIO 账号密码是官方 Compose 中固定的 `minioadmin` / `minioadmin`，应将这两个端口视为内部管理端口，不要直接暴露到不受信任的公网。需要对外提供服务时，请先按官方文档配置凭据和网络访问策略。

Milvus standalone 官方要求至少 4 个 CPU 核心和 8 GB 内存，并要求 CPU 支持 SSE4.2、AVX、AVX2 或 AVX-512 中的至少一种指令集。实际资源需求取决于数据量和索引类型。

## 数据与生命周期

本应用使用应用实例目录下的相对路径 bind mount，不创建 Docker 命名卷。相对路径以部署后的 `docker-compose.yml` 所在目录为基准：

| 宿主机相对路径 | 容器路径 | 用途 |
| --- | --- | --- |
| `./milvus-data` | `/var/lib/milvus` | Milvus 数据和本地 WAL |
| `./etcd-data` | `/etcd` | etcd 元数据 |
| `./minio-data` | `/minio_data` | MinIO 对象数据 |

容器重启、重建或升级时，只要应用实例目录仍被保留，上述目录中的数据就会继续使用。升级、迁移或卸载前请备份这三个目录以及当前 Compose 配置；不要把它们当作卸载后一定保留的 Docker 命名卷，删除应用实例目录会同时删除这些 bind mount 数据。官方升级说明要求保留现有 etcd、对象存储、消息队列和数据目录，不能在升级时切换消息队列；发生异常时不要直接回滚镜像，先按备份恢复方案处理。

官方 Compose 使用一次性的卷权限初始化服务；为兼容 1Panel 对已退出 sidecar 的状态判断，应用包把同等的 marker 与递归权限初始化放入 root `scripts/init.sh`，Compose 中只保留长期运行的 etcd、MinIO 和 Milvus 服务。Milvus 服务仍保留上游的 `seccomp:unconfined` 安全选项。

## 相关链接

- [官方网站](https://milvus.io/)
- [Docker Compose 配置文档](https://milvus.io/docs/configure-docker.md)
- [Docker 安装要求](https://milvus.io/docs/prerequisite-docker.md)
- [官方 v3.0.2 standalone Compose](https://github.com/milvus-io/milvus/releases/download/v3.0.2/milvus-standalone-docker-compose.yaml)
- [升级说明](https://milvus.io/docs/upgrade_milvus_standalone-docker.md)
- [源码仓库](https://github.com/milvus-io/milvus)

<details>
<summary>默认图标许可 / Fallback icon license (MIT)</summary>

Copyright (c) 2026 okxlin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

</details>
