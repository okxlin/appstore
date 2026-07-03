# Voicebox

## 产品介绍
Voicebox 是一个本地优先的 AI 语音工作室，提供语音克隆、语音生成、录音转写和 MCP 语音接口。

## 主要功能
- 本地 Web UI 与 REST API
- 语音克隆与多种 TTS / STT 模型
- 支持长文本语音生成与历史记录
- 内置 `/docs` OpenAPI 页面与 `/health` 健康检查

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口
```

首次启动时应用本体可立即访问，但模型会在首次使用相关功能时按需下载。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/app/data`，保存数据库、生成音频与应用数据
- `APP_MODELS_DIR`：持久化 `/app/models`，保存 Hugging Face 模型缓存

`VOICEBOX_CORS_ORIGINS` 可在反向代理或跨域调用 API 时按需填写，留空时使用镜像默认来源策略。

## Introduction
Voicebox is a local-first AI voice studio with web UI, REST API, voice cloning, speech generation, and transcription.

## Features
- Built-in web UI and REST API
- Voice cloning plus multiple TTS and STT models
- Persistent generations and local database
- OpenAPI docs at `/docs` and health endpoint at `/health`

## 版本说明
官方 GHCR 当前公开提供 `latest`、`dev`、`latest-cuda` 与 `dev-cuda` 标签，未发布可直接拉取的数字版稳定标签。本适配使用官方 `latest` 镜像。

## 参考资料
- 官网: <https://voicebox.sh>
- 文档: <https://docs.voicebox.sh/>
- 源码: <https://github.com/jamiepine/voicebox>
- Compose: <https://github.com/jamiepine/voicebox/blob/main/docker-compose.yml>
- GHCR: <https://ghcr.io/jamiepine/voicebox>
