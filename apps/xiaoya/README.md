# 小雅 Alist (xiaoya)

## 应用简介
基于 Alist 的网盘聚合站。

英文说明：Alist-based cloud disk aggregation station.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40160 | 是 |

## 数据持久化
- `"./data:/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
第一次安装会失败，需要手动获取所需配置。

**参考指南配置文件**：https://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f

然后编辑应用目录下`data`文件夹下的对应文件，重启容器即可

***

## 参考资料
- 官网: <http://alist.xiaoya.pro>
- 文档: <https://www.notion.so/xiaoyaliu/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f>
- 源码: <https://hub.docker.com/r/xiaoyaliu/alist>
