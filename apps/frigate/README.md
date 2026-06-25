# Frigate

## 应用简介
一个开源的实时视频监控系统。

英文说明：NVR With Realtime Object Detection for IP Cameras.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`stable`、`0.17.1`、`0.17.1-standard-arm64`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTPS | 端口 | 8971 | 是 |
| RTSP_PORT | RTSP 端口 | 8554 | 是 |
| WEBRTC_TCP_PORT | WebRTC TCP 端口 | 8555 | 是 |
| WEBRTC_UDP_PORT | WebRTC UDP 端口 | 8555 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| STORAGE_PATH | 存储路径 | ./data/storage | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PRIVILEGED_MODE | 特权模式 | true | 是 |
| SHM_SIZE | 共享内存大小 | 64mb | 是 |
| TMPFS_SIZE | Tmpfs 大小 | 1000000000 | 是 |
| FRIGATE_RTSP_PASSWORD | RTSP 密码 | password | 是 |

## 使用说明
用户名与密码通过查看容器日志获取

## 参考资料
- 官网: <https://frigate.video>
- 文档: <https://frigate.video/docs/>
- 源码: <https://github.com/blakeblackshear/frigate>
