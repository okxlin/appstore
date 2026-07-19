# OpenSearch

## 产品介绍

OpenSearch 是开源的分布式搜索与分析引擎。本应用使用官方镜像部署单节点
OpenSearch，并保留官方 Demo Security 的认证与自签名 TLS 配置。

## 主要功能

- 为全文检索、日志分析和数据探索提供 REST API。
- 使用单节点发现模式，适合独立部署和开发验证。
- 将索引数据保存到独立的 Docker 命名卷中。

## 访问说明

- 安装后通过 `https://<服务器 IP>:<HTTPS API 端口>` 访问 API。
- 默认管理员用户名为 `admin`，密码使用安装表单提供的初始管理员密码。
- Demo Security 使用自签名证书，浏览器或 API 客户端需要显式信任证书；这不等同于生产 TLS 配置。
- API 端口可读写索引数据。不要直接暴露到不受信任的公网；请使用防火墙、受限网络或带有自有证书的反向代理。
- 本包不包含 OpenSearch Dashboards。需要可视化界面时，请单独部署 Dashboards，并为其配置本实例的 HTTPS 端点与证书信任。

## 部署前提

- 宿主机必须满足 `vm.max_map_count=262144`。可先执行
  `sudo sysctl -w vm.max_map_count=262144`，并按操作系统方式持久化该设置。
- 建议为该实例至少预留 4 GiB 内存。安装表单默认 JVM 堆为 512 MiB，可按索引规模调整。

## 数据与升级

- 索引数据存储在与安装名关联的 Docker 命名卷中。卸载应用应只移除应用容器，不应将该数据卷当作临时数据删除；确认不再需要数据后再由管理员显式删除该卷。
- 升级前请使用 OpenSearch 快照功能并备份数据卷。生产环境优先选择固定版本，并遵循上游的版本兼容性和滚动升级文档；不要在没有恢复计划的情况下跨大版本升级或降级。

## Introduction

OpenSearch is an open-source distributed search and analytics engine. This
package deploys the official image as a single node and retains the official
Demo Security authentication and self-signed TLS configuration.

## Features

- Provide a REST API for full-text search, log analysis, and data exploration.
- Run with single-node discovery for independent deployments and development validation.
- Persist index data in a dedicated Docker named volume.

## Deployment Notes

- Access the API at `https://<server-ip>:<HTTPS API port>` with the `admin`
  user and the initial administrator password supplied during installation.
- The demo certificate is self-signed. Use a trusted certificate and restricted
  network access before exposing the API to users or the public Internet.
- The host must set `vm.max_map_count=262144`, and the instance should have at
  least 4 GiB of available memory. The default JVM heap is 512 MiB and can be
  adjusted for the expected index workload.
- Dashboards is intentionally not bundled. Deploy it separately and configure
  its HTTPS connection and certificate trust for this OpenSearch instance.
- Back up OpenSearch snapshots and the named data volume before upgrades. Do
  not delete the volume merely because the application is uninstalled.

## Sources

- [OpenSearch Docker documentation](https://docs.opensearch.org/3.7/install-and-configure/install-opensearch/docker/)
- [OpenSearch source repository](https://github.com/opensearch-project/OpenSearch)
