# Microsoft 365 E5 Renew X

## 应用简介
Docker 版本的 Microsoft 365 E5 调用 API 续订服务。

英文说明：Docker version of Microsoft 365 E5 calls API renewal service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40206 | 是 |

## 数据持久化
- `./Deploy:/app/Deploy`
- `./appdata:/app/appdata`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- **如需修改配置文件请进入应用目录下 Deploy 文件夹，修改 `Config.xml` 配置文件。**
- **默认密码：`123456`**

## 参考资料
- 官网: <https://github.com/hongyonghan/Docker_Microsoft365_E5_Renew_X>
- 文档: <https://blog.csdn.net/qq_33212020/article/details/119747634>
