## Introduction

**OpenClaw** is a **personal AI assistant** you run on your own devices.
It answers you on the channels you already use (WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, WebChat), plus extension channels like BlueBubbles, Matrix, Zalo, and Zalo Personal. It can speak and listen on macOS/iOS/Android, and can render a live Canvas you control. The Gateway is just the control plane — the product is the assistant.

If you want a personal, single-user assistant that feels local, fast, and always-on, this is it.

## Highlights

- **Local-first Gateway** — single control plane for sessions, channels, tools, and events.
- **Multi-channel inbox** — WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, BlueBubbles, Microsoft Teams, Matrix, Zalo, Zalo Personal, WebChat, macOS, iOS/Android.
- **Multi-agent routing** — route inbound channels/accounts/peers to isolated agents (workspaces + per-agent sessions).
- **Voice Wake + Talk Mode** — always-on speech for macOS/iOS/Android with ElevenLabs.
- **Live Canvas** — agent-driven visual workspace with A2UI.
- **First-class tools** — browser, canvas, nodes, cron, sessions, and Discord/Slack actions.
- **Companion apps** — macOS menu bar app + iOS/Android nodes.
- **Onboarding + skills** — wizard-driven setup with bundled/managed/workspace skills.

## Post-Deployment Guide

After deployment, to ensure OpenClaw operates correctly and can be accessed externally, please follow these configuration steps:

1. **Update Configuration File**:
   Locate and edit `./data/conf/openclaw.json` within your application's mounted data directory. Update the `"allowedOrigins"` section with the URL address of your actual reverse proxy to allow corresponding CORS requests.

2. **Access and Register Device**:
   Append your token to the URL in your browser's address bar, for example: `http://your_address:port?token=xxx`. Use this link with the token to access and register your device.

3. **Approve Device Requests**:
   After registering the device, you need to connect to the container's terminal environment and execute the following commands to check and approve pairing requests:
   
   Run below commands and check do you have any pending pairing request:
   ```bash
   openclaw devices list
   ```
   
   If you have any pending request approve by below command:
   ```bash
   openclaw devices approve <request id>
   ```
