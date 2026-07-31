## 产品介绍

**OliveTin** 提供一个简洁的 Web 界面，用于运行管理员预先定义的 Shell 命令。用户只能执行配置中明确允许的动作，适合将常用维护任务封装为按钮。

## 主要功能

- 将预定义命令显示为 Web 操作按钮。
- 显示命令输出、退出码、开始时间和完成状态。
- 支持动作参数、权限控制、计划任务、Webhook 和外部认证等进阶配置。
- 将动作配置与执行历史保存在可配置的数据目录中。

## 访问说明

- 安装后打开应用的 HTTP 端口即可访问。
- 默认配置只包含 `Hello from 1Panel` 测试动作，不挂载 Docker socket，也不启用特权模式、主机网络或远程控制动作。
- OliveTin 会执行配置文件中的 Shell 命令。添加动作前应审查命令、参数验证和访问权限，并避免将未启用认证的实例暴露到不可信网络。
- 如需 Docker、SSH 或主机管理能力，应根据上游安全文档单独设计最小权限部署；本应用包不会自动授予这些权限。

## 数据与升级

- 配置、动作执行结果和输出日志保存在安装表单选择的配置目录中。
- 首次安装会写入安全的起始配置；已有 `config.yaml` 不会被覆盖。
- 应用限制为单实例，以避免多个实例共用同一配置目录。
- 卸载脚本不会删除配置和日志。升级或卸载前请备份配置目录。
- `latest` 为浮动镜像，适合通过容器更新工具跟踪上游发布；固定版本用于可重复部署。

## 默认工作流

打开 Web 页面并运行 `Hello from 1Panel`，执行结果应显示输出 `Hello from 1Panel` 和退出码 0。配置和执行历史会在容器或 1Panel 重启后保留。

## 参考资料

- 官网：<https://www.olivetin.app>
- 文档：<https://docs.olivetin.app>
- 项目仓库：<https://github.com/OliveTin/OliveTin>
- 容器镜像：<https://hub.docker.com/r/jamesread/olivetin>

## Introduction

OliveTin provides a Web interface for safely invoking shell commands predefined by an administrator.

## Features

- Present approved commands as buttons and show their output and exit status.
- Persist configuration and execution history across restarts.
- Extend the default configuration with reviewed arguments, access control, schedules, and webhooks.
