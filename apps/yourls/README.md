# YOURLS

## 应用简介
PHP驱动的标准自托管URL缩短器。

英文说明：The de facto standard self hosted URL shortener in PHP.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.10.4`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40037 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | yourls | 是 |
| PANEL_DB_USER | 数据库用户 | yourls | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | yourls | 是 |
| PANEL_DB_PREFIX | 数据库前缀 | yourls_ | 是 |
| USERNAME | 用户 | yourls | 是 |
| PASSWORD | 用户密码 | yourls | 是 |
| YOURLS_EXTERNAL_URL | 外部访问地址 | http://localhost:40037 | 是 |

## 使用说明
- 初始化设置

注意：首次实例化时，访问根文件夹将生成错误。通过路径 `/admin/` 访问 `YOURLS` 管理界面。

假如外部访问地址设置为`http://localhost:40037`，

那么需要访问`http://localhost:40037/admin/`进行初始化设置

## 参考资料
- 官网: <https://yourls.org/>
- 文档: <https://yourls.org/docs>
- 源码: <https://github.com/YOURLS/YOURLS>
