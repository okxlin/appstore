# Warp-Docker

## 应用简介
在 Docker 中运行 Cloudflare WARP。

英文说明：Run Cloudflare WARP in Docker.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40244 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| WARP_SLEEP | Warp 睡眠时间 | 2 | 是 |
| WARP_LICENSE_KEY | Warp 许可证密钥 | - | 否 |

## 使用说明
检测是否运行正常，端口按需修改。
```
curl --socks5 127.0.0.1:40244 https://cloudflare.com/cdn-cgi/trace
```

如果输出包含 `warp=on` 或 `warp=plus`，说明容器工作正常。如果输出包含 `warp=off`，则表示容器未能连接到 `WARP` 服务

## 参考资料
- 官网: <https://hub.docker.com/r/caomingjun/warp>
- 文档: <https://github.com/cmj2002/warp-docker>
