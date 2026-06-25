# 1Panel Apps

## 应用简介
适配 1Panel 应用商店的通用应用模板。

英文说明：Universal app template for the 1Panel App Store.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`bridge-network`、`host-network`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40329 | 是 |
| PANEL_APP_PORT_HTTP_INTERNAL | 内部端口 | 40329 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |
| DATA_PATH_INTERNAL | 内部数据路径 | /data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| IMAGE | Docker 镜像 | - | 是 |
| RESTART_POLICY | 重启策略 | always | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| ENV1 | 环境变量 1 (编辑去除compose.yml里的注释生效) | - | 否 |

## 使用说明
- 可以按需修改安装界面的参数

- 也可以直接忽视安装界面提供的参数，然后勾选`“高级设置”`，勾选`“编辑compose文件”`，使用自定义的 `docker-compose.yml`文件

## 参考资料
- 官网: <https://github.com/okxlin/appstore>
