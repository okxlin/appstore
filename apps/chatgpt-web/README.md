# ChatGPT Web

## 应用简介
使用 express 和 vue3 搭建的支持 ChatGPT 双模型演示网页。

英文说明：ChatGPT-enabled dual-model demo page built with express and vue3.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 | 40021 | 是 |
| PROXY_PORT | Socks代理端口，可选，和Socks代理地址一起时生效 | - | 否 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ACCESS_TOKEN | OPENAI ACCESS TOKEN（与 OPENAI API KEY 至少填一个）（https://chat.openai.com/api/auth/session） | - | 否 |
| REVERSE_PROXY | API 反向代理，可选（OPENAI ACCESS TOKEN 时默认启用，需要注意可用性） | https://bypass.duti.tech/api/conversation | 否 |
| API_KEY | OPENAI API KEY（与 OPENAI ACCESS TOKEN 至少填一个） | - | 否 |
| API_MODEL | API 模型，可选，设置 OPENAI API KEY 时可用（https://platform.openai.com/docs/models） | gpt-3.5-turbo | 否 |
| API_BASE_URL | API 接口地址，可选，设置 OPENAI API KEY 时可用 | https://api.openai.com | 否 |
| SECRET_KEY | 访问权限密钥，可选(强烈建议填写) | chatgptweb | 否 |
| REQUEST_LIMIT | 每小时最大请求次数，可选，默认无限 | 0 | 否 |
| TIMEOUT | 超时，单位毫秒，可选 | 60000 | 否 |
| PROXY_HOST | Socks代理地址，可选，和Socks代理端口一起时生效 | - | 否 |
| PROXY_USERNAME | Socks代理用户名，可选，和Socks代理地址一起时生效 | - | 否 |

## 使用说明
### 常见问题
Q: 为什么 `Git` 提交总是报错？

A: 因为有提交信息验证，请遵循 [Commit 指南](https://github.com/Chanzhaoyu/chatgpt-web/blob/main/CONTRIBUTING.md)

Q: 如果只使用前端页面，在哪里改请求接口？

A: 根目录下 `.env` 文件中的 `VITE_GLOB_API_URL` 字段。

Q: 文件保存时全部爆红?

A: `vscode` 请安装项目推荐插件，或手动安装 `Eslint` 插件。

Q: 前端没有打字机效果？

A: 一种可能原因是经过 Nginx 反向代理，开启了 buffer，则 Nginx 会尝试从后端缓冲一定大小的数据再发送给浏览器。请尝试在反代参数后添加 `proxy_buffering off;`，然后重载 Nginx。其他 web server 配置同理。

## 参考资料
- 官网: <https://github.com/Chanzhaoyu/chatgpt-web>
