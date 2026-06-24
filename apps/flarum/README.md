# flarum

## 应用简介
新一代的论坛软件，使在线讨论变得有趣。

英文说明：The next-generation forum software that makes online discussion fun.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`1.8.10`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40020 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据存放文件夹 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | flarum | 是 |
| PANEL_DB_USER | 数据库用户 | flarum | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | flarum | 是 |
| PANEL_DB_PREFIX | 数据库前缀 | flarum_ | 是 |
| FLARUM_EXTERNAL_URL | 外部访问地址 | http://localhost:40020 | 是 |

## 使用说明
### 账户密码
- 初始账户: flarum
- 初始密码: flarum

### 中文语言包

> 中文语言包：
>> - https://github.com/flarum-lang/chinese-simplified 

使用说明：

- Flarum v0.1.0-beta.8 及以上版本

进入容器终端运行以下安装中文语言包，详细可查看原项目文档。
```
composer require flarum-lang/chinese-simplified
php flarum cache:clear
```

### 所使用docker镜像相关:

> 项目链接
>> - https://hub.docker.com/r/crazymax/flarum
>> - https://github.com/crazy-max/docker-flarum

## 参考资料
- 官网: <https://flarum.org/>
- 文档: <https://docs.flarum.org/>
- 源码: <https://github.com/flarum/flarum>
