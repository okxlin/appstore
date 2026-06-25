# Open WebUI

## 应用简介
大语言模型 (LLMs) 的用户友好型网络界面。

英文说明：User-friendly WebUI for LLMs.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`main`、`gpu-cuda`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40245 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| OLLAMA_BASE_URL | Ollama 基础 URL (例：https://example.com) | - | 否 |
| OPENAI_API_KEY | OpenAI API 密钥 | - | 否 |

## 使用说明
- 首次注册的账户即为管理员账户。

- **安装 `gpu` 版本时，`1Panel` `v1.10.3-lts`以下版本会覆盖`docker-compose.yml`的`gpu`设置，所以最好安装完成后检查一下，**
  **不对则用以下覆盖并在应用目录下手动执行`docker-compose down && docker-compose up -d`。**

```
version: '3.3'
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:cuda
    container_name: ${CONTAINER_NAME}
    restart: always
    networks:
      - 1panel-network
    ports:
      - "${PANEL_APP_PORT_HTTP}:8080"
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - OLLAMA_BASE_URL=${OLLAMA_BASE_URL}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    extra_hosts:
      - "host.docker.internal:host-gateway"
    volumes:
      - "${DATA_PATH}:/app/backend/data"
    labels:  
      createdBy: "Apps"

networks:  
  1panel-network:  
    external: true

```

## 参考资料
- 官网: <https://openwebui.com>
- 文档: <https://docs.openwebui.com>
- 源码: <https://github.com/open-webui/open-webui>
