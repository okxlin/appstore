# 今日热榜 DailyHot Web

## 应用简介
一个聚合了中文热门站点数据的项目(前端)。

英文说明：A project that aggregates data for Chinese popular sites (web).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40142 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| API_URL | API接口地址 (请自行搭建) | https://hot-api.bbit.fun | 是 |
| ICP_TEXT | ICP地址 (自行填写) | 没有备案，这里填写备案ICP | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hot.imsyy.top>
- 文档: <https://github.com/imsyy/DailyHot>
