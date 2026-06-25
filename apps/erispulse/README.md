# ErisPulse

## 应用简介
事件驱动的多平台机器人开发框架。

英文说明：Event-driven multi-platform bot development framework.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| ERISPULSE_DASHBOARD_TOKEN | Dashboard 登录令牌 | - | 是 |
| ERISPULSE_CHANNEL_SELECT | 更新频道 | stable | 是 |
| ERISPULSE_UPDATE_ON_START | 启动时自动更新 | false | 是 |

## 使用说明
### 默认账户信息

安装时设置的 Dashboard 令牌即为登录密码，首次访问需使用该令牌登录。

### 配置说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| 端口 | Dashboard Web 访问端口 | 8000 |
| 数据路径 | 配置文件存储路径 | ./data |
| 时区 | 容器时区设置 | Asia/Shanghai |
| Dashboard 令牌 | Dashboard 登录密码（必填） | 自动生成 |
| 更新频道 | 稳定版或开发版 | 稳定版 (Stable) |
| 启动时自动更新 | 容器启动时自动检查更新 | 关闭 |

### 使用说明

1. 安装完成后，浏览器访问 `http://<IP>:<端口>/Dashboard`
2. 使用安装时设置的 Dashboard 令牌登录
3. 在 Dashboard 中配置适配器和插件

### 注意事项

- 数据路径下的配置文件会在首次启动时自动生成
- 开启「启动时自动更新」后每次容器重启会检查 PyPI 最新版本
- 选择「开发版」频道将拉取预发布版本，可能存在不稳定情况

## 参考资料
- 官网: <https://www.erisdev.com>
- 文档: <https://github.com/ErisPulse/ErisPulse>
