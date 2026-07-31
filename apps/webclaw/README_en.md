# WebClaw

## Introduction

WebClaw is a self-hosted, stateless REST API for extracting public web pages as clean Markdown, plain text, HTML, or structured JSON.

## Features

- Extract a page through `/v1/scrape`
- Return Markdown, plain text, HTML, LLM text, or JSON
- Crawl sites, map URLs, process batches, compare pages, and extract brand metadata
- Optionally enable Serper.dev search and WebClaw Cloud fallback
- Protect every `/v1/*` endpoint with a Bearer token

## Usage

- The `/health` endpoint is available without authentication.
- Send the generated API token in the `Authorization: Bearer ...` header for `/v1/*` requests.
- This package runs the open-source `webclaw-server`. Hosted anti-bot bypass, JavaScript rendering, multi-tenant features, and billing are not included.
- The service fetches URLs supplied by API clients. Enable HTTPS through a 1Panel reverse proxy before exposing it publicly and restrict token distribution.

## Optional Services

- `WEBCLAW_CLOUD_API_KEY` enables cloud fallback for protected sites.
- `SERPER_API_KEY` enables `/v1/search`. Leaving it blank does not affect local page extraction.

## Data

The open-source server is stateless and creates no database. 1Panel manages the API token and optional provider keys as application configuration.

## Links

- Website: https://webclaw.io
- Project: https://github.com/0xMassi/webclaw
- Image: https://github.com/0xMassi/webclaw/pkgs/container/webclaw
