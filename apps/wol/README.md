# wol

## 产品介绍

wol 是一个 Wake-on-LAN 工具，可通过 Web 界面、命令行或定时任务向局域网设备发送魔术包。应用使用 YAML 文件保存设备、广播目标和定时任务。

## 主要功能

- 通过 Web 界面或命令行唤醒命名设备
- 为不同设备配置独立的广播地址和 UDP 端口
- 使用 Cron 表达式安排可选的自动唤醒任务
- 在 Web 界面中查看配置设备的在线状态

## 访问说明

默认地址为 `http://127.0.0.1:7777`。应用没有内置身份认证；远程访问时应使用带身份认证的 HTTPS 反向代理。

## 默认部署

- Web 界面默认监听 `127.0.0.1:7777`。如需从局域网直接访问，可将绑定地址改为 `0.0.0.0`，并同步配置防火墙和访问控制。
- `APP_DATA_DIR/config.yaml` 是权威配置文件。首次安装只在文件不存在时生成示例配置，升级不会覆盖用户修改。
- 示例设备使用本地管理地址 `02:00:00:00:00:01`，请在使用前替换为目标设备的真实 MAC 地址。
- 容器以 UID/GID `65532:65532` 运行，启用只读根文件系统、`no-new-privileges`，并丢弃全部 Linux capabilities。

## Host 网络说明

Wake-on-LAN 广播需要访问宿主机所在的局域网，因此本应用按上游建议使用 Host 网络。容器与宿主机共享网络命名空间，不经过 Docker 端口映射或隔离；安装前请确认 Web 端口未被占用。默认关闭特权 ICMP Ping，不授予 `NET_RAW` 或其他 capabilities。

应用本身不提供身份认证。不要将 Web 端口直接暴露到不受信任网络；如需远程使用，请通过带身份认证和 HTTPS 的反向代理发布。

## 配置与备份

编辑 `APP_DATA_DIR/config.yaml` 可管理设备、全局或逐设备广播地址、WOL UDP 端口和定时任务。编辑后通过 1Panel 重启应用使配置生效。定时任务使用 `TIME_ZONE` 指定的时区。

升级或迁移前备份整个 `APP_DATA_DIR`。恢复时保留 `config.yaml` 并确保 UID `65532` 可读取该文件及其父目录。

## Introduction

wol sends Wake-on-LAN magic packets from a web interface, CLI, or schedule. Machines, broadcast targets, and schedules are stored in a YAML configuration file.

## Features

- Wake named machines from a web interface or CLI
- Configure per-machine broadcast addresses and UDP ports
- Schedule optional wake actions with cron expressions
- View the reachability of configured machines in the web interface

## Default Deployment

- The web interface listens on `127.0.0.1:7777` by default. Change the bind address to `0.0.0.0` only when direct LAN access is required, then configure firewall and access controls.
- `APP_DATA_DIR/config.yaml` is authoritative. It is seeded only when missing and is never overwritten during upgrades.
- The sample machine uses the locally administered address `02:00:00:00:00:01`; replace it with the target machine's real MAC address before use.
- The container runs as UID/GID `65532:65532`, with a read-only root filesystem, no new privileges, and all Linux capabilities dropped.

## Host Networking

The package follows upstream guidance and uses host networking so Wake-on-LAN broadcasts can reach the host LAN. The container shares the host network namespace and does not receive Docker port isolation, so verify the selected web port is free before installation. Privileged ICMP ping stays disabled and no `NET_RAW` capability is granted.

The application has no built-in authentication. Do not expose its web port to an untrusted network; publish it through an authenticated HTTPS reverse proxy when remote access is required.

## References

- Project: <https://github.com/Trugamr/wol>
- Stable release: <https://github.com/Trugamr/wol/releases/tag/v0.3.0>
- Docker and configuration guide: <https://github.com/Trugamr/wol/blob/v0.3.0/README.md#using-docker>
- License: <https://github.com/Trugamr/wol/blob/v0.3.0/LICENSE.md> (MIT)
