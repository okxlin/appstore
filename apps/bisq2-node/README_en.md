# Bisq 2 Node

## Introduction

Bisq 2 Node is a self-hosted trading node for Bisq Connect. It joins the Bisq peer-to-peer network over bundled Tor so your phone can use a node you control. It is not a Bitcoin full node and does not download the Bitcoin blockchain.

## Features

- Joins the Bisq 2 peer-to-peer network through bundled Tor
- Provides a self-controlled trading node for Bisq Connect
- Displays node status and a time-limited pairing QR code
- Persists node identity, databases, and Tor state
- Keeps the node API on shared loopback with no host publication

## Usage

The management page is forcibly bound to `127.0.0.1:<local-management-port>` on the 1Panel host because it displays a pairing credential that can authorize node access and trade control. Reach it through an SSH tunnel, such as `ssh -L 8390:127.0.0.1:8390 user@server`, then open `http://127.0.0.1:8390/`. An existing authenticated HTTPS reverse proxy may target the loopback listener. Never rebind it to `0.0.0.0`, a public address, or an unauthenticated proxy.

Pairing codes default to 86400 seconds and may be configured from 300 through 86400 seconds. Close the page after pairing. A code is single-use and held only in node memory; every node start overwrites the QR file in `APP_DATA_DIR`, invalidating an unused code from the previous process. Node identity and paired-client records persist.

## Data and security

`APP_DATA_DIR` must be a relative path inside the application version directory. It stores node identity, keys, databases, Tor state, and pairing material. The uninstall hook does not remove this data; back it up before upgrades, migrations, or removal. Restrict access to 1Panel, Docker, and the host because administrators can read the mounted data.

The node API stays unpublished on shared loopback `127.0.0.1:8090`. The Web sidecar exposes only the static UI, pairing text, and fixed version proxy. Both containers use read-only root filesystems, `no-new-privileges`, and reduced capabilities.

The pinned upstream images may contain dependency vulnerabilities. Re-scan the images after upstream publishes fixes and upgrade promptly. A vulnerability review does not replace updating vulnerable dependencies.

## Network and trading risk

The node communicates with the public Bisq network and external services over Tor. Tor improves network privacy but cannot eliminate traffic correlation, malicious peers, upstream data errors, software vulnerabilities, or a compromised host. Running your own node does not make offers, counterparties, payment methods, dispute outcomes, or market data trustworthy. Confirm transaction details, back up identity data, and follow local legal and tax requirements.

## References

- Source and license: <https://github.com/bisq-network/bisq2/tree/v2.1.11>
- Official Bisq website: <https://bisq.network/>
- Bisq Connect support: <https://github.com/bisq-network/bisq-mobile/issues>
- Official Umbrel deployment submission: <https://github.com/getumbrel/umbrel-apps/pull/5850>
