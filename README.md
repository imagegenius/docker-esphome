## docker-esphome

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/esphome) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/esphome?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-esphome/actions?query=workflow%3A"Auto+Builder+CI")

[ESPHome](https://esphome.io/) is a system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation systems.

## Usage

```bash
docker run -d \
  --name=esphome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -e DEBUG=true/false #optional \
  -e CLEANUP=true/false #optional \
  -p 6052:6052 \
  -v <path to appdata>:/config \
  --restart unless-stopped \
  vcxpz/esphome
```

[![template](https://img.shields.io/badge/unraid_template-ff8c2f?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-templates/blob/main/hydaz/esphome.xml)

## Environment Variables

| Name      | Description                                                                                                                                                                          | Default Value |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------- |
| `DEBUG`   | set `true` to display errors in the Docker logs. When set to `false` the Docker log is completely muted.                                                                             | `false`       |
| `CLEANUP` | set `true` to cleanup PlatformIO and ESPHome on container shutdown. See cleanup script [here](https://github.com/hydazz/docker-esphome/blob/main/root/etc/cont-finish.d/10-cleanup). | `false`       |

## Upgrading ESPHome

To upgrade, all you have to do is pull the latest Docker image. We automatically check for ESPHome updates daily. When a new version is released, we build and publish an image both as a version tag and on `:latest`.

## Fixing Appdata Permissions

If you ever accidentally screw up the permissions on the appdata folder, run `fix-perms` within the container. This will restore most of the files/folders with the correct permissions.
