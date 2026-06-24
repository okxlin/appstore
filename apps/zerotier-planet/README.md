# ZeroTier-Planet

## 应用简介
具有 Web UI 的 ZeroTier 网络控制器。

英文说明：Zerotier network controller with web UI in a Docker container.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.2.18`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 控制台端口 | 40119 | 是 |
| PANEL_APP_PORT_SERVER | ZeroTier服务端口 | 9993 | 是 |
| PANEL_APP_PORT_DOWNLOAD | planet/moon文件在线下载端口 | 40120 | 是 |

## 数据持久化
- `./data/zerotier-one:/var/lib/zerotier-one`
- `./data/etc:/opt/key-networks/ztncui/etc`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOST_IP_ADDR | 本机IP地址 | - | 是 |
| PASSWORD | 密码 | zerotier | 是 |

## 使用说明
- 默认用户名`admin`

## 参考资料
- 官网: <https://github.com/Jonnyan404/zerotier-planet>
