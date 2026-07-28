# Moltis

## Introduction

Moltis is a persistent personal AI agent server written in Rust. It provides web chat, sessions and memory, scheduled tasks, messaging channels, voice features, skills, and model-provider configuration.

## Access And Initialization

- The web service defaults to port `13131`; the OAuth callback defaults to port `1455`.
- The package binds to `127.0.0.1` by default. Use a 1Panel HTTPS reverse proxy for remote access. Moltis uses HTTP inside the container and the reverse proxy terminates public TLS.
- The installation form generates a login password, or accepts a safe password from 16 to 128 characters. Moltis migrates it into its credential store on first start.
- No model provider or provider API key is bundled. Configure a provider in Settings after signing in.

## Data And Backup

Under `DATA_PATH`, `config` stores `moltis.toml`, authentication, and certificate configuration; `data` stores databases, sessions, memory, and runtime state. Back up the complete directory before upgrades or migration. Uninstall removes containers but preserves the bind-mounted data.

## Restricted Security Mode

This package intentionally uses a stricter deployment profile than the upstream Docker example:

- Command execution is fixed to the built-in WASM/WASI sandbox. No Docker or Podman socket is mounted.
- Browser automation and the host web terminal are disabled.
- The agent cannot add, remove, or restart MCP servers or select a remote execution node.
- The container root filesystem is read-only, runs as `1000:1001`, drops all Linux capabilities, and enables `no-new-privileges`.
- WASM mode supports built-in commands and `.wasm` programs inside the sandbox, not an arbitrary host shell. This restriction is required by the package security gate.

Do not manually enable the browser, host terminal, stdio MCP, SSH/node execution, or another sandbox backend. Those changes invalidate the audited boundary. Initialization and upgrade fail closed when an existing configuration no longer contains the required security settings.

## Image Vulnerability Notice

On 2026-07-28, Trivy scans of the pinned amd64 and arm64 images each reported `9 Critical / 124 High / 0 secrets`. The Critical records are in OS Perl, SQLite, GLib, libxml2, and npm CLI node-tar paths that the candidate process does not load or invoke, plus a MiniZip path not shipped by Debian's runtime `zlib1g` package. `CVE-2026-8376` affects only 32-bit Perl. The two reviewed Chromium High findings require a browser process; this package does not register the Browser tool and starts no Chromium process.

The exception applies only to the pinned image while WASM initializes successfully, the browser stays disabled, no container-runtime socket is mounted, and no stdio MCP server is enabled. Startup logs must contain `sandbox backend: wasm`. Stop and re-audit if logs report `restricted-host` or any fallback.

## Versions

- `latest` follows the upstream latest tag but is pinned to the audited OCI index digest.
- `20260723.03` pins the matching upstream release. Both tags resolved to the same multi-architecture OCI index during evaluation.

## References

- Website: <https://moltis.org/>
- Repository: <https://github.com/moltis-org/moltis>
- Documentation: <https://docs.moltis.org/>
- Docker documentation: <https://docs.moltis.org/docker.html>
- Pinned release: <https://github.com/moltis-org/moltis/releases/tag/20260723.03>
- License: <https://github.com/moltis-org/moltis/blob/20260723.03/LICENSE> (MIT)
