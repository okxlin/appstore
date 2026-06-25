# Slink

## 应用简介
图像共享平台（图床）。

英文说明：Image Sharing Platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.12.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40236 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |
| IMAGE_STRIP_EXIF_METADATA | 剥离 EXIF 元数据 | true | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ORIGIN | 外部访问地址 (只有 https 环境才能注册登录，需要反向代理) | https://your-domain.com | 是 |
| USER_APPROVAL_REQUIRED | 是否需要用户批准才能上传图像 | true | 是 |
| USER_ALLOW_UNAUTHENTICATED_ACCESS | 允许未认证访问 | true | 是 |
| USER_PASSWORD_MIN_LENGTH | 用户密码最小长度 | 6 | 是 |
| USER_PASSWORD_REQUIREMENTS | 用户密码要求 (以下选项的总和：1-数字、2-小写、4-大写、8-特殊字符) | 15 | 是 |
| IMAGE_MAX_SIZE | 图片最大尺寸(不超过50M) | 15M | 是 |
| STORAGE_PROVIDER | 存储提供商 | local | 是 |
| SMB_HOST | SMB 主机 | - | 否 |
| SMB_USERNAME | SMB 用户名 | - | 否 |
| SMB_PASSWORD | SMB 密码 | - | 否 |

## 使用说明
必须要开启`https`的情况下才能正常注册登录账号。

按照要求创建账号，例如邮箱`admin@localhost.com`，

如果创建账号正常，则会提示除了邮箱外还可以复制对应`uuid`，

那么则需要执行相关命令激活此账号。

- 1. 宿主机执行的方式
```
# 邮箱方式
docker exec -it slink slink user:activate --email=admin@localhost.com
```
```
# uuid 方式
docker exec -it slink slink user:activate --uuid=<user-id>
```

- 2. 容器管理页面连接容器终端执行的方式
```
# 邮箱方式
slink user:activate --email=admin@localhost.com
```
```
# uuid 方式
slink user:activate --uuid=<user-id>
```

- 3. 有得到终端返回信息例如以下，则表示账号激活成功，可以正常登录了。

```
User `admin@localhost.com` has been activated ✓
```

***

## 参考资料
- 官网: <https://github.com/andrii-kryvoviaz/slink>
