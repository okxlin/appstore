# ErisPulse

事件驱动的多平台机器人开发框架

## 产品介绍

ErisPulse 是一个基于 Python 的事件驱动型多平台机器人开发框架，通过统一的 OneBot12 标准接口，一次编写代码即可在云湖、Telegram、OneBot 等多个平台部署机器人。

## 默认账户信息

安装时设置的 Dashboard 令牌即为登录密码，首次访问需使用该令牌登录。

## 主要功能

- **事件驱动架构** - 基于 OneBot12 标准的清晰事件模型
- **跨平台支持** - 一次编写模块，所有平台运行
- **模块化设计** - 灵活的插件系统，易于扩展
- **热重载** - 无需重启即可重载代码
- **完整工具链** - CLI 工具、包管理器和自动化脚本

## 配置说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| 端口 | Dashboard Web 访问端口 | 8000 |
| 数据路径 | 配置文件存储路径 | ./data |
| 时区 | 容器时区设置 | Asia/Shanghai |
| Dashboard 令牌 | Dashboard 登录密码（必填） | 自动生成 |
| 更新频道 | 稳定版或开发版 | 稳定版 (Stable) |
| 启动时自动更新 | 容器启动时自动检查更新 | 关闭 |

## 使用说明

1. 安装完成后，浏览器访问 `http://<IP>:<端口>/Dashboard`
2. 使用安装时设置的 Dashboard 令牌登录
3. 在 Dashboard 中配置适配器和插件

## 注意事项

- 数据路径下的配置文件会在首次启动时自动生成
- 开启「启动时自动更新」后每次容器重启会检查 PyPI 最新版本
- 选择「开发版」频道将拉取预发布版本，可能存在不稳定情况

## 相关链接

- 官网: https://www.erisdev.com
- GitHub: https://github.com/ErisPulse/ErisPulse
- Docker Hub: https://hub.docker.com/r/erispulse/erispulse
- 文档: https://github.com/ErisPulse/ErisPulse
