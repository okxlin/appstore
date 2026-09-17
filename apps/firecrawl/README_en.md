# Firecrawl

## Introduction

Firecrawl is an open-source web data API that can be deployed on your own server for scraping, search, and content extraction.

## Features

- Scrape web pages and return content suitable for AI workflows.
- Provide APIs for search, crawling, and content extraction.
- Use Playwright for pages that require browser rendering.
- Use PostgreSQL, Redis, and RabbitMQ for job state and queues.

## Usage

- After installation, access the API at `http://SERVER_IP:PORT`; the default port is `3002`.
- Firecrawl database authentication is disabled by default. Use this package only on a trusted network; for public access, configure authentication and TLS in the 1Panel reverse proxy or another API gateway first. Changing `USE_DB_AUTHENTICATION` alone does not complete the authentication setup.
- API clients can follow the Firecrawl documentation and send `Authorization: Bearer <API_KEY>`.
- PostgreSQL, Redis, and RabbitMQ data is stored under `data/postgres`, `data/redis`, and `data/rabbitmq` in the application directory for 1Panel backups. Keep these directories when removing the application.
- PostgreSQL schema initialization runs on the first start, so the API may take a few minutes to become fully ready.
- OpenAI/Ollama fields are optional; basic scraping works without them. Other cloud integrations, proxy, search-engine, and Webhook variables are intentionally not exposed by this baseline package.
- Firecrawl is licensed under AGPL-3.0. If you modify it and provide the service to others, comply with the corresponding source-disclosure obligations.

## Security and Deployment Risks

- Authentication is disabled by default, so do not expose the API directly to an untrusted public network.
- The Playwright container uses `no-new-privileges`, drops all Linux capabilities, and uses a temporary cache; do not remove these controls for debugging.
- Dependency services are on the internal network only; PostgreSQL, Redis, and RabbitMQ ports are not published.

## Links

- [Website](https://firecrawl.dev)
- [Self-hosting documentation](https://github.com/firecrawl/firecrawl/blob/v2.11.359/SELF_HOST.md)
- [Upstream source](https://github.com/firecrawl/firecrawl)
