# Codex Claude Workstation

## 应用简介
Codex Claude Workstation - 浏览器可访问的 Codex + Claude AI 编程工作站。

英文说明：Browser-accessible Codex + Claude AI workstation.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 访问端口 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOCKER_SOCK_SRC | Docker 套接字路径（留空禁用） | /var/run/docker.sock | 否 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| CUSTOM_ENV_FILE | 自定义环境变量文件 | ./data/custom.env | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CODE_SERVER_PASSWORD | code-server 密码 | change-me | 是 |
| ROOT_PASSWORD | Root 密码 | codex2024 | 否 |
| FIX_WORKSPACE_OWNERSHIP_RECURSIVE | 递归修复工作区权限 | false | 是 |
| GITHUB_TOKEN | GitHub 访问令牌 | - | 否 |
| GIT_AUTHOR_NAME | Git 作者名 | - | 否 |
| GIT_AUTHOR_EMAIL | Git 作者邮箱 | - | 否 |
| GIT_COMMITTER_NAME | Git 提交者名 | - | 否 |
| GIT_COMMITTER_EMAIL | Git 提交者邮箱 | - | 否 |

## 使用说明
### 首次登录

安装完成后进入容器执行 Codex 登录：

```bash
docker exec -it ${CONTAINER_NAME} bash
codex login --device-auth
```

### 注意事项

- 不支持 Chat Completions-only API（必须支持 OpenAI Responses API）
- 首次安装后需在 code-server 终端执行 `codex login` 认证
- 不默认启动 Codex App Server
- 容器以 `dev` 用户运行（非 root），可通过 ROOT_PASSWORD 切换至 root
- 代理默认不启动，按需通过 `supervisorctl start clash-meta|sing-box|xray` 启用
- 使用第三方 LLM provider 或中转站时，不要让模型直接处理未脱敏的密钥、token、私有配置；保留或启用 Docker Socket 前请确认你接受宿主 Docker 控制权暴露给容器内工具链的风险

## 参考资料
- 官网: <https://github.com/openai/codex>
- 源码: <https://github.com/okxlin/release-factory>
