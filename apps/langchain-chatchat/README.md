# LangChain-Chatchat

## 应用简介
基于 Langchain 与 ChatGLM 等语言模型的本地知识库问答。

英文说明：A LLM application aims to implement knowledge and search engine based QA based on Langchain and open-source or remote LLM API.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`0.2.10`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40208 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| GPU_DRIVER_TYPE | GPU 驱动的类型 | nvidia | 是 |

## 使用说明
- **需要注意查看项目`Wiki`先安装好对应环境**

- **`1Panel` `v1.10.3-lts`以下版本会覆盖`docker-compose.yml`的`gpu`设置，所以最好安装完成后检查一下，**
  **不对则用以下覆盖并在应用目录下手动执行`docker-compose down && docker-compose up -d`。**

```
version: '3'

services:
  langchain-chatchat:
    container_name: ${CONTAINER_NAME}
    restart: always
    networks:
      - 1panel-network
    ports:
      - "${PANEL_APP_PORT_HTTP}:8501"
    deploy:
      resources:
        limits:
          cpus: ${CPUS}
          memory: ${MEMORY_LIMIT}
        reservations:
          devices:
            - driver: ${GPU_DRIVER_TYPE}
              count: all
              capabilities: [gpu]
    image: registry.cn-beijing.aliyuncs.com/chatchat/chatchat:0.2.7 # 镜像版本，按需修改
    labels:  
      createdBy: "Apps"

networks:  
  1panel-network:  
    external: true

```

## 参考资料
- 官网: <https://github.com/chatchat-space/Langchain-Chatchat>
- 文档: <https://github.com/chatchat-space/Langchain-Chatchat/wiki>
