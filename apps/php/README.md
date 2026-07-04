## 应用简介

该应用用于在 1Panel 网站环境中提供独立的 PHP-FPM 运行环境，适合绑定到 OpenResty/网站运行时。

它延续了历史 `php-unofficial` 模板“给 1Panel 网站提供 PHP 运行环境”的用途，但运行结构已经对齐当前 1Panel PHP runtime 机制，便于直接在面板内创建、维护和升级。

## 运行方式

- 应用类型为 `php` runtime，不是普通独立 Web 应用。
- 版本目录按 PHP 主版本组织，当前提供 `5`、`7`、`8` 三个运行时分支。
- 创建 runtime 时可选择 PHP 具体版本、默认扩展、扩展包源和 PHP-FPM 端口。

## 与历史模板的差异

- 历史模板中的 `SITE_PATH` 不再手工填写。
- 当前 1Panel 会在创建 PHP runtime 时自动注入 `${PANEL_WEBSITE_DIR}`，用于挂载网站目录。
- PHP-FPM 仍通过 `PANEL_APP_PORT_HTTP` 对外提供服务，供网站绑定使用。
- 无需再像早期方案那样手工改 `fastcgi_params` 或单独维护第三方 compose 流程。

## 使用说明

1. 在 1Panel 中进入“网站 -> 运行环境 -> PHP”创建运行环境。
2. 选择应用来源中的 `PHP`，再选择目标主版本目录。
3. 按需设置 PHP 具体版本、扩展、镜像包源和 PHP-FPM 端口。
4. 创建完成后，将网站绑定到对应 PHP runtime 即可。

## 注意事项

- 如果在创建 PHP runtime 时选择的是面板内置“本地”资源，那是 1Panel 自带的本地 PHP 模板路径，与本应用包不同。
- 本应用包的目标是提供可构建、可扩展的容器化 PHP-FPM 运行环境。
- 网站目录基路径来自 1Panel 的 `WEBSITE_DIR` 设置，部署时由面板统一注入。
