# VoceChat

## Introduction

VoceChat is a self-hosted chat service. Its server runs on your own host, and chat data is stored in the configured data directory.

## Features

- Private and group chats.
- A web client, with Android and iOS mobile clients also available.
- Self-hosted server and chat data.

## Deployment

- Set the access port and data directory in the 1Panel application form.
- The default web port is `40067`; the server listens on port `3000` inside the container.
- The data directory defaults to `./data`. Back it up in 1Panel before upgrading or migrating.
- Check firewall, security-group, and reverse-proxy rules when exposing the service.

## References

- [Official website](https://voce.chat)
- [Documentation](https://doc.voce.chat)
- [Server source](https://github.com/Privoce/vocechat-server-rust)
