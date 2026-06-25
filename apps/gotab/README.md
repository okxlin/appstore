# GoTab

## 应用简介
GoTab 是一个个性化浏览器新标签页、起始页、个人主页。

英文说明：Personalized browser new tab, start page, and personal homepage.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`1.6.1.6`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 端口 | 43009 | 是 |

## 数据持久化
- `./data/uploads:/app/uploads`
- `./data/sourceStore:/app/sourceStore`
- `./data/config.toml:/app/config.toml`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
#### 注意事项

（1）管理后台路径：管理员 - 我的 - 管理端，或者登陆后直接访问 /console 路径；

（2）后台设置的一些功能性开关，对应着/web/siteConfig.js 文件，已经做了版本缓存控制，如变更配置无效请检查服务缓存，其他需要注意缓存的文件为：html 结尾的，/background.js，以及/api/\*路径开头的；

（3）数据是跟着用户走的，不登录的情况下默认的只是在本地进行缓存。数据分为两类，一类是默认主页数据（管理员可以在个人中心右上角编辑默认主页数据，也可以在管理后台的功能开关中调整默认主页数据策略），另一类是用户数据；

## 参考资料
- 官网: <https://www.gotab.cn/>
- 文档: <https://github.com/dengxiwang/gotab-personal>
