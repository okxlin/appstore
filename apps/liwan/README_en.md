# Liwan

## Introduction

Liwan is a lightweight, privacy-focused web analytics platform. It combines event collection, real-time reports, an administration interface, and embedded storage in a single container without requiring a separate database or cache service.

## Features

- Cookie-free pageview and custom event collection
- Real-time traffic, referrer, location, device, and session reports
- Multiple entities and projects with user access control
- Persistent users, projects, settings, and analytics data under one data directory

After the first start, open the `/setup?t=...` URL shown in the container logs to create the administrator account. Set the base URL to the actual protocol, hostname, and port used by browsers. The data directory must be writable by UID/GID `1000:1000`; the install script prepares a new empty directory and leaves it in place on uninstall. Back up the complete data directory before upgrades.
