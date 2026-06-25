# BT-Panel

## 应用简介
宝塔面板，服务器运维管理面板。

英文说明：BT-Panel , Server O&M management panel.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 面板端口 | 8888 | 是 |
| HTTP_PORT | HTTP端口 | 10080 | 是 |
| HTTPS_PORT | HTTPS端口 | 10443 | 是 |
| PHPMYADMIN_PORT | phpMyAdmin端口 | 10888 | 是 |
| SSH_PORT | 面板内SSH端口 | 20022 | 是 |
| FTP_PORT | 面板内FTP端口 | 20021 | 是 |

## 使用说明
这是个民间制作的`宝塔面板`的`1Panel`商店版本应用;

- WebUI入口：`http://IP地址:面板端口/btpanel`
- 默认账号：`btpanel`
- 密码：`btpaneldocker`
- 容器默认SSH密码：`btpaneldocker`

> 容器内数据
- 网站目录:`/www/wwwroot`
- MySQL目录:`/www/server/data`
- 域名数据:`/www/server/panel/vhost`

> 原作者项目相关
>> - https://hub.docker.com/r/btpanel/baota
>> - https://github.com/aaPanel/BaoTa

- 提示：为数据持久化运行，相关数据以存储卷方式存储。

## 参考资料
- 官网: <https://www.bt.cn/>
- 文档: <http://docs.bt.cn/>
- 源码: <https://github.com/aaPanel/BaoTa>
