# Piper

## 应用简介
Piper 文本转语音 Wyoming 服务。

英文说明：Text to speech Wyoming service maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2.2.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_WYOMING | Wyoming 端口 | 10200 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PIPER_VOICE | Piper 语音 | en_US-lessac-medium | 是 |
| PIPER_LENGTH | 语音语速，低于 1.0 更快，高于 1.0 更慢 | 1.0 | 否 |
| PIPER_NOISE | 语音变化噪声，过高会降低质量 | 0.667 | 否 |
| PIPER_NOISEW | 语调节奏噪声，过高可能导致停顿异常 | 0.333 | 否 |
| PIPER_SPEAKER | 多说话人语音模型的说话人编号 | 0 | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/rhasspy/piper>
- 文档: <https://docs.linuxserver.io/images/docker-piper/>
- 源码: <https://github.com/linuxserver/docker-piper>
