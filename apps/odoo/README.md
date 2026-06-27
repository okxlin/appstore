# Odoo

## 产品介绍
Odoo 是一套开源企业应用，覆盖 CRM、销售、库存、会计、网站、电商、项目管理等业务场景。

## 主要功能
- 管理客户、销售、采购、库存和项目
- 创建网站、电商和门户页面
- 通过 Odoo 应用市场扩展业务模块

## 访问说明
安装后通过 `http://<服务器 IP>:18082` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Odoo is an open source business application suite covering CRM, sales, inventory, accounting, websites and more.

## Features
- Manage CRM, sales, purchasing, inventory and projects
- Build websites, ecommerce and portal pages
- Extend business workflows with Odoo apps and addons

## 部署说明
- 本应用使用 Docker Official Image `odoo:19.0` 和官方文档推荐的 PostgreSQL 部署方式。
- 应用分类：CRM。
- 支持架构：amd64、arm64。
- 可选版本：`latest`，当前固定使用 Odoo 19.0 大版本镜像，避免自动跨大版本升级。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 18082 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Odoo filestore、扩展模块和 PostgreSQL 数据目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| POSTGRES_PASSWORD | PostgreSQL 数据库密码 | 随机生成 | 是 |
| ODOO_MASTER_PASSWORD | Odoo 数据库管理密码，用于创建和管理数据库 | 随机生成 | 是 |

## 使用说明
- 首次访问后，使用安装表单中的 `ODOO_MASTER_PASSWORD` 创建数据库。
- 自定义 Odoo addons 可放入数据目录下的 `addons` 子目录。
- 本应用在容器启动时生成最小 `odoo.conf`，用于设置 `admin_passwd`，数据库连接仍沿用官方镜像的 `HOST`、`PORT`、`USER`、`PASSWORD` 参数。
- Odoo 官方文档说明，同一大版本内镜像会定期更新；跨大版本升级需要迁移脚本或官方升级服务，不建议直接替换镜像大版本。

## 参考资料
- 官网: <https://www.odoo.com/>
- 项目仓库: <https://github.com/odoo/odoo>
- Docker Official Image 文档: <https://github.com/docker-library/docs/blob/master/odoo/README.md>
- 官方 Docker 镜像源码: <https://github.com/odoo/docker>
