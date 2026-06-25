# Alist

## 应用简介
一个支持多存储的文件列表程序。

英文说明：A file list program that supports multiple storage.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.44.0`、`aria2-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40034 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data/data | 是 |
| MOUNT_PATH | 挂载文件夹路径 | ./data/mnt | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 账户与密码

查看容器日志，或者容器功能界面找到`alist`的容器，点击终端连接到容器内部， 运行
```
./alist admin
```

## 参考资料
- 官网: <https://github.com/alist-org/alist>
- 文档: <https://alist.nn.ci/zh/>
