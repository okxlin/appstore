# Claper

## 产品介绍

Claper 是一个面向演示的互动反馈平台，允许演讲者向观众收集实时问题、投票和反馈。

## 主要功能

- 演示活动和观众互动
- 实时问题、投票与反馈
- 将演示文稿上传到持久化存储

## 访问说明

- 安装后访问 `BASE_URL` 中配置的地址。
- 首次打开页面时，使用安装表单默认开启的账户创建流程创建管理员账户。
- `BASE_URL` 必须是用户实际访问 Claper 的 HTTP 或 HTTPS 地址；反向代理部署时请填写代理后的公开 URL。

## 数据库和存储

- 安装表单选择 1Panel 中已运行的 PostgreSQL 服务，Claper 会在安装任务中创建并关联独立的数据库和用户。
- 演示文稿保存在 Compose named volume `claper-uploads` 中。卸载应用不会自动删除该卷；删除卷前请先完成备份。
- 官方镜像启动命令会执行数据库迁移和种子初始化，然后启动 Phoenix 服务。

## 安全说明

- `SECRET_KEY_BASE` 用于签名会话和 Cookie。安装脚本会在值短于 64 个字符时生成并持久化 128 字符十六进制值，升级时不要覆盖它。
- 数据库凭据由 1Panel PostgreSQL service selector 生成和注入，不要在 Compose 或 `.env.sample` 中使用示例密码。

## 参考资料

- 官网：<https://claper.co/>
- 文档：<https://docs.claper.co/>
- 源代码：<https://github.com/ClaperCo/Claper>
- 官方 Docker Compose：<https://github.com/ClaperCo/Claper/blob/master/docker-compose.yml>

## Introduction

Claper is an interactive audience feedback platform for presentations, with live questions, polls, and audience feedback.

## Features

- Presentation events and audience interaction
- Live questions, polls, and feedback
- Persistent presentation uploads
