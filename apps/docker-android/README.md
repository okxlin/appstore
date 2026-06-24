# Docker-Android

## 应用简介
在 Docker 中运行 Android。

英文说明：Run Android in Docker.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40288 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| IMAGE | 容器镜像 | budtmo/docker-android:latest | 是 |
| RESTART_POLICY | 重启策略 | always | 是 |
| EMULATOR_DEVICE | 模拟的设备 | Samsung Galaxy S10 | 是 |
| WEB_VNC | Web VNC | true | 是 |

## 使用说明
要验证您的系统是否支持 KVM，请运行以下命令：

```
sudo apt install cpu-checker
sudo kvm-ok
```

**容器镜像与模拟的设备型号可从以下选择 (后续官方可能有修改，以官方文档为准)**

Docker 镜像列表
---------------------
|Android   |API   |最新版本镜像   |指定版本镜像|
|:---|:---|:---|:---|
|9.0|28|budtmo/docker-android:emulator_9.0|budtmo/docker-android:emulator_9.0_<release_version>|
|10.0|29|budtmo/docker-android:emulator_10.0|budtmo/docker-android:emulator_10.0_<release_version>|
|11.0|30|budtmo/docker-android:emulator_11.0|budtmo/docker-android:emulator_11.0_<release_version>|
|12.0|32|budtmo/docker-android:emulator_12.0|budtmo/docker-android:emulator_12.0_<release_version>|
|13.0|33|budtmo/docker-android:emulator_13.0|budtmo/docker-android:emulator_13.0_<release_version>|
|14.0|34|budtmo/docker-android:emulator_14.0|budtmo/docker-android:emulator_14.0_<release_version>|
|-|-|budtmo/docker-android:genymotion|budtmo/docker-android:genymotion_<release_version>|

设备列表
---------------

|类型   | 设备名称|
|-----  | -----|
|手机  | Samsung Galaxy S10|
|手机  | Samsung Galaxy S9|
|手机  | Samsung Galaxy S8|
|手机  | Samsung Galaxy S7 Edge|
|手机  | Samsung Galaxy S7|
|手机  | Samsung Galaxy S6|
|手机  | Nexus 4|
|手机  | Nexus 5|
|手机  | Nexus One|
|手机  | Nexus S|
|平板 | Nexus 7|

## 参考资料
- 官网: <https://github.com/budtmo/docker-android>
