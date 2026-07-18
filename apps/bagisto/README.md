# Bagisto

## 产品介绍

Bagisto 是基于 Laravel 的开源电商平台，提供商品、订单、客户和后台管理功能。

## 主要功能

- 商品、订单、客户和渠道管理。
- 通过 1Panel 选择的 MySQL 服务保存业务数据。
- 自动初始化空数据库并创建表单指定的初始管理员。

## 部署说明

- 安装时请选择 1Panel 的 MySQL 服务。Bagisto 使用该外部数据库，不会启动镜像内置的 MySQL。
- 首次启动会自动执行 Bagisto 安装、写入表单中的初始管理员账号，并运行数据库迁移。
- 管理后台地址为 `http://<服务器地址>:<端口>/admin/login`。
- 初始管理员字段只在空数据库首次初始化时使用。之后请在后台自行管理管理员账号和密码。

## 访问说明

- 商城地址：`http://<服务器地址>:<端口>/`。
- 管理后台：`http://<服务器地址>:<端口>/admin/login`。

## 数据持久化与升级

- `APP_DATA_DIR` 保存上传文件、会话和日志；MySQL 服务保存业务数据。升级或迁移前应同时备份两者。
- 固定版本适合可复现部署；`latest` 跟随上游当前稳定镜像。启动时会执行幂等的 Laravel 迁移，以应用上游已发布的数据库变更。
- 不要在多个安装中复用同一个数据库或存储目录。

## 参考资料

- 官网: <https://bagisto.com>
- 源码: <https://github.com/bagisto/bagisto>
- 官方生产镜像文档: <https://github.com/bagisto/bagisto/tree/v2.4.8/docker/production>

## Introduction

Bagisto is an open-source Laravel e-commerce platform for catalog, order, customer, and administrator management.

## Features

- Catalog, order, customer, and channel management.
- MySQL data storage through a selected 1Panel runtime service.
- Automatic empty-database initialization with the administrator supplied in the install form.

- Select a 1Panel MySQL service during installation. The package uses that external database instead of the image's internal MySQL.
- The first start initializes the empty database, creates the administrator specified in the form, and runs migrations.
- Open the administration page at `http://<server-address>:<port>/admin/login`.
- Back up both `APP_DATA_DIR` and the selected MySQL database before an upgrade or migration.
