# OpenVPN Access Server

## 应用简介
开源 VPN 解决方案。

英文说明：Open-source VPN solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具、安全。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_CONSOLE | 控制台端口 | 40239 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 443 | 是 |
| PANEL_APP_PORT_UDP | UDP 端口 | 1194 | 是 |

## 数据持久化
- `"./data:/openvpn`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
管理界面位于 `https://IP:控制台端口/admin`，默认用户为 `openvpn` ，密码可以在 docker 日志中找到（在第一次初始运行时）
- 类似：
```
 Auto-generated pass = "Cj0YsADgHA6n". Setting in db...
```
***

![openvpn-as](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/OpenVPN_logo.svg/2560px-OpenVPN_logo.svg.png)

## 参考资料
- 官网: <https://openvpn.net/>
- 文档: <https://openvpn.net/access-server-manual/introduction/>
- 源码: <https://github.com/OpenVPN/openvpn>
