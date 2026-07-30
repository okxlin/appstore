# Zot

## 产品介绍

Zot 是一个轻量、符合 OCI Distribution 规范的容器镜像仓库，可用于保存和分发 OCI 镜像与制品。本应用采用本地文件存储和 htpasswd 认证，适合通过 1Panel 管理并由同机 HTTPS 反向代理对外提供服务。

## 主要功能

- 兼容 OCI Distribution API 和常用容器镜像客户端。
- 使用本地文件系统持久化镜像、清单和制品数据。
- 默认要求用户名和密码认证。
- 支持镜像推送、拉取、更新和删除。

## 访问说明

默认仅监听 `127.0.0.1`。请在 1Panel 中配置 HTTPS 网站反向代理后，以该站点域名登录、推送和拉取镜像。用户名默认为 `zotadmin`，密码由安装表单随机生成，可在应用参数中查看。

若需要从其他主机直接访问，可将绑定地址改为 `0.0.0.0`，但容器客户端通常要求私有仓库使用可信 HTTPS。不要在公网暴露未启用 TLS 的仓库端口。

## 数据与安全

仓库数据保存在所选数据目录中。卸载应用不会删除该绑定目录；升级、迁移或卸载前应备份整个目录。应用配置和 htpasswd 文件由初始化脚本管理，密码只通过标准输入交给 OpenSSL 生成 200,000 轮 SHA-512 crypt 散列，不会写入配置或日志。

当前默认配置刻意不启用 OIDC、云存储、gRPC 遥测、同步和制品解包扩展。启用这些能力前应重新检查当前镜像版本的安全公告和依赖可达性。

## Introduction

Zot is a lightweight OCI Distribution-compliant registry for storing and distributing container images and OCI artifacts. This package uses local filesystem storage and htpasswd authentication and is intended to be published through a same-host HTTPS reverse proxy managed by 1Panel.

## Features

- Works with the OCI Distribution API and common container clients.
- Persists images, manifests, and artifacts on the local filesystem.
- Requires username and password authentication by default.
- Supports image push, pull, update, and deletion workflows.

## Access

The package binds to `127.0.0.1` by default. Configure an HTTPS website reverse proxy in 1Panel, then use that hostname to log in, push, and pull. The default username is `zotadmin`; the installation form generates a random password that remains available in the app parameters.

To connect directly from other hosts, change the bind address to `0.0.0.0`. Container clients normally require private registries to use trusted HTTPS, so do not expose the plain HTTP registry port to the public Internet.

## Data And Security

Registry data is stored in the selected data directory. Uninstalling the app leaves that bind-mounted directory intact. Back up the complete directory before upgrades, migration, or removal. The initializer manages the application config and htpasswd files. It sends the password to OpenSSL through standard input to create a 200,000-round SHA-512 crypt hash and does not write the cleartext password to config or logs.

The default configuration deliberately leaves OIDC, cloud storage, gRPC telemetry, synchronization, and artifact unpacking disabled. Recheck security advisories and dependency reachability before enabling any of those capabilities.

## References

- Website and documentation: <https://zotregistry.dev>
- Source: <https://github.com/project-zot/zot>
