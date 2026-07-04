# Docker LXC

## 应用简介

`docker-lxc` 用于在 Docker 容器中运行一个带持久化根文件系统的 LXC 系统容器。默认没有 Web UI，安装完成后主要通过 SSH 或 1Panel 控制台进入系统。

本适配按上游镜像的真实约束整理：

- `/data` 是必需的数据卷，保存 `rootfs`、LXC 配置和机器状态。
- 额外挂载必须放到 `/vol/...`，才能在 LXC 内原样看到。
- 容器必须开启 `privileged: true`。
- 适配里还会共享宿主 PID namespace，并以读写方式挂载 `/sys/fs/cgroup`，这是当前 Docker/cgroup v2 环境下让 LXC 正常启动所需的宿主能力。
- 仅提供 `amd64` 架构。

## 版本

- `latest`: `micwy/lxc:latest`
- `1.2`: `micwy/lxc:v1.2`

## 表单参数

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | SSH 端口 | `40044` | 是 |
| `DATA_PATH` | LXC 根数据目录，对应容器内 `/data` | `./data/data` | 是 |
| `SHARED_PATH` | 共享宿主目录 | `./data/shared` | 是 |
| `SHARED_TARGET` | LXC 内共享挂载路径，必须以 `/vol/` 开头 | `/vol/shared` | 是 |
| `DISTRIBUTION` | 首次初始化使用的发行版 | `alpine` | 是 |
| `ALPINE_VERSION` | Alpine 初始化版本 | `latest-stable` | 是 |
| `ALPINE_EXTRA_PACKAGES` | 首次初始化额外安装的软件包 | 空 | 否 |
| `SSH_KEY` | 首次写入 root 的 SSH 公钥 | 空 | 否 |
| `LXC_HOSTNAME` | LXC 主机名 | `lxc1` | 是 |
| `USE_LXCFS` | 是否启用 LXCFS | `false` | 是 |
| `COPY_RESOLV_CONF` | 是否把外层容器的 `resolv.conf` 复制到 LXC | `true` | 是 |

## 部署前置

- 宿主机需要支持 `privileged` 容器，并允许共享宿主 PID namespace。
- 当前适配已包含 `pid: host`、`cgroup: host` 和 `/sys/fs/cgroup:/sys/fs/cgroup:rw`，这是在现代 Docker + cgroup v2 环境中让上游镜像稳定启动 LXC 所需的最小已验证组合。
- 仅适用于 `amd64` 宿主。

## 使用说明

1. 首次安装时，如果 `${DATA_PATH}/rootfs` 不存在，镜像会按照 `DISTRIBUTION` 初始化系统。
2. 如果留空 `SSH_KEY`，应用仍可启动，但需要先通过 1Panel 控制台进入容器，再自行添加公钥。
3. 默认只映射 SSH 端口。若你在 LXC 内另外运行 Web、数据库或其他服务，需要再为对应端口补充映射。
4. `SHARED_TARGET` 必须写成 `/vol/...`，例如 `/vol/shared`、`/vol/www`。安装脚本会做校验。
5. 调整目录或发行版前，请备份 `DATA_PATH` 与 `SHARED_PATH`。

## 风险说明

- 这个镜像当前仅有 `amd64` Docker manifest。
- 上游说明 `USE_LXCFS=true` 在部分 systemd 发行版上可能不稳定。
- 这是一个高权限应用：`privileged`、`pid: host` 与 `/sys/fs/cgroup` 读写挂载都会让容器直接接触宿主的关键能力。
- 面板安装后默认主要通过 SSH 或控制台使用，不是普通 Web 应用。
