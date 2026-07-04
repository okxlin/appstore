## Overview

This package provides a dedicated PHP-FPM runtime for 1Panel websites and is intended to be attached to OpenResty / website runtime management inside 1Panel.

It keeps the original purpose of the historical `php-unofficial` template, but the packaging now follows the current 1Panel PHP runtime contract so it can be created, managed, and rebuilt directly from the panel.

## Runtime Model

- This is a `php` runtime package, not a standalone web application.
- Version directories are grouped by PHP major line and currently ship `5`, `7`, and `8`.
- Runtime creation exposes PHP version selection, default extensions, package mirror selection, and the PHP-FPM port.

## Differences From The Legacy Template

- The old `SITE_PATH` field is no longer filled manually.
- 1Panel now injects `${PANEL_WEBSITE_DIR}` automatically when creating the PHP runtime.
- PHP-FPM is still exposed through `PANEL_APP_PORT_HTTP` for website binding.
- No manual `fastcgi_params` patching or separate third-party compose workflow is required anymore.

## How To Use

1. In 1Panel, open `Website -> Runtime -> PHP`.
2. Choose the `PHP` app source and then select the target major version directory.
3. Set the desired PHP version, extensions, package mirror, and PHP-FPM port.
4. After the runtime is created, bind the website to that PHP runtime.

## Notes

- If you choose the built-in `local` resource while creating a PHP runtime, that is the native 1Panel local PHP template path, not this app package.
- This package is meant to provide a containerized PHP-FPM runtime that can still be rebuilt with extra extensions.
- The website base directory comes from the 1Panel `WEBSITE_DIR` setting and is injected by the panel during deployment.
