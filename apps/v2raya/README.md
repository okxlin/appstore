# v2rayA

## 应用简介
支持全局透明代理的 Project V 的 Linux 客户端。

英文说明：A web GUI client of Project V.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2.2.7`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 | 40052 | 是 |
| PLUGIN_PORT | 内部插件端口 | 32346 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 使用方法

v2rayA主要提供了下述使用方法：

1. 软件源安装
2. docker
3. 二进制文件、安装包

详见 [**v2rayA - Docs**](https://v2raya.org/docs/prologue/introduction/)

## 参考资料
- 官网: <https://v2raya.org>
- 文档: <https://v2raya.org/docs/prologue/introduction/>
- 源码: <https://github.com/v2rayA/v2rayA>
