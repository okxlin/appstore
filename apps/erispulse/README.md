# ErisPulse

Event-driven multi-platform bot development framework

## Description

ErisPulse is an event-driven multi-platform bot development framework based on Python. Through the unified OneBot12 standard interface, you can write code once and deploy bots on multiple platforms such as Yunhu, Telegram, OneBot, etc.

## Features

- **Event-Driven Architecture** - Clear event model based on OneBot12 standard
- **Cross-Platform** - Write modules once, run on all platforms
- **Modular Design** - Flexible plugin system, easy to extend
- **Hot Reload** - Reload code without restarting
- **Complete Toolchain** - CLI tools, package manager, and automation scripts

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| Port | Dashboard web port | 8000 |
| Data Path | Config file storage path | ./data |
| Timezone | Container timezone | Asia/Shanghai |
| Dashboard Token | Dashboard login password (required) | - |

## Usage

1. After installation, visit `http://<IP>:<Port>/Dashboard` in your browser
2. Log in with the Dashboard token you configured
3. Configure adapters and plugins in the Dashboard

## Links

- Website: https://www.erisdev.com
- GitHub: https://github.com/ErisPulse/ErisPulse
- Docker Hub: https://hub.docker.com/r/erispulse/erispulse
- Docs: https://github.com/ErisPulse/ErisPulse
