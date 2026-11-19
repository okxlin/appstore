## 产品介绍

**UniTerm** 是一款可在浏览器中使用的多用户一体化终端，每位用户拥有独立隔离的工作区。它支持 SSH、RDP、SFTP、数据库、Kubernetes、容器管理，并内置可自主执行多轮命令的 AI Agent。

## 产品优势

- **统一运维入口，替代多套单点工具**：将 SSH 终端、文件传输、远程桌面、数据库客户端以及容器/Kubernetes 管理集中到同一工作区。常见 MySQL/MariaDB 管理场景可由内置数据库工具覆盖，减少 phpMyAdmin、SSH 工具、SFTP 客户端和数据库客户端并行使用带来的账号、配置与窗口切换成本。

- **数据库管理覆盖面广**：支持 MySQL/MariaDB、PostgreSQL/CockroachDB、Oracle、SQL Server、SQLite、rqlite、Redis、MongoDB 和 Elasticsearch，提供结构浏览、查询执行、数据查看与编辑，并支持通过自然语言生成查询，适合作为多种数据库的统一管理入口。

- **同机容器数据库直连，降低端口暴露面**：当 UniTerm 与数据库容器部署在同一台宿主机并共享 Docker 网络时，可直接将容器名或服务名作为数据库主机地址，无需把数据库端口发布到宿主机或公网，也无需额外配置外部地址。MySQL/MariaDB、PostgreSQL、Redis、MongoDB 等常见数据库都可在同一工作区中完成连接、查询、浏览、编辑和排障，显著提升管理本机容器化数据库的便利性；Docker、Podman、nerdctl 和 Kubernetes 资源也可通过已配置的 SSH 或集群连接统一管理。

## 主要功能

- **多协议访问**：集中使用 SSH、Telnet、Mosh、RDP、VNC、SFTP、FTP、WebDAV 与 S3 等连接。
- **浏览器多用户部署**：通过 Web 登录使用，隔离保存每位用户的连接、密钥和个人数据。
- **运维与 AI Agent**：管理数据库、Kubernetes 与容器资源，并使用 AI Agent 在当前终端中规划与执行命令。
