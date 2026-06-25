# 1Panel

## 应用简介
现代化、开源的 Linux 服务器运维管理面板。

英文说明：Modern and Open-Source Linux Server Operation and Management Panel.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.10.34-lts`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 (由监听端口决定) | 10086 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据存放文件夹 | /opt | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
### 镜像 Github：https://github.com/okxlin/docker-1panel

### 镜像 Docker Hub：https://hub.docker.com/r/moelin/1panel

如果更新了更高版本的镜像，实际是更新了对应版本的二进制程序，面板显示的相关版本还需要手动更新，具体操作可以查看[**Github**](https://github.com/okxlin/docker-1panel)。

**不要点击容器化部署的 `1Panel` 右下角进行更新，应该拉取新镜像再更新**
***
- 默认端口：`10086`
- 默认账户：`1panel`
- 默认密码：`1panel_password`
- 默认入口：`entrance`
***
- 不可调整参数
  - `/var/run/docker.sock`的相关映射
 ***
- 可调整参数
> **推荐使用/opt路径，否则有些调用本地文件的应用可能出现异常**
  - `/opt:/opt`                        文件存储映射
  - `/root:/root`                        文件存储映射
  - `TZ=Asia/Shanghai`                        时区设置
  - `1panel`                          容器名
  - `/var/lib/docker/volumes:/var/lib/docker/volumes` 存储卷映射
***
**架构平台对应镜像**
- amd64
- arm64
- armv7
- ppc64le
- s390x
> 2023年9月3日已经更新单标签多镜像
```
docker pull moelin/1panel:latest
```

## 参考资料
- 官网: <https://1panel.cn>
- 文档: <https://1panel.cn/docs>
- 源码: <https://github.com/1Panel-dev/1Panel>
