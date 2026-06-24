# Rathole

## 应用简介
安全、稳定、高性能的内网穿透工具。

英文说明：A secure, stable and high-performance reverse proxy for NAT traversal.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.5.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 (由配置文件决定) | 7333 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/server.toml | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SERVICE_MODE | 服务模式 | server | 是 |

## 使用说明
- 配置文件如何编写参考原项目说明。
- 所需的证书可以使用应用目录下的`create_self_signed_cert.sh`脚本来生成。

## 参考资料
- 官网: <https://github.com/rapiz1/rathole>
- 文档: <https://github.com/rapiz1/rathole/blob/main/README-zh.md>
