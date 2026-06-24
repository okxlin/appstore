# Ting Reader

## 应用简介
轻量级自托管有声书平台，支持自动刮削元数据、多端播放进度同步。

英文说明：Lightweight self-hosted audiobook platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`1.4.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 3000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AUDIOBOOK_STORAGE_PATH | 有声书存储路径 | ./storage | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TING_SECURITY__JWT_SECRET | JWT 密钥 | - | 是 |

## 使用说明
### 默认账号

- 用户名：`admin`
- 密码：`admin123`

⚠️ 首次登录后请务必修改默认密码！

## 参考资料
- 官网: <https://www.tingreader.cn>
- 文档: <https://www.tingreader.cn/guide>
- 源码: <https://github.com/dqsq2e2/ting-reader>
