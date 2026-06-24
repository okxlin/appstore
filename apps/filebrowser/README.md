# File Browser

## 应用简介
网页文件浏览器。

英文说明：Web File Browser.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2.63.16`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40071 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MOUNT_PATH | 挂载文件夹路径 | ./data/mnt | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 默认账户密码

```
username：admin
password：admin
```

## 参考资料
- 官网: <https://filebrowser.org/>
- 源码: <https://github.com/filebrowser/filebrowser>
