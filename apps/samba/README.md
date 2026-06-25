# Samba

## 应用简介
多架构 Samba 镜像构建。

英文说明：Multi-architecture Samba image build.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：存储。
- 支持架构：amd64、arm64、ppc64le、s390x、386、armv7、armv6。
- 可选版本：`latest`、`4.21.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 139 | 是 |
| PANEL_APP_PORT_SMB | 端口 | 445 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 外部数据路径 | ./data | 是 |
| INTERNAL_DATA_PATH | 容器内部数据路径 | /share/data | 是 |
| SHARE_1 | 共享 1 | SmbShare:/share/folder:rw:pirate | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOSTNAME | 主机名 | samba | 是 |
| USER_1 | 用户 1 | 1000:1000:pirate:pirate:put-any-password-here | 是 |
| USER_2 | 用户 2 (编辑去除compose.yml里的注释生效) | - | 否 |
| SHARE_2 | 共享 2 (编辑去除compose.yml里的注释生效) | - | 否 |
| USER_3 | 用户 3 (编辑去除compose.yml里的注释生效) | - | 否 |
| SHARE_3 | 共享 3 (编辑去除compose.yml里的注释生效) | - | 否 |

## 使用说明
Container will be configured as samba sharing server and it just needs:  
容器将被配置为 samba 共享服务器，它只需要：

- host directories to be mounted,  
    要挂载的主机目录，
- users (one or more uid:gid:username:usergroup:password tuples) provided,  
    提供的用户（一个或多个 uid:gid:用户名:用户组:密码元组），
- shares defined (name, path, users).  
    定义的共享（名称、路径、用户）。

\-u uid:gid:username:usergroup:password  
\-u uid:gid:用户名:用户组:密码

- uid from user p.e. 1000  
    用户 p.e. 的 uid 1000
- gid from group that user belong p.e. 1000  
    来自用户所属组的 gid p.e. 1000
- username p.e. alice 用户名爱丽丝
- usergroup (the one to whom user belongs) p.e. alice  
    用户组（用户所属的组）p.e.爱丽丝
- password (The password may be different from the user's actual password from your host filesystem)  
    密码（该密码可能与主机文件系统中用户的实际密码不同）

\-s name:path:rw:user1\[,user2\[,userN\]\]  
\-s 名称:路径:rw:用户1\[,用户2\[,用户N\]\]

- add share, that is visible as 'name', exposing contents of 'path' directory for read+write (rw) or read-only (ro) access for specified logins user1, user2, .., userN  
    添加共享，即显示为“名称”，公开“路径”目录的内容，以供指定登录 user1、user2、..、userN 进行读+写 (rw) 或只读 (ro) 访问

## 参考资料
- 官网: <https://deft.work/samba>
- 文档: <https://github.com/DeftWork/samba>
