# OneClickVirt

## 应用简介
可扩展的通用虚拟化管理平台，需外部 MySQL/MariaDB。

英文说明：Extensible virtualization management platform requiring external MySQL/MariaDB.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_PORT | 数据库端口 | 3306 | 是 |
| PANEL_APP_PORT_HTTP | 网页端口 | 80 | 是 |

## 数据持久化
- `./storage:/app/storage`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | oneclickvirt | 是 |
| PANEL_DB_USER | 数据库用户 | oneclickvirt | 是 |
| PANEL_DB_USER_PASSWORD | 数据库密码 | oneclickvirt | 是 |
| FRONTEND_URL | 前端访问地址（选填，如 https://your-domain.com） | - | 否 |

## 使用说明
> 安装前请先在 **应用商店** 中安装并运行 **MySQL** 或 **MariaDB**，安装时在表单中选择对应的数据库服务。
>
> 默认 Web 访问端口为 **80**，容器启动后等待约 **30 秒**再访问。
>
> **`前端访问地址（FRONTEND_URL）`** 为可选项：若通过 IP 直接访问可留空；若需要通过域名或 HTTPS 访问，请填入完整地址（如 `https://your-domain.com`），该配置影响 CORS 和 OAuth2 回调等功能。
>
> 数据持久化目录：
> - `./storage` → 容器内 `/app/storage`（配置、证书、日志、上传等）

## 参考资料
- 官网: <https://github.com/oneclickvirt/oneclickvirt>
