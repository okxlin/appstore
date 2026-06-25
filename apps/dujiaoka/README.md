# 独角数卡

## 应用简介
开源站长自动化售货解决方案。

英文说明：Open-source automated sales solution for webmasters.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40256 | 是 |

## 数据持久化
- `./data/env.conf:/dujiaoka/.env`
- `./data/uploads:/dujiaoka/public/uploads`
- `./data/storage:/dujiaoka/storage`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| INSTALL | 是否进行初始化安装 | true | 是 |
| MODIFY | 是否已修改 | false | 是 |

## 使用说明
- 1. 安装时需要先创建 MySQL 数据库
- 2. 首次安装，不需要在意运行是否正常，需要先填写应用目录下的配置文件，例如`/opt/1panel/apps/local/dujiaoka/dujiaoka/data/env.conf`，然后重建应用
- 3. 填写`env.conf`完成后，然后访问端口进入初始化安装，填写相关数据库与 redis 信息，要与`env.conf`一致
- 4. 完成安装后点击编辑应用参数，将`是否进行初始化安装`的选项改为`false`，保存确定后就会重建应用

## 参考资料
- 官网: <https://github.com/assimon/dujiaoka>
