# FakeSSH

FakeSSH is a lightweight SSH honeypot that logs connection attempts and basic interaction without exposing a real shell.

## Access And Security

The honeypot listens on `PANEL_APP_PORT_SSH` (default `2222`). This port is intentionally exposed to untrusted traffic. Run the app only in a controlled or isolated environment.

The image runs as root so it can bind to port `22` inside the container. It stores no persistent application data.

## References

- [GitHub](https://github.com/fffaraz/fakessh)
- [Container image](https://github.com/fffaraz/fakessh/pkgs/container/fakessh)
