# Memgraph

## 产品介绍

Memgraph 是使用 C/C++ 构建的高性能图数据库，通过 Bolt 协议提供 Cypher 查询，适用于实时图分析、GraphRAG、AI 记忆和关系密集型业务。本应用使用官方 `memgraph/memgraph` 核心镜像，以单个 service 运行数据库。

## 主要功能

- 通过 Bolt 协议执行兼容 Neo4j Cypher 的图查询
- 使用 WAL、周期快照和退出快照持久化图数据
- 提供 Monitoring WebSocket 和 OpenMetrics 运行指标

## 镜像范围

- 本包选择体积较小的核心 `memgraph/memgraph` 镜像，提供 Memgraph 数据库和 `mgconsole`。
- 本包不使用 `memgraph/memgraph-mage`，因此不包含 MAGE 的 40 多种图算法、Python/CUDA 查询模块或 Memgraph Lab。需要 MAGE 时应单独评估更大的 MAGE 镜像和相应资源需求。
- 固定版本适合生产部署；`latest` 是上游浮动标签，内容可能变化，升级前应重新扫描并验证。

## 访问说明

- Bolt/Cypher：容器端口 `7687`。
- Monitoring WebSocket：容器端口 `7444`。
- OpenMetrics：容器端口 `9091`，路径为 `/metrics`。

Memgraph 核心镜像不提供最终用户管理 Web UI。`/metrics` 无数据库认证，可能暴露运行指标；不要把上述端口直接开放到不受信任的公网，应使用防火墙、反向代理或可信网络限制访问。

## 认证

安装时必须设置 `MEMGRAPH_USER` 和至少 16 个字符的 `MEMGRAPH_PASSWORD`。本包关闭空密码认证，并使用带凭据的 `mgconsole` 查询执行健康检查；未认证 Bolt 连接会被拒绝。

这些环境变量用于首次创建管理员。数据库已有用户后，修改 `.env` 不等同于轮换现有密码；应连接数据库后通过 Memgraph 的用户管理命令修改凭据，并妥善保管新密码。

## 部署拓扑与 1Panel Runtime

- 默认只有一个 Memgraph service，不附带 PostgreSQL、MySQL、Redis 或其他依赖。
- Memgraph 是独立图数据库，目前没有可复用的 1Panel 官方 Memgraph Runtime；本包不联动、不注册 1Panel Runtime。
- 本包不使用特权模式、主机网络、额外 Linux capability 或 Docker socket。

## 数据、WAL、快照与升级

安装表单中的数据目录会分别挂载到 `/var/lib/memgraph` 和 `/var/log/memgraph`。生命周期脚本创建 `data`、`logs` 子目录，将所有者设置为镜像用户 UID/GID `101:103`，目录权限设置为 `0750`，并将 `.env` 收紧为 `0600`。

官方镜像默认开启 WAL、周期快照、启动恢复和退出快照。本包默认每 300 秒创建快照，也可以通过 Cypher 执行 `CREATE SNAPSHOT`。升级前应确认快照和 WAL 正常，并备份整个数据目录；升级或重启后应验证用户、节点和索引仍可读取。

## 主机内核参数与资源

Memgraph 建议宿主机 `vm.max_map_count` 至少为 `524288`。若日志提示当前值过低，请在宿主机评估并执行：

```bash
sudo sysctl -w vm.max_map_count=524288
```

如需永久生效，请按发行版规范写入 sysctl 配置。该设置影响整台宿主机，不由本应用容器自动修改。

默认内存限制为 1024 MiB、工作线程为 2；本包拒绝低于 512 MiB 的配置。生产环境还需为操作系统、页缓存、快照和查询峰值保留空间，并按数据规模压测。

## 许可证

- Memgraph Community 采用经 Additional Use Grant 修改的 **Business Source License 1.1**，属于 **source-available** 软件，不是 OSI 批准的开源软件。
- 授权仅允许合规的内部业务用途；不得向第三方嵌入或分发并让其独立控制，不得以 database-as-a-service 或等效分布式模式向第三方提供，也不得用于创建可能与 Memgraph 竞争的产品或方案。
- 上游许可证原文把 Change Date 写为 **`2030-15-05`**。该日期格式并不标准，本包不代为修正或解释；部署者应向上游核实。许可证还规定，每个具体版本会在该 Change Date 或首次公开分发满四周年（以较早者为准）转为 **Apache-2.0**。
- Enterprise 功能受 **Memgraph Enterprise License** 约束。社区镜像中出现的功能名称不表示自动授予企业许可。
- 本说明不是法律意见。使用前应审阅与实际版本对应的上游许可证，必要时向 Memgraph 取得商业授权。

## 安全扫描快照

维护侧于 2026-07-15 使用 Trivy 扫描 `memgraph/memgraph:3.11.0` 和 `memgraph/memgraph:latest`；两者当时解析到同一镜像 digest，结果均为 **Critical=0、High=0**。这是随漏洞库和镜像变化的时间点快照，生产部署前应重新扫描并持续跟踪上游镜像更新。

## Introduction

Memgraph is a high-performance graph database for real-time analytics and AI workloads. This package runs the official core image as one service, requires native database authentication, persists WAL and snapshots, and exposes Bolt, monitoring, and OpenMetrics ports. It does not bundle MAGE or integrate with a 1Panel Runtime.

Memgraph Community is source-available under an amended Business Source License 1.1 with restrictions on distribution, third-party control, database-as-a-service use, and competing products. Enterprise features use the Memgraph Enterprise License. Review the upstream terms before deployment.

## Features

- Execute Cypher graph queries over the Bolt protocol
- Persist graph data with WAL and periodic or explicit snapshots
- Export runtime monitoring data in OpenMetrics format

## 参考资料

- 文档：<https://memgraph.com/docs/>
- Docker 安装：<https://memgraph.com/docs/getting-started/install-memgraph/docker>
- 配置参数：<https://memgraph.com/docs/database-management/configuration>
- 数据持久化：<https://memgraph.com/docs/fundamentals/data-durability>
- 源码仓库：<https://github.com/memgraph/memgraph>
- v3.11.0 发布：<https://github.com/memgraph/memgraph/releases/tag/v3.11.0>
- BSL 原文：<https://github.com/memgraph/memgraph/blob/master/licenses/BSL.txt>
- Enterprise 许可证：<https://github.com/memgraph/memgraph/blob/master/licenses/MEL.pdf>
