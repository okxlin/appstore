# Douyin

## 产品介绍

Douyin 是一个使用 Vue 构建的抖音风格短视频前端项目。官方镜像将构建后的静态页面通过 Nginx 提供服务。

## 主要功能

- 短视频浏览、切换与交互界面
- 抖音风格的桌面端和移动端布局
- 使用项目内置演示数据，无需数据库或后端服务

## 访问说明

- 安装后通过面板中配置的 Web 端口访问。
- 应用是静态前端演示，不提供真实抖音账号登录、内容发布或数据同步能力。
- 页面运行时会从 `lib.baomitu.com` 加载 Vue、Vue Router 和 Mock.js；客户端需要能够访问该 CDN。
- 容器没有持久化数据目录；重建或升级不会保存浏览器之外的运行状态。

## 参考资料

- 源代码：<https://github.com/zyronon/douyin>
- 官方 Docker 部署说明：<https://github.com/zyronon/douyin/blob/master/README.md#%E9%83%A8%E7%BD%B2%E5%88%B0-docker>
- 许可证：GPL-3.0

## Introduction

Douyin is a Vue-based short-video frontend inspired by Douyin. The official image serves the built static site through Nginx.

## Features

- Short-video browsing, switching, and interaction UI
- Douyin-style desktop and mobile layouts
- Bundled demonstration data with no database or backend dependency
- The browser loads Vue, Vue Router, and Mock.js from `lib.baomitu.com`; clients need access to that CDN.
