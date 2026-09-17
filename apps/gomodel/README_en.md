# GoModel

## Introduction

GoModel is a lightweight multi-provider AI gateway with OpenAI- and Anthropic-compatible APIs, usage tracking, audit logs, budgets, rate limits, failover, and an administration dashboard.

## Features

- OpenAI- and Anthropic-compatible APIs
- Multiple providers, virtual models, and failover
- Managed API keys, budgets, rate limits, and access scopes
- Usage, cost, and audit reporting
- Built-in dashboard and provider configuration

## Usage

Open `/admin/dashboard` on the installed port and authenticate management requests with the generated master key. Add provider credentials from the Providers page, then call the model API with `Authorization: Bearer <master-key>` or a managed key.

The container runs as UID/GID `65532:65532` with a read-only root filesystem and persistent SQLite data under the configured application data directory. Back up the data directory and `.env` before upgrades, and keep the master key unchanged so existing clients remain authenticated.
