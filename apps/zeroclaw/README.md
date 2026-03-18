## 项目简介

ZeroClaw 是一个高性能、低资源占用、可组合的自主智能体运行时。ZeroClaw 是面向智能代理工作流的**运行时操作系统** — 它抽象了模型、工具、记忆和执行层，使代理可以一次构建、随处运行。

- Rust 原生实现，单二进制部署，跨 ARM / x86 / RISC-V。
- Trait 驱动架构，`Provider` / `Channel` / `Tool` / `Memory` 可替换。
- 安全默认值优先：配对鉴权、显式 allowlist、沙箱与作用域约束。

## 安装后如何访问

安装完成后访问：

- `http://<服务器IP>:<PANEL_APP_PORT_HTTP>`

**访问码通过容器日志获取**

## 数据存储（named volume）

本应用主数据存放在 Docker **named volume**：`zeroclaw-data`（容器内挂载到 `/zeroclaw-data`）。

- 卸载脚本会执行 `docker-compose down --volumes`，将同时删除该数据卷；如需保留数据，请先备份或避免删除 volume。

## 配置说明（简要）

- `API_KEY`：LLM 提供方 API Key
- `PROVIDER`：LLM 提供方
- `ZEROCLAW_MODEL`：可选模型覆盖
