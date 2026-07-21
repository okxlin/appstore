# 每日股票分析

## 产品介绍

每日股票分析是面向 A 股、港股和美股的 LLM 智能分析系统，聚合多数据源行情、实时新闻、技术指标和 AI 决策结果，并支持多渠道通知。

## 主要功能

- 聚合多市场行情、新闻与技术指标。
- 生成 AI 分析结果和决策仪表盘。
- 支持企业微信、飞书、Telegram、Discord、Slack 和邮件通知。
- 通过 WebUI 管理分析任务和系统配置。

## 访问说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 支持架构：amd64、arm64。
- 安装后通过应用表单设置的 HTTP 端口访问 WebUI。
- 首次访问时按页面提示设置管理密码，并在 WebUI 中配置行情、模型和通知服务所需的凭据。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ADMIN_AUTH_ENABLED | 管理密码（首次访问 WebUI 设置） | true | 否 |

## 安全提示

- 上游镜像包含浏览器自动化、数据分析和 Python 依赖，镜像扫描器可能报告继承自基础系统或依赖包的已知 High / Critical 漏洞。
- 建议及时更新应用，仅向可信网络开放 WebUI，并通过 HTTPS、强管理密码和反向代理访问控制降低风险。
- API Key、Webhook、邮箱密码等敏感信息应只在应用配置中填写，不要写入公开日志或分享配置文件。

## Introduction

Daily Stock Analysis is an LLM-powered analysis system for A-share, Hong Kong, and US markets. It combines market data, real-time news, technical indicators, AI-generated insights, dashboards, and multi-channel notifications.

## Features

- Multi-market quotes, news, and technical indicators.
- AI-generated analysis and decision dashboards.
- Notifications through WeCom, Feishu, Telegram, Discord, Slack, and email.
- Web-based task and configuration management.

## Access And Security

Open the configured HTTP port and complete the first-run administrator setup in the WebUI. Store market-data, model, and notification credentials only in the application configuration.

The upstream image includes browser automation, data-analysis, and Python dependencies. Image scanners may report inherited High or Critical vulnerabilities from the base system or dependency packages. Keep the app updated, restrict WebUI access to trusted networks, and use HTTPS plus strong access controls.

## 参考资料
- 官网: <https://github.com/ZhuLinsen/daily_stock_analysis>
- 文档: <https://github.com/ZhuLinsen/daily_stock_analysis/blob/main/docs/full-guide.md>
