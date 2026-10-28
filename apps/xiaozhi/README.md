## 什么是 Xiaozhi ESP32 Server？

**Xiaozhi ESP32 Server** 是小智 AI 聊天机器人（[xiaozhi-esp32](https://github.com/78/xiaozhi-esp32)）硬件的 Java 企业级服务端，由 [xiaozhi-esp32-server-java](https://github.com/joey-zhou/xiaozhi-esp32-server-java) 项目提供，采用 Spring Boot 3 + Vue 3 技术栈，提供「管理前端 + 服务端」一体化解决方案。

## 核心功能

- **设备监控**：在线状态、实时对话、设备绑定一站式管理；
- **音色定制**：内置多引擎语音识别与合成（本地 VOSK / Sherpa + Edge TTS / 火山引擎等），支持音色与语速调节；
- **角色切换**：自定义智能体人设与提示词模板，一键切换对话角色；
- **对话记录**：完整对话历史与录音回放，支持知识库增强问答；
- **多端接入**：ESP32 设备（WebSocket）、小程序与 Web 管理端。

## 安装后使用

1. 等待全部容器变为 healthy（首次启动需执行数据库迁移，约 1~2 分钟）；
2. 打开管理界面 `http://服务器IP:管理界面端口`，默认账号 `admin` / 密码 `123456`，**登录后请立即修改密码**；
3. 在管理后台「模型管理」中配置大模型 API Key 后即可对话（系统不预置任何密钥）；
4. ESP32 设备接入：将设备固件的 OTA 地址设置为 `http://服务器IP:API端口/api/device/ota`，设备即可通过 WebSocket 端口建立实时对话。

> 提示：语音识别默认使用内置本地模型，语音合成默认使用免费 Edge TTS，开箱即用；如需更高识别/合成质量，可在后台切换为第三方 API。

## 端口说明

| 端口 | 用途 |
| ---- | ---- |
| 管理界面端口（默认 8084） | Web 管理后台 |
| API / OTA 端口（默认 8091） | 服务端 API 与设备 OTA |
| 设备 WebSocket 端口（默认 8092） | ESP32 设备实时语音对话 |

## 资源需求

推荐 2 核 CPU / 4GB 以上可用内存（服务端与对话服务各预留 2GB）。

## 更多文档

- [项目主页](https://github.com/joey-zhou/xiaozhi-esp32-server-java)
- [Docker 部署文档](https://github.com/joey-zhou/xiaozhi-esp32-server-java/blob/main/docs/DOCKER.md)
- [配置说明](https://github.com/joey-zhou/xiaozhi-esp32-server-java/blob/main/docs/CONFIGURATION.md)
- [固件编译与烧录](https://github.com/joey-zhou/xiaozhi-esp32-server-java/blob/main/docs/FIRMWARE-BUILD.md)
