# TwoNav

## 应用简介
一款开源免费的书签（导航）管理程序。

英文说明：An open source free bookmark (navigation) management program.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：arm、arm64、amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40169 | 是 |

## 数据持久化
- `"./data:/www`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 此程序需要外挂源码，原生`docker-compose`运行的话，需要事先在应用数据目录下创建`data`文件夹，然后下载并解压源码到的`data`文件夹里。

- 默认`v1.7+`版本的`1Panel`部署时会自动调用脚本进行本应用源码下载，假如存在问题则可以手动下载源码或者修改目录下的`init.sh`脚本里的相关下载链接。

***

## 参考资料
- 官网: <https://hub.docker.com/r/tznb/twonav>
- 文档: <https://gitee.com/tznb/TwoNav/wikis>
- 源码: <https://github.com/tznb1/TwoNav>
