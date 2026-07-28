# GIMP (Kasm)

## 产品介绍

GIMP (Kasm) 将 GIMP 图像编辑器作为浏览器工作区运行。镜像由 Kasm Technologies 构建，1Panel 应用包直接使用固定 digest，不在本地重打包镜像。

## 主要功能

- 在浏览器中使用完整的 Linux 图形界面
- 将用户配置、下载和工作文件保存在独立数据目录
- 通过 KasmVNC 的 HTTPS 入口和安装时随机生成的密码访问

## 访问说明

安装后访问 `https://<服务器 IP>:<HTTPS 端口>`，用户名为 `kasm_user`，密码为安装表单中的访问密码。镜像使用自签名证书，浏览器首次访问会显示证书警告；公网部署应在可信反向代理后使用有效 HTTPS 证书，并限制来源地址。

Kasm 官方说明，音频、上传、下载和麦克风透传等部分功能只有在完整 Kasm Workspaces 平台编排下才能完整使用。独立部署不应假定这些集成功能可用。

## 数据持久化

`APP_DATA_DIR` 挂载到 `/home/kasm-user`，保存用户配置和文件，默认值为版本目录下的 `./data`。该值必须是版本目录内的相对路径；生命周期脚本会拒绝绝对路径、目录逃逸和指向目录外的符号链接。卸载或迁移前请备份该目录；不要把多个实例指向同一目录。

`SHM_SIZE` 控制浏览器工作区共享内存，默认 `1024m`。大型图像或高分辨率会话可适当提高，但必须确认主机有足够内存。

## 版本与安全说明

- `workspaces-images` 使用 MIT 许可文本（SPDX: MIT），但上游声明只覆盖该仓库直接维护的源码，不自动覆盖镜像内第三方应用或依赖。各产品许可和商标条款仍独立适用；本应用包只引用上游镜像，不重分发镜像内容。
- 本包固定 Kasm 官方 `1.19.0-rolling-weekly` 在 2026-07-22 发布的多架构 digest，不会随远端标签静默变化。
- 2026-07-28 的 fresh Trivy 扫描为 `0 Critical / 5 High`。涉及 `wheel`、`jaraco.context` 和 `Mako`；前两项属于 Python 打包辅助依赖，Mako 是本地模板库，未发现它们位于 KasmVNC 对外 HTTPS 或密码校验请求路径。该评估只说明默认部署下未确认可远程触发，不等于漏洞不存在；后续更新镜像时必须重新扫描。
- 容器以上游 UID 1000 运行，移除全部 Linux capabilities，并启用 `no-new-privileges`。上游启动过程需要写入 `/dockerstartup` 和 `/var/run/pulse`，因此不能使用只读根文件系统。
- `VNC_PW` 通过 1Panel 随机密码字段传入并保存在应用 `.env` 中。不要复用其他系统密码，并限制 1Panel、Docker 和应用目录的读取权限。

## Introduction

GIMP (Kasm) runs the GIMP image editor as a browser-accessible workspace. Kasm Technologies builds the image, and this package references a pinned digest without rebuilding it.

The `workspaces-images` source uses the MIT license text (SPDX: MIT) only for code directly maintained in that repository. It does not extend to third-party applications or dependencies in the image. This package references the upstream image without redistributing its contents.

## Features

- Full Linux graphical application streamed through the browser
- Per-install persistence for user settings, downloads, and working files
- KasmVNC HTTPS access protected by an installation-time random password

Open `https://<server-ip>:<HTTPS-port>`, sign in as `kasm_user`, and use the access password generated during installation. The image presents a self-signed certificate. Use a trusted HTTPS reverse proxy and restrict source addresses for Internet-facing deployments.

`APP_DATA_DIR` persists `/home/kasm-user`. The image is pinned to the 2026-07-22 `1.19.0-rolling-weekly` multi-architecture digest. A fresh Trivy scan on 2026-07-28 found `0 Critical / 5 High`; see the Chinese security section above for reachability context and revalidation requirements.

## References

- Kasm official registry: <https://registry.kasmweb.com/1.1/>
- Docker Hub image and stand-alone instructions: <https://hub.docker.com/r/kasmweb/gimp>
- Pinned image source: <https://github.com/kasmtech/workspaces-images/blob/bafab6d531eefd5a5aa6f2c9088ebc8f02e12fae/dockerfile-kasm-gimp>
- Source license: <https://github.com/kasmtech/workspaces-images/blob/bafab6d531eefd5a5aa6f2c9088ebc8f02e12fae/LICENSE.md>
