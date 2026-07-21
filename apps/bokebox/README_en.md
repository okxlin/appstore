## Introduction

**BokeBox** is a private AI podcast studio that turns videos, links, documents, meetings, and course materials into listenable shows. The first-run wizard creates the administrator account and configures model services; there is no default password.

## Features

- **Multiple Sources**: Import videos, links, documents, and content sources provided by plugins.
- **Natural Narration**: Use AI to understand source material and rewrite it as a structured spoken script.
- **Custom Shows**: Configure host personas, voices, delivery, and show styles.
- **Listening Library**: Manage albums, covers, show notes, knowledge flashcards, and listening progress.
- **Open Extensions**: Use the built-in MCP endpoint and external Source, ASR, and TTS plugins.
- **Private Deployment**: Keep accounts, settings, jobs, and media files in local persistent storage.

## Usage

- After installation, open BokeBox through the Web port shown in the app details.
- The first visit opens the setup wizard. Create an administrator account and configure the required model, ASR, and TTS services.
- The app has no default account or password. Keep the administrator credentials you create in a safe place.

## Data and Upgrades

- Application data is stored in the installation directory's `data` subdirectory, including the SQLite database, settings, jobs, and media files.
- Back up the application data in 1Panel before upgrading or recreating the container.

## Security Notes

- The app stores API keys for third-party model services. Deploy it only on a trusted network and use HTTPS through a reverse proxy when exposing it externally.
- Upstream `/api/health` currently returns HTTP 500 until a usable TTS service is configured, so this app package disables the image's built-in healthcheck. The first-run wizard and Web service remain available.
- The image removes `npm` from the final runtime filesystem, but Trivy may still report vulnerabilities from that deleted toolchain in historical image layers. It is not on the runtime path; continue to monitor upstream image updates.
