# nforwardauth

nforwardauth is a lightweight forward-auth service that lets Traefik, Caddy, Nginx, and other reverse proxies protect multiple sites with one login page.

## Features

- Validates usernames and passwords from a local passwd file
- Shares authenticated sessions across protected sites with a signed cookie
- Can pass the authenticated user through `X-Forwarded-User`
- Includes login rate limiting, secure cookies, and custom cookie-domain support

## Installation

Provide the public authentication host, an administrator username, and a strong password. The package generates a SHA-512 password hash locally; the plaintext password is not written to the passwd file.

nforwardauth must be called by a reverse proxy that supports Forward Auth or `auth_request`. Opening the application port directly only exposes the login service and does not protect another site. Publish the authentication host through HTTPS in production and leave Secure Cookies enabled.

Application state is stored in the version directory's `data` directory. Whether that data is removed during uninstall is controlled by the 1Panel data-removal option.

## Security

The authentication host, cookie domain, and protected sites must remain within the same trusted domain scope. Disable Secure Cookies only for controlled, HTTP-only LAN testing.
