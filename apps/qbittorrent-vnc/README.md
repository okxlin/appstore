# qBittorrent-VNC

## 应用简介
适用于Kasm Workspaces 的 qBittorrent。

英文说明：qBittorrent for Kasm Workspaces.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：arm64、amd64。
- 可选版本：`1.19.0`、`develop`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 (需要手动设置) | 40139 | 是 |
| PANEL_APP_PORT_HTTPS | Web VNC 端口 | 40140 | 是 |
| PANEL_APP_PORT_PEER | BT端口 (需要手动设置) | 40141 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOWNLOAD_PATH | 下载文件夹路径 | ./data/downloads | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HTTP_USER | HTTP 用户 | kasm_user | 是 |
| HTTP_PWD | 访问密码 | password | 是 |
| MEM_USE | 共享内存占用(1gb) | 512m | 是 |

## 使用说明
- 访问链接协议`https`

- 默认账户密码
```
username: kasm_user
password: password
```

- 假如重启出现异常

大概率可能是文件夹权限原因，需要将应用数据文件夹`data`赋予用户权限，

终端运行以下命令，按需修改。

```
chown -R 1000:1000 /opt/1panel/apps/local/qbittorrent-vnc/qbittorrent-vnc/data
```

## 参考资料
- 官网: <https://www.qbittorrent.org/>
- 文档: <http://wiki.qbittorrent.org/>
- 源码: <https://github.com/qbittorrent/qBittorrent>
