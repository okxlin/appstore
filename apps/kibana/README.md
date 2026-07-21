# Kibana

## 产品介绍
Kibana 是 Elastic Stack 的数据可视化、探索和管理界面，可用于查看 Elasticsearch 中的数据、构建仪表盘并进行日志和指标分析。

## 主要功能
- 浏览和查询 Elasticsearch 数据
- 创建图表、仪表盘和数据视图
- 提供 Elastic Stack 管理、索引和空间等常用界面

## 访问说明
安装后通过 `http://<服务器 IP>:15601` 访问 Kibana，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。默认用户名为 `elastic`，密码为安装表单中的 `ELASTIC_PASSWORD`。

## Introduction
Kibana is the data visualization, exploration and management interface for Elasticsearch and the Elastic Stack.

## Features
- Explore and query data stored in Elasticsearch
- Create charts, dashboards and data views
- Manage common Elastic Stack resources from a web interface

## 部署说明
- 本应用使用 Elastic 官方 Kibana 和 Elasticsearch 镜像，两个服务保持相同版本。
- 默认内置单节点 Elasticsearch，仅暴露 Kibana Web 端口；Elasticsearch 端口只在应用内部网络使用。
- 默认启用 Elasticsearch 安全认证，Kibana 启动前会为 `kibana_system` 用户设置安装表单中的系统密码。
- 单节点默认把 Elasticsearch 磁盘 flood-stage 水位线设为 99%，避免小盘环境首次启动时因剩余空间比例偏低导致安全索引被立即设为只读。
- 应用分类：Tool。
- 支持架构：amd64、arm64。
- 可选版本：`latest`；镜像更新会保持在当前兼容版本线内，并在合并前进行多服务升级测试。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Kibana Web 访问端口，容器内映射到 `5601` | 15601 | 是 |

## 数据持久化
| Docker 卷 | 说明 |
| --- | --- |
| `${CONTAINER_NAME}-elasticsearch-data` | Elasticsearch 数据卷 |
| `${CONTAINER_NAME}-data` | Kibana 数据卷 |

升级、迁移或重新安装前，请先在 1Panel 中备份上述 Docker 卷。Elastic Stack 跨大版本升级需要阅读官方升级说明，不建议直接替换镜像大版本。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| KIBANA_PUBLIC_BASE_URL | Kibana 对外访问地址，需要与实际协议、域名和端口一致 | http://localhost:15601 | 是 |
| KIBANA_I18N_LOCALE | Kibana 界面语言，可选 `zh-CN` 或 `en` | zh-CN | 是 |
| ES_JAVA_OPTS | Elasticsearch JVM 堆参数 | -Xms512m -Xmx512m | 是 |
| ELASTIC_PASSWORD | `elastic` 管理用户密码，安装时随机生成 | 随机生成 | 是 |
| KIBANA_SYSTEM_PASSWORD | `kibana_system` 内部用户密码，安装时随机生成 | 随机生成 | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 首次访问时使用用户名 `elastic` 和安装表单中的 `ELASTIC_PASSWORD` 登录。
- Kibana 内部加密密钥会根据安装时生成的 `ELASTIC_PASSWORD` 派生，避免 1Panel 默认随机字段长度不足导致启动失败；不要在已有数据的实例中随意修改 `ELASTIC_PASSWORD`。
- Elastic 官方镜像及其基础系统、Node.js 或 Java 依赖可能包含镜像扫描器报告的已知 High 漏洞。请及时升级，仅向可信网络开放，并关注 Elastic 官方安全公告。
- 生产使用前建议确认服务器内存、磁盘空间、备份策略和反向代理 HTTPS 配置。
- 如果通过域名或反向代理访问，请同步更新 `KIBANA_PUBLIC_BASE_URL`。
- Elasticsearch 数据目录保存索引和集群状态，删除或重建该目录会导致数据丢失。

## 参考资料
- 官网: <https://www.elastic.co/kibana>
- Kibana 仓库: <https://github.com/elastic/kibana>
- Elasticsearch 仓库: <https://github.com/elastic/elasticsearch>
- Kibana Docker 文档: <https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-kibana-with-docker>
- Elasticsearch Docker 文档: <https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-docker-basic>
