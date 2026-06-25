# WireGuard-UI

## 应用简介
Wireguard 网络界面。

英文说明：Wireguard web interface.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.6.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 | 40073 | 是 |
| PANEL_APP_PORT_WIREGUARD | Wireguard 端口 | 51820 | 是 |

## 数据持久化
- `./data/db:/app/db`
- `./data/config:/etc/wireguard`
- `./data/config:/config`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| WEBUI_USER | 网页用户 | admin | 是 |
| WEBUI_PWD | 网页密码 | password | 是 |

## 使用说明
新版本的镜像假如遇到网页登录存在问题，或许可以尝试重启应用再登录。

假如无效，则可以在 1Panel 高级设置里编辑应用`compose`文件调整以下参数，具体可以查看原项目说明。

```
      - WGUI_MANAGE_START=false
      - WGUI_MANAGE_RESTART=true
```

## 参考资料
- 官网: <https://www.wireguard.com/>
- 源码: <https://github.com/ngoduykhanh/wireguard-ui>
