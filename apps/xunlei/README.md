# 迅雷

## 应用简介
提取自群晖平台的迅雷下载套件。

英文说明：Thunder download kit extracted from Synology platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.20.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40163 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data/data | 是 |
| DOWNLOAD_PATH | 下载路径 | ./data/downloads | 是 |
| XL_DIR_DOWNLOAD | 下载目录 (容器内) | /xunlei/downloads | 是 |
| XL_DIR_DATA | 数据目录 (容器内) | /xunlei/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| XL_DASHBOARD_IP | 控制台 IP | 0.0.0.0 | 是 |
| XL_DASHBOARD_USERNAME | 控制台用户名 | user | 否 |
| XL_DASHBOARD_PASSWORD | 控制台密码 | xunlei | 否 |
| XL_UID | 用户 ID | 1000 | 是 |
| XL_GID | 用户组 ID | 1000 | 是 |
| XL_PREVENT_UPDATE | 阻止更新 | true | 是 |
| XL_DEBUG | 调试模式 | false | 是 |
| HOSTNAME | 主机名 | mynas | 否 |
| PRIVILEGED_MODE | 特权模式开关 | true | 是 |

## 使用说明
注意，容器以`privileged`特权模式运行，注意安全问题。

另外，假如下载权限有问题，则修改映射的下载文件夹用户组权限为`1000:1000`。

***

## 参考资料
- 官网: <https://www.xunlei.com>
- 文档: <https://github.com/cnk3x/xunlei/tree/docker>
