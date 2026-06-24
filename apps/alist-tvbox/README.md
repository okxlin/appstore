# Alist-TVBox

## 应用简介
AList 代理，支持 xiaoya 版 AList 界面管理。

英文说明：AList proxy server for TvBox, support playlist and search.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40161 | 是 |
| PANEL_APP_PORT_XIAOYA | 小雅 Alist 端口 | 40162 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
**默认用户名：`admin` 密码：`admin`**

## 参考资料
- 官网: <https://github.com/power721/alist-tvbox>
