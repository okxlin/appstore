# Chemex

## 应用简介
一个免费、开源、高效且漂亮的运维资产管理平台。

英文说明：A free, open-source, efficient and beautiful O&M asset management platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40028 | 是 |
| REDIS_DB_PORT | Redis端口 | 6379 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ENV_PATH | 环境配置文件路径 | ./data/.env | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | chemex | 是 |
| PANEL_DB_USER | 数据库用户 | chemex | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | chemex | 是 |
| PANEL_REDIS_DB_HOST | Redis 服务 | - | 是 |
| PANEL_DB_ROOT_PASSWORD | Redis 密码 | - | 是 |

## 使用说明
如果您是第一次使用 chemex，则需要执行数据库迁移。

需要执行以下几个步骤：修改`.env`配置，打开容器页面，连接终端，运行相关命令。

- 第一步，安装应用后，修改`.env`配置文件，填写`MySQL`、`redis`等相关信息
```
# 需要修改以下为具体实际路径
/opt/1panel/apps/local/chemex/xxx/data/.env
```

- 第二步，容器运行命令，初始化导入数据库
```
cd /var/www/html/laravel && php artisan chemex:install
```
容器终端会提示相关安装情况以及账户密码信息。

- 第三步，容器运行命令，授予文件夹权限
```
chown -R www-data /var/www/html/laravel/bootstrap/cache
```

## 参考资料
- 官网: <https://hub.docker.com/r/celaraze/chemex>
- 文档: <https://github.com/celaraze/chemex>
