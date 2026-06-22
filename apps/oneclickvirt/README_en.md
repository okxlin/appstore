## Usage Notes

> Before installing, please first install and run **MySQL** or **MariaDB** from the **App Store**, then select the database service in the installation form.
>
> The default Web UI port is **80**. After the container starts, please wait approximately **30 seconds** before accessing the Web UI.
>
> **`Frontend URL (FRONTEND_URL)`** is optional: leave it empty if accessing by IP directly; set it to the full URL (e.g. `https://your-domain.com`) if you need domain or HTTPS access — this affects CORS and OAuth2 callback configurations.
>
> Data persistence directory:
> - `./storage` → inside container `/app/storage` (configs, certs, logs, uploads, etc.)

## Product Overview

**OneClickVirt** is an extensible universal virtualization management control panel. It manages virtualization environments across multiple node servers via SSH or API, with support for automatic NAT port mapping, resource quota management, and distributing containers/VMs via voucher codes, invite codes, or OAuth2.

The control panel itself **does not require a public IP** on the machine it runs on — any accessible port for the frontend is enough. It was designed specifically to manage multiple virtualization nodes even without a public IPv4 address.

Full documentation: [www.spiritlhl.net](https://www.spiritlhl.net/en/guide/oneclickvirt/oneclickvirt_precheck.html)

> ⚠️ **Node requirement**: Managed nodes must have the public IP address directly bound to a network interface. Hosts where the public IP is provided through NAT/port forwarding (e.g. Alibaba Cloud VPC) are not supported.

> Open Source repo: [https://github.com/oneclickvirt/oneclickvirt](https://github.com/oneclickvirt/oneclickvirt)


## Supported Virtualization Platforms

| Platform | Instance Types |
|----------|----------------|
| Proxmox VE | container, vm |
| Incus | container, vm |
| LXD | container, vm |
| Docker | container |
| Podman | container |
| Containerd (nerdctl) | container |

## Key Features

- **Multi-Node Management**: Manage virtualization environments on multiple servers via SSH or API from a single control panel
- **Automatic NAT Port Mapping**: Supports IPv4/IPv6 auto port mapping across multiple network types (NAT IPv4, dedicated IPv4, pure IPv6, etc.), with automatic selection of the best mapping method per provider (native, device proxy, iptables, etc.)
- **Flexible Distribution**: Distribute containers/VMs via invite codes, voucher codes, or OAuth2; supports invite-only registration with per-level resource quotas
- **Resource Quota Management**: Set per-user limits on instance count, CPU, memory, disk, and bandwidth by user level
- **Traffic Statistics & Limits**: Precise IP-level and interface-level traffic tracking; supports user-level, instance-level, and provider-level limits; resets monthly
- **Built-in Image Catalog**: Pre-compiled images included for all supported platforms — no manual image hunting required; supports custom image sources
- **Internationalization**: Frontend supports Chinese/English language switching (Chinese by default)
- **Multi-Architecture Support**: Available for both `amd64` and `arm64` architectures
