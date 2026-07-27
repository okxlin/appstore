# JupyterLab

## 产品介绍

JupyterLab 是 Project Jupyter 的 Web 开发环境，可在浏览器中编辑和运行 notebook、代码、终端及数据文件。

## 主要功能

- 创建、编辑和运行 Jupyter Notebook
- 集成文本编辑器、终端、文件浏览器和交互式内核
- 使用标签页和分栏组织多个文档及计算任务

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。登录时使用安装表单生成或填写的访问令牌。生产环境应通过可信反向代理提供 HTTPS，避免令牌和 notebook 内容通过明文网络传输。

JupyterLab 是单用户服务，不提供多用户隔离。获得令牌的用户可以在容器内执行任意代码、打开终端并读写工作目录，因此只能向完全可信的用户开放。不要导入或打开来源不明的 notebook；执行前应检查代码单元、Markdown、富输出和扩展内容。

## 数据持久化

`APP_DATA_DIR` 挂载到 `/home/jovyan/work`，保存 notebook 和工作文件。该路径必须位于应用版本目录内，默认值为 `./data`；初始化脚本会拒绝绝对路径和目录外路径，并设置为官方镜像用户 UID `1000`、GID `100`。卸载不会删除绑定目录中的用户数据，升级或迁移前请单独备份。

## 安全与部署风险

- 容器以官方 `jovyan` 用户（UID `1000`、GID `100`）运行，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。没有启用 sudo 或 Docker Socket。
- 候选来源的 JupyterLab 4.6.1 扫描曾报告 `6` 个 High；本包固定到官方 `lab-4.6.2` 镜像后，`GHSA-gx64-gj6p-pc4c`（图片查看器 XSS）和 `GHSA-pppj-hq3g-57pj`（`overrides.json` XSS）已由 JupyterLab 4.6.2 修复。以下 `4` 项是对最终固定镜像重新扫描后的剩余风险。
- 固定镜像的 2026-07-28 Trivy 扫描发现 `0` 个 Critical 和 `4` 个 High。`CVE-2023-39663`（MathJax ReDoS）和 `CVE-2026-27601`（Underscore 递归结构拒绝服务）位于浏览器侧依赖；打开恶意 notebook 或富内容可能消耗浏览器 CPU/内存。只处理可信文件，并在修复版镜像可用后尽快更新。
- `GHSA-36hh-v3qg-5jq4`（PyO3 越界读取）和 `GHSA-4w2j-m93h-cj5j`（quinn-proto 远程内存耗尽）位于镜像内 `rattler` 包管理二进制，不在默认 Jupyter HTTP 请求路径中。包安装、环境更新和扩展安装仍应仅连接可信源，并在修复版镜像可用后更新。

## Introduction

JupyterLab is Project Jupyter's web-based development environment for editing and running notebooks, code, terminals, and data files.

## Features

- Create, edit, and run Jupyter notebooks
- Use integrated text editors, terminals, file browsers, and interactive kernels
- Organize multiple documents and compute tasks with tabs and split views

## Usage Notes

- Access the service at `http://<server-ip>:<port>` and sign in with the access token generated or supplied during installation. Use a trusted HTTPS reverse proxy for production access.
- JupyterLab is a single-user service without multi-user isolation. Anyone with the token can execute arbitrary code, open a terminal, and modify the work directory. Expose it only to fully trusted users and inspect untrusted notebooks, Markdown, rich output, and extensions before opening or running them.
- `APP_DATA_DIR` is mounted at `/home/jovyan/work`. It must remain relative to the application version directory and is prepared for the official UID `1000`, GID `100`. Back it up before upgrades or migration; uninstall does not delete bind-mounted user data.

## Security and Deployment Risks

- The container runs as the official non-root `jovyan` user, drops all Linux capabilities, enables `no-new-privileges`, and receives neither sudo nor a container-engine socket.
- The source candidate's JupyterLab 4.6.1 scan reported 6 High findings. Pinning the package to the official `lab-4.6.2` image resolves `GHSA-gx64-gj6p-pc4c` (image-viewer XSS) and `GHSA-pppj-hq3g-57pj` (`overrides.json` XSS), both fixed in JupyterLab 4.6.2. The following 4 findings are the residual risks from rescanning the final pinned image.
- A 2026-07-28 Trivy scan of the pinned image found 0 Critical and 4 High findings. `CVE-2023-39663` (MathJax ReDoS) and `CVE-2026-27601` (Underscore recursive-structure denial of service) affect browser-side dependencies; malicious notebooks or rich content may consume browser CPU or memory. Open trusted files only and update when a fixed image is available.
- `GHSA-36hh-v3qg-5jq4` (PyO3 out-of-bounds read) and `GHSA-4w2j-m93h-cj5j` (quinn-proto remote memory exhaustion) are in the image's `rattler` package-management binary and are not on the default Jupyter HTTP request path. Use trusted package and extension sources and update when fixed builds are available.

## References

- Project: <https://github.com/jupyterlab/jupyterlab>
- Official image source: <https://github.com/jupyter/docker-stacks/tree/main/images/base-notebook>
- Container usage: <https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html>
- Server security: <https://jupyter-server.readthedocs.io/en/latest/operators/public-server.html>
- License: <https://github.com/jupyterlab/jupyterlab/blob/v4.6.2/LICENSE> (BSD-3-Clause)
- Logo: <https://github.com/jupyterlab/jupyterlab/blob/v4.6.2/docs/source/_static/jupyter_logo.svg> (BSD-3-Clause)
