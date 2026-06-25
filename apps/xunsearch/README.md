# 迅搜 Xunsearch

## 应用简介
一个高性能、全功能的全文检索解决方案。

英文说明：A high-performance, full-featured full-text search solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| INDEX_SERVER_PORT | 索引服务端配置端口 | 40110 | 是 |
| SEARCH_SERVER_PORT | 搜索服务端配置端口 | 40111 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <http://www.xunsearch.com>
- 文档: <http://www.xunsearch.com/doc/php>
- 源码: <https://github.com/hightman/xunsearch>
