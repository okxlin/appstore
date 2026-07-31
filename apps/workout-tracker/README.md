# Workout Tracker

## 产品介绍

Workout Tracker 是面向个人、家庭或小团队的自托管运动记录服务，可保存跑步、骑行等训练，导入 GPX/FIT 轨迹，并在浏览器中查看路线、统计和每日指标。

## 主要功能

- 记录跑步、骑行等手动训练和每日身体指标
- 导入 GPX/FIT 轨迹并查看路线、距离与统计
- 支持多用户、管理员激活和个人资料设置
- 提供 API，便于受支持的运动应用上传记录

## 访问说明

- 首次启动会创建管理员账号 `admin`，初始密码也是 `admin`。登录后应立即在管理员用户编辑页修改密码。
- 应用默认使用 SQLite，数据库和运行状态保存在所选数据目录的 `data` 子目录，导入文件保存在 `imports` 子目录。
- 会话加密密钥由 1Panel 安装表单随机生成。备份或迁移时必须同时保留该密钥和数据目录，否则现有登录会话会失效。
- 可在安装表单中禁止新用户注册、关闭社交功能，或启用离线模式。离线模式不会调用外部地理编码服务。
- 应用支持多用户；新注册用户默认需要管理员激活。

## 安全与升级

- 固定版本镜像的预检发现多个已有修复版本的 High 级依赖问题，其中恶意 Markdown 可触发拒绝服务。请仅向可信用户开放账号，并在公开部署前复核当前镜像。
- 容器以 UID/GID `1000:1000` 运行，根文件系统只读，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。
- 更新前请备份数据目录和安装表单中的会话加密密钥。升级过程中不要删除 SQLite 数据库或 `imports` 目录。

## Introduction

Workout Tracker is a self-hosted activity log for individuals, families, and small groups. It records running, cycling, and other workouts, imports GPX/FIT tracks, and presents routes, statistics, and daily measurements in a browser.

## Features

- Record manual workouts and daily body measurements
- Import GPX/FIT tracks and inspect routes, distance, and statistics
- Manage multiple users with administrator activation and profile settings
- Upload activities from supported clients through the application API

Fresh installations create the administrator account `admin` with password `admin`; change it immediately after signing in. SQLite state and imports are stored below the selected data directory. Preserve that directory and the generated session encryption key when backing up or migrating the app.

## 参考资料

- 项目：<https://github.com/jovandeginste/workout-tracker>
- Docker 与配置说明：<https://github.com/jovandeginste/workout-tracker/blob/d72d10327582230c6e67c976e067a820eeadf68d/README.md>
- 许可证：<https://github.com/jovandeginste/workout-tracker/blob/d72d10327582230c6e67c976e067a820eeadf68d/LICENSE>（MIT）
