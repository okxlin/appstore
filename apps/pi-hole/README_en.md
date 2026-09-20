# Pi-hole

## Introduction

Pi-hole provides network-wide DNS filtering for ads, trackers, and unwanted domains. Open
`http://<server-ip>:<web-port>/admin/` after installation and sign in with the generated
administrator password.

## Features

- TCP and UDP DNS filtering
- Allowlists, blocklists, and regular-expression rules
- Scheduled Gravity list updates
- Per-client and per-domain query statistics
- Password-protected web administration

## Usage

Configure trusted clients or your router to use the 1Panel host IPv4 address and the selected
DNS port. Protect the DNS and web ports with host, cloud, and router firewall rules; do not expose
Pi-hole as a public recursive resolver. TCP and UDP port 53 may already be occupied by another DNS
service.

Persistent state is stored under `APP_DATA_DIR`, which must remain a relative path inside the
application version directory. Back up this directory before upgrading or uninstalling. The
administrator password is stored in the 1Panel application environment and should not be reused.
