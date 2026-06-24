# ZeroTier-One

## 应用简介
多点虚拟化网络解决方案。

英文说明：A Smart Ethernet Switch for Earth.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.14.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 9993 | 是 |

## 数据持久化
- `./data:/var/lib/zerotier-one`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
例子：容器管理界面连接容器终端，执行命令加入网络
```
zerotier-cli join [网络ID]
```

## 参考资料
- 官网: <https://www.zerotier.com>
- 文档: <https://docs.zerotier.com>
- 源码: <https://github.com/zerotier/ZeroTierOne>
