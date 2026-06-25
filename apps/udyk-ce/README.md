# 友得云客房产系统（社区版)

## 应用简介
为房产行业打造的开源的线上营销获客系统。

英文说明：An open-source online marketing and customer acquisition system tailored for the real estate industry.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`6.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40320 | 是 |

## 数据持久化
- `"./data/tmp:/tmp`
- `"./data/upload:/app/filestore`
- `"./data/upload:/app/upload/`
- `./data/redis:/data`
- `./data/mysql:/var/lib/mysql`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- **注意，容器以`privileged`特权模式运行，注意安全问题。**

- 此程序为多容器编排，有安装`MySQL`，注意硬件性能。

- 容器名等参数通过编排锁死，面板设置无效，更新升级可通过替换`compose.yml`重建，详情查看程序官方文档。

***

- [产品官网](https://www.youdeyunke.com/?statId=6)
- [帮助文档](https://youdeyunke.yuque.com/r/organizations/homepage)

## 参考资料
- 官网: <https://www.youdeyunke.com>
- 文档: <https://youdeyunke.yuque.com/r/organizations/homepage>
- 源码: <https://github.com/youdeyunke/app>
