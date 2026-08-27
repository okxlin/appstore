# OpenCode Workstation

## 应用简介
OpenCode Workstation – 可持久化的多智能体开发运行环境。

英文说明：OpenCode Workstation – persistent multi-agent dev runtime.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Serve 端口 | 4096 | 是 |
| PANEL_APP_PORT_ACP | ACP 端口 | 8765 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR_1 | 工作区挂载目录 | ./data/workspace | 是 |
| APP_DATA_DIR_2 | HOME 配置挂载目录 | ./data/home-config | 是 |
| APP_DATA_DIR_3 | HOME Share 挂载目录 | ./data/home-share | 是 |
| APP_DATA_DIR_4 | Agents HOME 挂载目录 | ./data/home-agents | 是 |
| APP_DATA_DIR_5 | Claude HOME 挂载目录 | ./data/home-claude | 是 |
| APP_DATA_DIR_6 | OpenCode HOME 挂载目录 | ./data/home-opencode | 是 |
| DOCKER_SOCK_SRC | Docker 套接字路径（留空禁用） | /var/run/docker.sock | 否 |
| CUSTOM_ENV_FILE | 自定义环境变量文件 | ./data/custom.env | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| OPENCODE_RUNTIME_MODE | 运行模式 | serve | 是 |
| OPENCODE_BOOTSTRAP | 启动时安装 OpenCode | 1 | 是 |
| OMO_AUTO_INSTALL | 启动时自动安装 oh-my-opencode | 1 | 是 |
| DCP_INSTALL | 安装 DCP 插件 | 1 | 是 |
| OMO_CLAUDE_MODE | Claude 安装模式 | no | 是 |
| OMO_GEMINI_MODE | Gemini 安装模式 | no | 是 |
| OMO_COPILOT_MODE | Copilot 安装模式 | no | 是 |
| OMO_INSTALL_ARGS | 额外安装参数 | - | 否 |
| OPENCODE_NPM_PACKAGE | OpenCode 安装包 | opencode-ai | 否 |

## 使用说明
### 内部升级说明

重建容器会更新镜像层，但是否重新安装 / 刷新 OpenCode 与 oh-my-opencode，取决于当前表单开关和持久化目录状态。当前镜像不再预装 GPT Unlocked。

常见场景：

- **镜像层更新**：在 1Panel 中重建容器
- **刷新 OpenCode 本体**：进入容器执行 `/app/scripts/update-opencode-userland.sh`
- **刷新 oh-my-opencode 行为**：重建容器，或手动重新执行 `bunx oh-my-opencode install --no-tui ...`
- **额外环境变量**：升级脚本会确保 `CUSTOM_ENV_FILE` 存在；后续可直接编辑该文件追加自定义变量

### 升级迁移

- 从旧版本升级时，镜像首次启动会从生成的全局配置 `~/.config/opencode/opencode.json`（或 `.jsonc`）中移除 `opencode-gpt-unlocked` 及其 `experimental.refusal_patcher` 配置。
- 迁移是幂等的，只清理上述已废弃条目，不删除其它 provider、model、MCP、插件配置或用户覆盖文件。
- 镜像会将 OMO 的 `~/.omo` 桥接到持久化配置目录 `~/.config/.omo`，避免 OMO 刷新时跨挂载点迁移失败；旧 `.omo` 内容会先复制并保留备份。
- 旧 `.env` 中的 `GPT_UNLOCKED_*` 键不再由新 Compose 的显式环境映射读取；若它们仍留在 `custom.env`，虽然可能随通用环境文件进入容器，也不会被镜像读取或注册。升级前仍应按上面的数据目录范围完成备份。
- 持久化目录和 `CUSTOM_ENV_FILE` 由生命周期脚本限制为版本目录下的 `./...` 相对路径；若旧配置使用绝对路径或路径穿越，升级会停止并保留原数据，迁移路径后再重试。

### 注意事项

- 不要把真实密钥硬编码进 `opencode.user.json`，优先使用环境变量
- `~/.config/opencode/opencode.json` 是生成产物，不建议长期手工维护
- 若不需要容器内调用 Docker，请将 Docker Socket 路径留空

## 参考资料
- 官网: <https://github.com/okxlin/release-factory>
