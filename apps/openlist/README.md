# OpenList

## 应用简介
一个支持多种存储的文件列表程序。

英文说明：A file list program that supports multiple storage.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：存储、工具。
- 支持架构：amd64、arm64、ppc64le、armv6、armv7、loong64、riscv64。
- 可选版本：`latest`、`4.2.2`、`4.2.2-aio`、`4.2.2-aria2`、`4.2.2-ffmpeg`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 | 40337 | 是 |
| PANEL_APP_PORT_S3 | S3 端口 | 5246 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data/data | 是 |
| MOUNT_PATH | 挂载文件夹路径 | ./data/mnt | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
### 默认账户密码

容器列表点击 `终端` 按钮，进入容器内执行命令设置密码。

- **生成随机密码**: `./openlist admin random`
- **手动设置密码**: `./openlist admin set NEW_PASSWORD`

## 参考资料
- 官网: <https://docs.oplist.org/>
- 源码: <https://github.com/OpenListTeam/OpenList>
