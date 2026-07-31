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

- Highest-precedence environment overrides fix command execution to the built-in WASM/WASI sandbox. No Docker or Podman socket is mounted.
- Environment hard locks disable browser automation and the host web terminal.
- The MCP-mutation and remote-node deny list is also fixed by the environment, so the agent cannot override it.
- The container root filesystem is read-only, runs as `1000:1001`, drops all Linux capabilities, and enables `no-new-privileges`.
- WASM mode supports built-in commands and `.wasm` programs inside the sandbox, not an arbitrary host shell. This restriction is required by the package security gate.

Do not manually enable the browser, host terminal, stdio MCP, SSH/node execution, or another sandbox backend. Those changes invalidate the audited boundary. Initialization and upgrade check canonical TOML controls, while the container environment remains the authoritative hard lock even when an existing file uses alternative valid TOML table syntax.

## Image Vulnerability Notice

On 2026-07-28, Trivy scans of the audited amd64 and arm64 image snapshots each reported `9 Critical / 124 High / 0 secrets`. The Critical records are in OS Perl, SQLite, GLib, libxml2, and npm CLI node-tar paths that the candidate process does not load or invoke, plus a MiniZip path not shipped by Debian's runtime `zlib1g` package. `CVE-2026-8376` affects only 32-bit Perl. The two reviewed Chromium High findings require a browser process; this package does not register the Browser tool and starts no Chromium process.

The exception applies only to the audited image snapshot while WASM initializes successfully, the browser stays disabled, no container-runtime socket is mounted, and no stdio MCP server is enabled. The `latest` tag must be re-audited after it resolves to a new image. Startup logs must contain `sandbox backend: wasm`. Stop and re-audit if logs report `restricted-host` or any fallback.

## Versions

- `latest` follows the upstream moving tag without a digest so tools such as Watchtower can pull updates.
- The fixed `20260723.03` package retains the matching upstream release and audited digest. Both tags resolved to the same multi-architecture OCI index during evaluation.

## References

- Website: <https://moltis.org/>
- Repository: <https://github.com/moltis-org/moltis>
- Documentation: <https://docs.moltis.org/>
- Docker documentation: <https://docs.moltis.org/docker.html>
- Pinned release: <https://github.com/moltis-org/moltis/releases/tag/20260723.03>
- License: <https://github.com/moltis-org/moltis/blob/20260723.03/LICENSE> (MIT)
