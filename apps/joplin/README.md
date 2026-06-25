# Joplin（浏览器版）

## 应用简介
Joplin（浏览器版）。

英文说明：Joplin (browser).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.6.15`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40339 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 40340 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CUSTOM_USER | 访问用户名（Basic Auth） | admin | 是 |
| PASSWORD | 访问密码（Basic Auth） | - | 是 |
| SHM_SIZE | 共享内存大小（shm） | 1gb | 是 |
| TITLE | 浏览器页面标题 | Joplin | 否 |
| SELKIES_UI_TITLE | 侧边栏标题 | Selkies | 否 |
| DASHBOARD | 仪表盘界面，可选 selkies-dashboard、selkies-dashboard-zinc、selkies-dashboard-wish | selkies-dashboard | 否 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
### 密码访问（Basic Auth）

该镜像支持通过环境变量启用 **Basic HTTP Auth**：

- `CUSTOM_USER`：用户名
- `PASSWORD`：密码

> 安全提示：该容器 GUI 内含终端且具备高权限能力，不建议直接暴露公网；如需公网访问，建议放在反向代理后并增加更强的认证与访问控制。

## 参考资料
- 官网: <https://joplinapp.org>
- 文档: <https://github.com/linuxserver/docker-joplin>
- 源码: <https://github.com/laurent22/joplin>
