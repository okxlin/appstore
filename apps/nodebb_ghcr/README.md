# 介绍

注：原 Docker 版本已经不再更新，此为 [ghcr](https://github.com/NodeBB/NodeBB/pkgs/container/nodebb) 版（Github Container Registry）。

NodeBB 论坛软件由 Node.js 提供支持，支持 Redis、MongoDB 或 PostgreSQL 数据库。它利用 WebSocket 实现即时互动和实时通知。NodeBB 吸收了现代网络的精华：实时流式讨论、移动响应能力、丰富的 RESTful 读/写 API，同时忠实于原始的公告栏/论坛格式 → 分类分层、本地用户账户和异步消息传递。

NodeBB 本身包含一个基本功能的 “通用核心”，而其他功能和集成则通过使用第三方插件来实现。

# 配置

容器首次启动后请等待npm模块安装，当日志显示出 `Web installer listening on http://0.0.0.0:<您选择的端口>` 时，即可通过网页安装程序进行配置。

## 数据库

NodeBB 有一个数据库抽象层（DBAL），允许用户为自己选择的数据库编写驱动程序。目前我们有以下选项：

### MongoDB（默认)

如果您担心使用 Redis 会耗尽内存，或者希望您的论坛更容易扩展，您可以使用 MongoDB 安装 NodeBB。本教程假定你知道如何通过 SSH 登录服务器并拥有 root 访问权限。

这些说明适用于 Ubuntu。请根据你的发行版进行相应调整。

注：如果你必须在任何命令中添加 sudo，请照做。没人会对你不利;)

[配置 MongoDB](https://docs.nodebb.org/configuring/databases/mongo/#step-1-install-mongodb)（如果使用docker，请参阅步骤6与步骤7）

### Redis

NodeBB 默认使用 MongoDB 作为其主要数据存储，尽管我们也支持 Redis。在 NodeBB 中，Redis 和 MongoDB 都被视为具有一流支持的数据存储，因此，如果您在使用 Redis 而不是 MongoDB 作为数据存储时遇到错误，我们仍然鼓励您[提交问题](https://github.com/NodeBB/NodeBB/issues/new)。

Redis 的设计将整个数据库保存在活动内存中，因此在某些高可扩展性场景中可能非常有用。与 MongoDB 相比，Redis 的速度可能会有一些不明显的提高。

不过，这种优势也是一把双刃剑。由于 Redis 将整个数据库保存在活动内存中，这意味着系统内存需要比数据集大两倍（如果不是更大的话）（例如，2GB 的数据需要至少 4GB 的系统内存）。Redis 需要两倍于数据集的内存，因为它的备份策略是先克隆内存中的数据，然后再将其持久化到磁盘上。

请仔细考虑您的硬件选项，看看您的安装是否值得权衡利弊。请记住，NodeBB 团队为有需要的用户提供 Redis 到 MongoDB 的迁移服务。如需了解更多信息，请联系 sales@nodebb.org。

[配置 Redis](https://docs.nodebb.org/configuring/databases/redis/#step-1-install-redis)（如果使用docker，请参阅步骤2）

### PostgreSQL

注:尽管 NodeBB 完全支持 PostgreSQL，但我们仍然建议使用MongoDB和Redis，因为这是我们自己和托管客户端上使用的。

PostgreSQL 无需多余配置。