## Introduction

**UniTerm** is a browser-accessible, multi-user terminal platform with an isolated workspace for every user. It supports SSH, RDP, SFTP, databases, Kubernetes, and container management, with a built-in AI Agent that can plan and execute multi-turn shell commands.

## Advantages

- **One operations workspace instead of many point tools**: Manage SSH terminals, file transfers, remote desktops, databases, containers, and Kubernetes from one workspace. Common MySQL/MariaDB administration can be handled by the built-in database tools, reducing the account, configuration, and context-switching overhead of phpMyAdmin, SSH utilities, SFTP clients, and separate database clients.

- **Broad database coverage**: Manage MySQL/MariaDB, PostgreSQL/CockroachDB, Oracle, SQL Server, SQLite, rqlite, Redis, MongoDB, and Elasticsearch from one interface, with schema browsing, query execution, data inspection and editing, and natural-language-assisted query generation.

- **Direct access to co-located container databases with less exposure**: When UniTerm and database containers run on the same host and share a Docker network, the container or service name can be used directly as the database host. No host-published database port or external address is required. MySQL/MariaDB, PostgreSQL, Redis, MongoDB, and other common databases can be connected, queried, browsed, edited, and diagnosed from one workspace, making local containerized databases substantially easier to manage. Docker, Podman, nerdctl, and Kubernetes resources can also be managed through configured SSH or cluster connections.

## Features

- **Multi-Protocol Access**: Connect through SSH, Telnet, Mosh, RDP, VNC, SFTP, FTP, WebDAV, S3, and more.
- **Browser-Based Multi-User Deployment**: Access from the browser while keeping each user's connections, keys, and personal data isolated.
- **Operations and AI Agent**: Manage databases, Kubernetes, and container resources, and let the AI Agent plan and run commands in the active terminal.
