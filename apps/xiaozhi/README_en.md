# What is Xiaozhi ESP32 Server?

**Xiaozhi ESP32 Server** is a Java enterprise-grade server for the Xiaozhi AI chatbot hardware ([xiaozhi-esp32](https://github.com/78/xiaozhi-esp32)), provided by the [xiaozhi-esp32-server-java](https://github.com/joey-zhou/xiaozhi-esp32-server-java) project. Built with Spring Boot 3 + Vue 3, it delivers an integrated "management console + server" solution.

## Features

- **Device monitoring**: online status, live conversations, and one-stop device binding management;
- **Voice customization**: multiple built-in ASR/TTS engines (local VOSK / Sherpa + Edge TTS / Volcano Engine, etc.) with voice and speaking-rate adjustment;
- **Persona switching**: custom agent personas and prompt templates with one-click role switching;
- **Conversation history**: full dialogue history with audio replay, plus knowledge-base augmented Q&A;
- **Multi-client access**: ESP32 devices (WebSocket), mini program, and web console.

## Prerequisites

Before installing this app, install a **MySQL** (8.x) or **MariaDB** (10.6+) app from the app store first. Select the installed database in the "Database Service" field during installation — 1Panel creates the database and user automatically, and the server applies its schema via Flyway migrations on first start.

## After Installation

1. Wait until all containers become healthy (the first start runs database migrations, about 1–2 minutes);
2. Open the console at `http://SERVER_IP:console_port` and sign in with the default account `admin` / password `123456` — **change the password immediately after the first login**;
3. Configure an LLM API key under "Model Management" in the console to start chatting (no keys are bundled);
4. ESP32 devices: point the device firmware OTA URL to `http://SERVER_IP:api_port/api/device/ota`, and the device will establish the real-time conversation over the WebSocket port.

> Tip: speech recognition uses the bundled local model and speech synthesis uses the free Edge TTS out of the box; switch to third-party APIs in the console for higher quality.

## Ports

| Port | Purpose |
| ---- | ---- |
| Console port (default 8084) | Web management console |
| API / OTA port (default 8091) | Server API and device OTA |
| Device WebSocket port (default 8092) | Real-time voice conversation for ESP32 devices |

## Resource Requirements

Recommended: 2 CPU cores and 4 GB+ available memory (the server and dialogue services reserve 2 GB each).

## Data & Upgrades

- Business data lives in the selected MySQL/MariaDB app — back it up together with that database app;
- Conversation audio (`data/audio`), uploads (`data/uploads`), Redis cache and logs are kept under the version directory's `data/` folder.

## More Documentation

- [Project home](https://github.com/joey-zhou/xiaozhi-esp32-server-java)
- [Docker deployment guide](https://github.com/joey-zhou/xiaozhi-esp32-server-java/blob/main/docs/DOCKER.md)
- [Configuration reference](https://github.com/joey-zhou/xiaozhi-esp32-server-java/blob/main/docs/CONFIGURATION.md)
- [Firmware build & flashing](https://github.com/joey-zhou/xiaozhi-esp32-server-java/blob/main/docs/FIRMWARE-BUILD.md)
