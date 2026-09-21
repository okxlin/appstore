# Milvus

## 产品介绍

Milvus 是面向向量检索和数据分析的开源向量数据库，支持通过 gRPC、HTTP 和 WebUI 使用向量数据服务。

本应用包采用 Milvus 官方 standalone Docker Compose 拓扑，包含 Milvus、etcd 元数据服务和 MinIO 对象存储。消息队列使用 Milvus 镜像内置的默认实现，不需要额外安装 1Panel 数据库或 Redis 服务。应用商店中的版本目录对应具体的上游发行版本，版本相关的安装要求和升级步骤请以该版本的官方文档为准。

## 主要功能

- 提供向量数据写入、查询、检索和索引能力
- 提供 Milvus gRPC API、HTTP/WebUI 访问端口
- 使用 etcd 保存元数据、MinIO 保存对象数据
- 使用独立数据目录保存 Milvus、etcd 和 MinIO 状态

## 访问说明

- Milvus gRPC、HTTP/WebUI、MinIO API 和 MinIO 控制台的宿主机端口在 1Panel 安装表单中配置，请以当前版本显示的端口为准。
- Milvus WebUI 位于 HTTP/WebUI 端口的 `/webui/` 路径；gRPC 客户端应使用安装表单中的 gRPC 端口。
- MinIO API 和控制台属于对象存储管理端点，通常只应在受信任的内网或反向代理访问范围内提供。

请在安装前阅读当前版本的官方 Docker 前置要求，并根据数据量、索引类型和并发量准备 CPU、内存及所需指令集。对外暴露 MinIO 管理端点前，应按当前上游文档确认凭据配置和网络访问策略；不要直接使用上游示例中的默认凭据。

## 数据与生命周期

本应用使用应用实例目录下的相对路径 bind mount，不创建 Docker 命名卷。相对路径以部署后的 `docker-compose.yml` 所在目录为基准：

| 宿主机相对路径 | 容器路径 | 用途 |
| --- | --- | --- |
| `./milvus-data` | `/var/lib/milvus` | Milvus 数据和本地 WAL |
| `./etcd-data` | `/etcd` | etcd 元数据 |
| `./minio-data` | `/minio_data` | MinIO 对象数据 |

容器重启、重建或升级时，只要应用实例目录仍被保留，上述目录中的数据就会继续使用。不要让多个实例共用同一组数据目录。升级、迁移或卸载前请备份这三个目录以及当前 Compose 配置；不要把它们当作卸载后一定保留的 Docker 命名卷，删除应用实例目录会同时删除这些 bind mount 数据。

升级前请阅读当前版本和目标版本的官方升级说明，确认是否支持直接升级以及是否需要经过中间版本。升级时保留现有 etcd、对象存储、消息队列和数据目录；发生异常时不要直接回滚镜像，先按备份恢复方案处理。

官方 Compose 使用一次性的卷权限初始化服务；为兼容 1Panel 对已退出 sidecar 的状态判断，应用包把同等的 marker 与递归权限初始化放入 root `scripts/init.sh`，Compose 中只保留长期运行的 etcd、MinIO 和 Milvus 服务。Milvus 服务仍保留上游的 `seccomp:unconfined` 安全选项。

## 安全与部署风险

- 为保持官方 standalone 拓扑兼容，Milvus 服务保留上游 Compose 的 `seccomp:unconfined` 设置。请在受信任的主机和网络环境中运行，并及时跟随上游安全更新。
- MinIO API 和控制台端口不要直接暴露到不受信任的公网；需要公网访问时，请先配置强凭据、访问控制和反向代理策略。

## 相关链接

- [官方网站](https://milvus.io/)
- [Docker Compose 配置文档](https://milvus.io/docs/configure-docker.md)
- [Docker 安装要求](https://milvus.io/docs/prerequisite-docker.md)
- [官方 Docker 安装文档](https://milvus.io/docs/install_standalone-docker.md)
- [升级说明](https://milvus.io/docs/upgrade_milvus_standalone-docker.md)
- [Milvus 官方版本发布](https://github.com/milvus-io/milvus/releases)
- [源码仓库](https://github.com/milvus-io/milvus)
- [官方 artwork 与 logo](https://github.com/milvus-io/artwork)
- [Linux Foundation 商标使用规范](https://www.linuxfoundation.org/trademark-usage/)

<details>
<summary>Milvus logo and trademark notice</summary>

本应用使用 [Milvus 官方 artwork](https://github.com/milvus-io/artwork) 中的图标用于标识所提供的软件。Milvus 名称和标识受 [Linux Foundation 商标使用规范](https://www.linuxfoundation.org/trademark-usage/) 约束；本应用包不表示 Milvus 或 LF AI & Data 对本应用包的赞助或背书。

</details>
