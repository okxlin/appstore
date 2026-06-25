# ZeroClaw

## 应用简介
一个高性能、低资源占用、可组合的自主智能体运行时。

英文说明：A high-performance, low-resource, composable autonomous agent runtime.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`0.8.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 42617 | 是 |
| ZEROCLAW_GATEWAY_PORT | 网关端口（容器内） | 42617 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ZEROCLAW_ALLOW_PUBLIC_BIND | 允许容器内公网绑定（Docker） | true | 是 |
| API_KEY | 模型服务商 API Key | - | 否 |
| PROVIDER | 服务商 | - | 否 |
| ZEROCLAW_MODEL | 模型（可选） | - | 否 |

## 使用说明
### 配置说明（简要）

- `API_KEY`：LLM 提供方 API Key
- `PROVIDER`：LLM 提供方
- `ZEROCLAW_MODEL`：可选模型覆盖

## 参考资料
- 官网: <https://zeroclawlabs.ai>
- 文档: <https://www.zeroclawlabs.ai/docs>
- 源码: <https://github.com/zeroclaw-labs/zeroclaw>
