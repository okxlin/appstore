<div align="center">

# Kirara AI Chatbot Framework

[![GitHub stars](https://img.shields.io/github/stars/lss233/chatgpt-mirai-qq-bot?style=social)](https://github.com/lss233/chatgpt-mirai-qq-bot)

</div>

## 概述

Kirara 是一个基于插件生态和工作流系统的 AI 聊天机器人框架，支持多种 AI 模型和即时通讯平台。

## 主要特性

- 支持多种 AI 模型：DeepSeek、Claude、Grok、OpenAI、Gemini、ChatGLM、Ollama
- 人设调教与虚拟女仆功能
- 语音对话支持
- 多平台支持：QQ、Telegram、Discord、微信等
- 插件系统扩展
- 工作流自定义

## 部署

### 使用 Docker Compose 部署（推荐）

```yaml
version: "3.8"
services:
  kirara-agent:
    image: lss233/kirara-agent-framework:latest
    container_name: kirara-agent
    restart: always
    volumes:
      - ./data:/app/data
    ports:
      - "${PANEL_APP_PORT_HTTP}:8080"
```

启动命令：

```bash
docker-compose up -d
```

### 直接使用 Docker 镜像

```bash
docker run -d \
  --name kirara-agent \
  --restart always \
  -v $(pwd)/data:/app/data \
  -p 8080:8080 \
  lss233/kirara-agent-framework:latest
```

## 配置

环境变量配置：

| 变量名 | 描述 | 默认值 |
|--------|------|--------|
| PANEL_APP_PORT_HTTP | HTTP 服务端口 | 8080 |
| DATA_PATH | 数据存储路径 | /app/data |

## 界面截图

（截图待添加）

## 交流与支持

- GitHub Issues: [https://github.com/lss233/chatgpt-mirai-qq-bot/issues](https://github.com/lss233/chatgpt-mirai-qq-bot/issues)
- QQ 群: 123456789
- Telegram 群: @kirara_chat

## 相关项目

- [Mirai](https://github.com/mamoe/mirai): QQ 协议实现
- [ChatGPT-Mirai](https://github.com/lss233/chatgpt-mirai-qq-bot): 项目基础

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lss233/chatgpt-mirai-qq-bot&type=Date)](https://star-history.com/#lss233/chatgpt-mirai-qq-bot&Date)
