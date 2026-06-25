# HertzBeat

## 应用简介
一个易用友好的开源实时监控告警系统。

英文说明：An open source, real-time monitoring system with custom-monitoring.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.8.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40066 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 默认账户密码
```
username：admin
password：hertzbeat
```

## 参考资料
- 官网: <https://hertzbeat.com/>
- 文档: <https://hertzbeat.com/docs/>
- 源码: <https://github.com/dromara/hertzbeat>
