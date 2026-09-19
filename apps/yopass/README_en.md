# Yopass

## Introduction

Yopass securely shares passwords, tokens, and other sensitive text. The browser encrypts content with OpenPGP before upload, and the decryption key never reaches the server. Links can expire automatically and can be consumed exactly once.

This package runs the official Yopass image with a non-persistent Memcached service isolated on an app-internal network. Pending secrets are intentionally lost when the app or cache restarts. Use a trusted HTTPS reverse proxy before handling real secrets.

## Features

- Browser-side OpenPGP encryption
- Expiring and one-time secret links
- Optional password protection and encrypted file uploads
- Isolated non-persistent cache with no published Memcached port
- Built-in service and dependency health checks

## Usage

Install the app and open `http://<server-address>:<app-port>`. Enter a secret, choose an expiry period and optional one-time reading, then create a share link. The URL fragment contains the decryption material; send the complete link only through a trusted channel.

The default backend is non-persistent Memcached. Pending secrets are lost after an app, cache, restart, upgrade, or uninstall. For real secrets, enable HTTPS through a 1Panel reverse proxy or another trusted proxy. If persistence across restarts is required, plan a supported external backend such as Redis according to the upstream documentation; that topology is outside this default package.

## References

- Website: <https://yopass.se/>
- Documentation: <https://yopass.se/docs>
- Source: <https://github.com/jhaals/yopass>
- Official image: <https://hub.docker.com/r/jhaals/yopass>
