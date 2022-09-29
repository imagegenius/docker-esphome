## docker-esphome

**moved to https://hub.docker.com/u/hydaz**

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/esphome) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/esphome?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-esphome/actions?query=workflow%3A"Auto+Builder+CI")

**This image has been adapted from [esphome/esphome](https://github.com/esphome/esphome/)**

#### Modifications:
| | Modified|
|--|--|
| Packages | N/A |
| Scripts | N/A |
| Base OS | Rebased to Alpine |
| Other | N/A |


[ESPHome](https://esphome.io/) is a system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation systems.

## Usage

```bash
docker run -d \
  --name=esphome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -p 6052:6052 \
  -v <path to appdata>:/config \
  --restart unless-stopped \
  vcxpz/esphome
```

[![template](https://img.shields.io/badge/unraid_template-ff8c2f?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-templates/blob/main/hydaz/esphome.xml)

## Cleanup Command
This container has an in-build utility to purge unused ESPHome and PlatformIO data, you can run the utility within the container wit the `cleanup` command.


## Upgrading ESPHome

To upgrade, all you have to do is pull the latest Docker image. We automatically check for ESPHome updates daily. When a new version is released, we build and publish an image both as a version tag and on `:latest`.
