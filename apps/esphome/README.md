# 使用说明

- **默认访问地址**
  ESPHome Dashboard 默认运行在 6052 端口：
  ```
  IP:6052
  ```

# 关于 ESPHome

将 ESP32、ESP8266、BK72xx、RP2040 和其他支持的板子通过简单的 YAML 配置转变为强大的智能家居设备。

### 主要特性：
- **无需编程**：使用简单的 YAML 配置文件而不是复杂的 C++代码。
- **无线更新**：通过OTA升级您的设备，无需物理访问。
- **模块化设计**：支持数百种传感器、显示屏和其他组件。
- **本地控制**：设备本地运行，无需依赖云服务。

### 谁使用 ESPHome？
  - **DIY 爱好者** - 创建定制传感器、开关和显示屏，满足特定需求
  - **智能家居爱好者** - 用经济实惠的定制设备扩展他们的智能家居系统
  - **专业集成商** - 为客户部署可靠、本地控制的智能设备
  - **制造商** - 创建适用于 ESPHome 认证的产品，配备标准化固件

### ESPHome 支持哪些微控制器？
  - **Espressif ESP32 和 ESP8266** - 广泛支持 ESP32 和 ESP8266 微控制器，许多物联网项目的核心。
  - **RP2040** - 支持树莓派的 RP2040 微控制器。
  - **其他** - 支持 Nordic Semiconductor nRF52、Realtek RTL87xx 和 Becken BK72xx 芯片。
  - **桌面** - 许多 ESPHome 组件可以在使用主机平台的情况下在桌面计算机上运行！

### 注意事项：
1. **网络模式**：本应用使用 `host` 网络模式。ESPHome 官方文档说明，Device Builder 在 Docker 中需要 host 网络模式来显示设备在线状态。
2. **特权模式**：本应用默认不启用 `privileged`。官方文档中的 `--privileged` 用于通过 USB 串口首次烧录固件，并且需要同时映射串口设备，例如 `/dev/ttyUSB0`。仅运行 Dashboard、编译固件、OTA 更新不需要默认开启特权模式。
3. **USB 烧录**：如果您需要从服务器通过 USB 串口直接烧录固件，请根据实际设备路径手动调整 compose，例如映射 `/dev/ttyUSB0`。也可以使用 ESPHome Web 或 esptool 完成首次烧录，之后再通过 OTA 更新。

官方参考：
- https://esphome.io/guides/getting_started_command_line/#bonus-esphome-device-builder
- https://esphome.io/guides/getting_started_command_line/#first-uploading
