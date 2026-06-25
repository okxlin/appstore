# ESPHome

## 应用简介
简单强大的 ESP8266/ESP32 配置与固件编译工具。

英文说明：ESPHome is a system to control your ESP8266/ESP32 by simple yet powerful configuration files.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 6052 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ESPHOME_USERNAME | 控制台用户名 | admin | 是 |
| ESPHOME_PASSWORD | 控制台密码 | - | 是 |

## 使用说明
- **默认访问地址**
  ESPHome Dashboard 默认运行在 6052 端口：
  ```
  IP:6052
  ```

### 注意事项：
1. **网络模式**：本应用使用 `host` 网络模式。ESPHome 官方文档说明，Device Builder 在 Docker 中需要 host 网络模式来显示设备在线状态。
2. **特权模式**：本应用默认不启用 `privileged`。官方文档中的 `--privileged` 用于通过 USB 串口首次烧录固件，并且需要同时映射串口设备，例如 `/dev/ttyUSB0`。仅运行 Dashboard、编译固件、OTA 更新不需要默认开启特权模式。
3. **USB 烧录**：如果您需要从服务器通过 USB 串口直接烧录固件，请根据实际设备路径手动调整 compose，例如映射 `/dev/ttyUSB0`。也可以使用 ESPHome Web 或 esptool 完成首次烧录，之后再通过 OTA 更新。

官方参考：
- https://esphome.io/guides/getting_started_command_line/#bonus-esphome-device-builder
- https://esphome.io/guides/getting_started_command_line/#first-uploading

## 参考资料
- 官网: <https://esphome.io/>
- 文档: <https://esphome.io/guides/getting_started_command_line/>
- 源码: <https://github.com/esphome/esphome>
