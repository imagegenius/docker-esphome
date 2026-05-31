# [imagegenius/esphome](https://github.com/imagegenius/docker-esphome)

[![GitHub Release](https://img.shields.io/github/release/imagegenius/docker-esphome.svg?color=007EC6&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/imagegenius/docker-esphome/releases)
[![GitHub Package Repository](https://shields.io/badge/GitHub%20Package-blue?logo=github&logoColor=ffffff&style=for-the-badge)](https://github.com/imagegenius/docker-esphome/packages)

ESPHome is a system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation systems.

[![esphome](https://esphome.io/_static/logo-text.svg)](https://esphome.io/)

## Variants

| Tag      | Description                 | Platforms    |
| -------- | --------------------------- | ------------ |
| `latest` | Alpine + latest ESPHome app | amd64, arm64 |

Pin a specific upstream ESPHome release with the version tag:

```text
ghcr.io/imagegenius/esphome:2026.5.1
```

## Requirements

- **Config volume**: mount `/config` for ESPHome projects and generated build data.
- **Optional device access**: pass USB serial devices through when flashing from the container.

## Usage

### Docker Compose

```yaml
---
services:
  esphome:
    image: ghcr.io/imagegenius/esphome:latest
    container_name: esphome
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - ESPHOME_DASHBOARD_USE_PING=false #optional
    volumes:
      - path_to_appdata:/config
    ports:
      - 6052:6052
    restart: unless-stopped
```

## Parameters

| Parameter                             | Function                                                                                     |
| ------------------------------------- | -------------------------------------------------------------------------------------------- |
| `-p 6052`                             | WebUI port                                                                                   |
| `-e PUID=1000`                        | UID for permissions — see below                                                              |
| `-e PGID=1000`                        | GID for permissions — see below                                                              |
| `-e TZ=Etc/UTC`                       | Timezone, see [this list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e ESPHOME_DASHBOARD_USE_PING=false` | Use ping instead of mDNS for device status                                                   |
| `-v /config`                          | ESPHome config and build data                                                                |

## User / Group IDs & umask

Set `PUID=1000` `PGID=1000` to match volume ownership on the host (`id user` to find yours). Optionally `UMASK=022` (works subtractively, not additively).

## Updating

```bash
docker pull ghcr.io/imagegenius/esphome:latest
docker stop esphome && docker rm esphome
# recreate with the same docker run parameters
docker image prune  # optional: remove dangling images
```

Or with compose: `docker compose pull && docker compose up -d`.

## Support

- Issues: <https://github.com/imagegenius/docker-esphome/issues>
- ESPHome: <https://esphome.io/>

## How this image is built

This repo is built with GitHub Actions, based on the workflow shape from [home-operations/containers](https://github.com/home-operations/containers).

- The container starts from [linuxserver/docker-baseimage-alpine](https://github.com/linuxserver/docker-baseimage-alpine).
- ESPHome is installed from the upstream PyPI release, with PlatformIO libraries warmed during build.
- Version and base-image inputs are selected by [`docker-bake.hcl`](docker-bake.hcl).
- s6-overlay bits live under [`root/`](root).
- Renovate tracks ESPHome and build input bumps from the bake annotations.
